return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			columns = {
				"icon",
				"size",
				"mtime",
			},
			buf_options = {
				buflisted = false,
				bufhidden = "hide",
			},
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},
			delete_to_trash = false,
			skip_confirm_for_simple_edits = true,
			prompt_save_on_select_new_entry = true,
			cleanup_delay_ms = 2000,
			lsp_file_methods = {
				enabled = true,
				timeout_ms = 1000,
				autosave_changes = false,
			},
			constrain_cursor = "editable",
			watch_for_changes = false,
			keymaps = {
				["="] = "actions.refresh",
			},
			use_default_keymaps = true,
			view_options = {
				show_hidden = true,
			},
		})
		vim.keymap.set("n", "<C-b>", "<CMD>Oil<CR>", { desc = "Open Oil" })
	end,
}
