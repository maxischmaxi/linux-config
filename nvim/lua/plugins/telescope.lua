return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				preview = {
					filesize_limit = 10,
					mime_hook = function(fp, bufnr, opts)
						local is_image = function(filepath)
							local image_extensions = { "png", "jpg" } -- Supported image formats
							local split_path = vim.split(filepath:lower(), ".", { plain = true })
							local extension = split_path[#split_path]
							return vim.tbl_contains(image_extensions, extension)
						end
						if is_image(fp) then
							local term = vim.api.nvim_open_term(bufnr, {})
							local function send_output(_, data, _)
								for _, d in ipairs(data) do
									vim.api.nvim_chan_send(term, d .. "\r\n")
								end
							end
							vim.fn.jobstart({
								"catimg",
								"-w",
								"100",
								"-r",
								"2",
								fp,
							}, {
								on_stdout = send_output,
								stdout_buffered = true,
								pty = true,
							})
						else
							require("telescope.previewers.utils").set_preview_message(
								bufnr,
								opts.winid,
								"Binary cannot be previewed"
							)
						end
					end,
				},
				layout_config = { width = 0.9, height = 0.9 },
				ripgrep_arguments = {
					"--hidden",
					"--no-ignore",
					"--follow",
					"--column",
					"--line-number",
					"--color=always",
					"--smart-case",
				},
				file_ignore_patterns = {
					"kickstart.txt",
					"stockfish.js",
					"stockfish.wasm",
					"%.tsbuildinfo$",
					"stockfish.wasm.map",
					"./node%_modules/*",
					"node%_modules",
					"^node%_modules/*",
					"node%_modules/*",
					"**/%_%_image%-snapshots%_%_/**/*",
					"^%_%_image%-snapshots%_%_",
					"^%_%_image%-snapshots%_%_/*",
					"^./.git/",
					"./.git/",
					"%.o$",
					"%.a$",
					"%.out$",
					"%.obj$",
					"%.gch$",
					"%.pch$",
				},
			},
			pickers = {
				current_buffer_fuzzy_find = {
					previewer = false,
				},
				live_grep = {
					previewer = true,
					theme = "ivy",
				},
				find_files = {
					previewer = false,
					hidden = true,
					theme = "ivy",
					find_command = {
						"rg",
						"--files",
						"--hidden",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--smart-case",
						"--color=never",
						"--glob",
						"!**/.git/*",
					},
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		require("telescope").load_extension("fzf")

		local set = vim.keymap.set

		set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
		set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
		set("n", "gd", vim.lsp.buf.declaration, { desc = "[G]oto [D]efinition" })
		set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
		set("n", "gI", require("telescope.builtin").lsp_implementations, { desc = "[G]oto [I]mplementation" })
	end,
}
