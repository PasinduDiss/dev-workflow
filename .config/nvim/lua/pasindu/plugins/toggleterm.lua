return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20, -- Size of the terminal (doesn't affect float)
			open_mapping = [[<C-\>]], -- Keybinding to toggle the terminal
			direction = "float", -- Use floating window for terminal
			float_opts = {
				border = "curved", -- Border style: 'single', 'double', 'shadow', 'curved'
				winblend = 3, -- Transparency level (0 = opaque, 100 = fully transparent)
				highlights = {
					border = "Normal", -- Highlight group for the border
					background = "Normal", -- Highlight group for the background
				},
			},
			shade_terminals = true, -- Shades the background of the terminal
			shading_factor = 2, -- Degree of shading for the terminal
			close_on_exit = true, -- Automatically close the terminal when the process exits
			shell = vim.o.shell, -- Use the default shell
		})
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<C-;>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
		keymap.set("t", "<C-;>", "<C-\\><C-n><cmd>ToggleTerm<CR>", { noremap = true, silent = true })
	end,
}
