local read_file = require '../helper_function/read_file.lua'

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.alpha.dashboard.section.header.val = {read_file('.pacman_ghost_header.txt')}
lvim.builtin.alpha.dashboard.section.footer.val = { "Do one thing, and do it well." }
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

