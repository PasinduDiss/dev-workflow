require("pasindu.core")
require("pasindu.plugins")
require("pasindu.lazy")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.py",
	command = "set filetype=python",
})
