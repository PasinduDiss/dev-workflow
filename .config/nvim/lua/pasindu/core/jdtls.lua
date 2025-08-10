-- lua/my_jdtls_config.lua
local M = {}

-- --- helpers ---------------------------------------------------------------

local function detect_system()
	local uname = vim.loop.os_uname().sysname
	if uname == "Darwin" then
		return "mac"
	end
	if uname == "Linux" then
		return "linux"
	end
	-- everything else: assume Windows
	return "win"
end

local function mason_pkg(name)
	local ok, registry = pcall(require, "mason-registry")
	if not ok then
		vim.notify("[jdtls] mason-registry not found", vim.log.levels.ERROR)
		return nil
	end
	if not registry.has_package(name) then
		vim.notify(string.format("[jdtls] mason package '%s' not installed", name), vim.log.levels.ERROR)
		return nil
	end
	return registry.get_package(name)
end

local function first_glob(path)
	local s = vim.fn.glob(path, 1)
	if s == nil or s == "" then
		return nil
	end
	local list = vim.split(s, "\n", { trimempty = true })
	return list[1]
end

local function ensure_dir(path)
	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, "p")
	end
end

-- --- paths -----------------------------------------------------------------

local function get_jdtls()
	local jdt = mason_pkg("jdtls")
	if not jdt then
		return nil
	end
	local base = jdt:get_install_path()

	local launcher = first_glob(base .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	if not launcher then
		vim.notify("[jdtls] launcher jar not found under Mason install", vim.log.levels.ERROR)
		return nil
	end

	local system = detect_system()
	local config_dir = base .. "/config_" .. system
	local lombok = base .. "/lombok.jar"
	return launcher, config_dir, lombok
end

local function get_bundles()
	local bundles = {}

	local debug = mason_pkg("java-debug-adapter")
	if debug then
		local debug_base = debug:get_install_path()
		local jar = first_glob(debug_base .. "/extension/server/com.microsoft.java.debug.plugin-*.jar")
		if jar then
			table.insert(bundles, jar)
		end
	end

	local test = mason_pkg("java-test")
	if test then
		local test_base = test:get_install_path()
		local test_jars = vim.fn.glob(test_base .. "/extension/server/*.jar", 1)
		if test_jars and test_jars ~= "" then
			vim.list_extend(bundles, vim.split(test_jars, "\n", { trimempty = true }))
		end
	end

	return bundles
end

local function get_workspace()
	local home = vim.loop.os_homedir() or os.getenv("HOME") or "~"
	local workspace_root = home .. "/code/workspace/"
	local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local dir = workspace_root .. project
	ensure_dir(dir)
	return dir
end

-- --- keymaps ---------------------------------------------------------------

local function java_keymaps()
	vim.cmd(
		"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
	)
	vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
	vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
	vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

	local map = vim.keymap.set
	map(
		"n",
		"<leader>Jo",
		"<Cmd>lua require('jdtls').organize_imports()<CR>",
		{ desc = "[J]ava [O]rganize Imports", buffer = true }
	)
	map(
		"n",
		"<leader>Jv",
		"<Cmd>lua require('jdtls').extract_variable()<CR>",
		{ desc = "[J]ava Extract [V]ariable", buffer = true }
	)
	map(
		"v",
		"<leader>Jv",
		"<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
		{ desc = "[J]ava Extract [V]ariable", buffer = true }
	)
	map(
		"n",
		"<leader>JC",
		"<Cmd>lua require('jdtls').extract_constant()<CR>",
		{ desc = "[J]ava Extract [C]onstant", buffer = true }
	)
	map(
		"v",
		"<leader>JC",
		"<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
		{ desc = "[J]ava Extract [C]onstant", buffer = true }
	)
	map(
		"n",
		"<leader>Jt",
		"<Cmd>lua require('jdtls').test_nearest_method()<CR>",
		{ desc = "[J]ava [T]est Method", buffer = true }
	)
	map(
		"v",
		"<leader>Jt",
		"<Esc><Cmd>lua require('jdtls').test_nearest_method(true)<CR>",
		{ desc = "[J]ava [T]est Method", buffer = true }
	)
	map(
		"n",
		"<leader>JT",
		"<Cmd>lua require('jdtls').test_class()<CR>",
		{ desc = "[J]ava [T]est Class", buffer = true }
	)
	map("n", "<leader>Ju", "<Cmd>JdtUpdateConfig<CR>", { desc = "[J]ava [U]pdate Config", buffer = true })
end

-- --- main setup ------------------------------------------------------------

function M.setup_jdtls()
	local ok, jdtls = pcall(require, "jdtls")
	if not ok then
		vim.notify("[jdtls] 'jdtls' plugin not found", vim.log.levels.ERROR)
		return
	end

	local launcher, os_config, lombok = get_jdtls()
	if not launcher then
		return
	end

	local workspace_dir = get_workspace()
	local bundles = get_bundles() or {}

	local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".bazel" }
	local root_dir = jdtls.setup.find_root(root_markers) or vim.fn.getcwd()

	-- Capabilities
	local capabilities = {
		workspace = { configuration = true },
		textDocument = { completion = { snippetSupport = false } },
	}
	local ok_cmp, cmp_caps = pcall(require, "cmp_nvim_lsp")
	if ok_cmp then
		local merged = cmp_caps.default_capabilities()
		for k, v in pairs(merged) do
			capabilities[k] = v
		end
	end

	local ecc = jdtls.extendedClientCapabilities
	ecc.resolveAdditionalTextEditsSupport = true

	-- Heap size can be overridden: export JDTLS_HEAP=3g
	local heap = os.getenv("JDTLS_HEAP") or "2g"

	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx" .. heap,
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok,
		"-jar",
		launcher,
		"-configuration",
		os_config,
		"-data",
		workspace_dir,
	}

	-- formatter file (optional)
	local formatter_url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml"
	local formatter_exists = vim.fn.filereadable(formatter_url) == 1

	local settings = {
		java = {
			format = {
				enabled = true,
				settings = formatter_exists and {
					url = formatter_url,
					profile = "GoogleStyle",
				} or nil,
			},
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			gradle = { downloadSources = true },
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			saveActions = { organizeImports = true },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				importOrder = { "java", "jakarta", "javax", "com", "org" },
			},
			sources = { organizeImports = { starThreshold = 9999, staticThreshold = 9999 } },
			codeGeneration = {
				toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
				hashCodeEquals = { useJava7Objects = true },
				useBlocks = true,
			},
			configuration = { updateBuildConfiguration = "interactive" },
			referencesCodeLens = { enabled = true },
			inlayHints = { parameterNames = { enabled = "all" } },
		},
	}

	local init_options = { bundles = bundles, extendedClientCapabilities = ecc }

	local on_attach = function(_, _bufnr)
		java_keymaps()
		-- nvim-dap integration
		pcall(function()
			require("jdtls.dap").setup_dap()
			require("jdtls.dap").setup_dap_main_class_configs()
		end)

		require("jdtls.setup").add_commands()

		-- code lens refresh on save
		vim.lsp.codelens.refresh()
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.java" },
			callback = function()
				pcall(vim.lsp.codelens.refresh)
			end,
			group = vim.api.nvim_create_augroup("JdtlsCodeLens", { clear = true }),
		})
	end

	local config = {
		cmd = cmd,
		root_dir = root_dir,
		settings = settings,
		capabilities = capabilities,
		init_options = init_options,
		on_attach = on_attach,
	}

	jdtls.start_or_attach(config)

	if not formatter_exists then
		vim.notify(
			"[jdtls] Google formatter XML not found; formatting uses defaults.\nExpected at: " .. formatter_url,
			vim.log.levels.WARN
		)
	end
end

return M
