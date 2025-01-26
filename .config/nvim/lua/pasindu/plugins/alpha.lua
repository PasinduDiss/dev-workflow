return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#a3be8c", bg = "NONE" })
		dashboard.section.header.opts.hl = "AlphaHeader"

		-- Set header
		dashboard.section.header.val = {
			[[                                                                                  ]],
			[[                                   ██████                                         ]],
			[[	                             ████▒▒▒▒▒▒████                                     ]],
			[[                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                  ]],
			[[                            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                ]],
			[[                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                                  ]],
			[[                          ██▒▒▒▒▒▒  ▓▓▓▓  ▒▒▒▒  ▓▓▓▓                              ]],
			[[                          ██▒▒▒▒▒▒  ▒▒▓▓  ▒▒▒▒  ▒▒▓▓                              ]],
			[[                        ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                            ]],
			[[  ███╗   ██╗███████╗    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ██╗   ██╗██╗███╗   ███╗ ]],
			[[  ████╗  ██║██╔════╝    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒██    ██║   ██║██║████╗ ████║ ]],
			[[  ██╔██╗ ██║█████╗      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒      ▒▒▒▒▒▒██    ██║   ██║██║██╔████╔██║ ]],
			[[  ██║╚██╗██║██╔══╝      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒██    ╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
			[[  ██║ ╚████║███████╗    ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██     ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
			[[  ╚═╝  ╚═══╝╚══════╝    ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██      ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
			[[                        ██      ██      ████      ████                            ]],
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("p", "📙➡️  List Projects", "<cmd>Telescope project<CR>"),
			dashboard.button("e", "📄   New File", "<cmd>ene<CR>"),
			dashboard.button("fe", "📂   Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("ff", "🔍   Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("fs", "🔬   Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("wr", "🔄   Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", "🚪   Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
