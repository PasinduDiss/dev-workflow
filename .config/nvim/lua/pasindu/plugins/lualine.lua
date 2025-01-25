return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- configure lualine with modified theme
		lualine.setup({
			-- options = {
			-- 	theme = "everforest", -- Use the Everforest theme
			-- 	section_separators = { left = "", right = "" }, -- Slanted separators
			-- 	component_separators = { left = "", right = "" }, -- Inner slants
			-- 	globalstatus = true, -- Enable global statusline
			-- },
			-- tabline = {
			-- 	lualine_a = { "buffers" }, -- Buffers on the left
			-- 	lualine_b = {}, -- Leave this empty for clean separation
			-- 	lualine_c = { "filename" }, -- Current file name in the middle
			-- 	lualine_x = {}, -- Leave this empty for separation
			-- 	lualine_y = { "tabs" }, -- Tab numbers before the branch
			-- 	lualine_z = {
			-- 		{ "branch", icon = "" }, -- Git branch on the rightmost side
			-- 	},
			options = {
				theme = "everforest", -- Use the Everforest theme
				section_separators = { left = "", right = "" }, -- Slanting to the right
				component_separators = { left = "", right = "" }, -- Slanted inner separators
				globalstatus = true, -- Enable global statusline
			},
			tabline = {
				lualine_a = { "buffers" }, -- Buffers on the left
				lualine_b = {}, -- Empty for spacing
				lualine_c = { "filename" }, -- File name in the center
				lualine_x = {}, -- Empty for spacing
				lualine_y = { "tabs" }, -- Tabs section near the right
				lualine_z = {
					{ "branch", icon = "" }, -- Git branch on the far right
				},
			}, -- },
			sections = {
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})
	end,
}
