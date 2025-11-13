vim.o.number = true
vim.o.relativenumber = false
vim.o.wrap = true
vim.o.expandtab = true
vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = "menuone,noselect"
vim.o.scrolloff = 12
vim.o.foldmethod = "indent"
vim.o.foldenable = false
vim.o.foldlevel = 99
vim.o.cursorline = false
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.autoindent = true
vim.o.smartindent = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.signcolumn = "yes"
vim.g.loaded_perl_provider = 0
vim.g.maplocalleader = " "

local set = vim.keymap.set

vim.pack.add({
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/BurntSushi/ripgrep",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/github/copilot.vim",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/rhysd/conflict-marker.vim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/nvim-pack/nvim-spectre",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/folke/lazydev.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.7.0" },
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
})

local hooks = function(ev)
	local name, kind = ev.data.spec.name, ev.data.kind

	if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
		vim.system({ "make" }, { cwd = ev.data.path })
	end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })

local function tmux_yabai_or_split_switch(wincmd, direction)
	local previous_winnr = vim.api.nvim_get_current_win()
	vim.cmd("silent! wincmd " .. wincmd)
	local current_winnr = vim.api.nvim_get_current_win()
	if previous_winnr == current_winnr then
		os.execute("tmux-window-navigation.sh " .. direction)
	end
end

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.keymap.set("n", "<C-h>", function()
			tmux_yabai_or_split_switch("h", "west")
		end, { buffer = true, desc = "Open parent directory" })
		vim.keymap.set("n", "<C-j>", function()
			tmux_yabai_or_split_switch("j", "south")
		end, { buffer = true, desc = "Open file" })
		vim.keymap.set("n", "<C-k>", function()
			tmux_yabai_or_split_switch("k", "north")
		end, { buffer = true, desc = "Open file" })
		vim.keymap.set("n", "<C-l>", function()
			tmux_yabai_or_split_switch("l", "east")
		end, { buffer = true, desc = "Open file" })
	end,
})

set("n", "<C-h>", function()
	tmux_yabai_or_split_switch("h", "west")
end, { silent = true })
set("n", "<C-j>", function()
	tmux_yabai_or_split_switch("j", "south")
end, { silent = true })
set("n", "<C-k>", function()
	tmux_yabai_or_split_switch("k", "north")
end, { silent = true })
set("n", "<C-l>", function()
	tmux_yabai_or_split_switch("l", "east")
end, { silent = true })
set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
set("n", "<leader>i", ":noh<CR>", { silent = true, desc = "hide search highlights" })
set("n", "<leader>dn", function()
	vim.diagnostic.jump({
		count = 1,
		severity = {
			min = vim.diagnostic.severity.INFO,
			max = vim.diagnostic.severity.ERROR,
		},
	})
end, { desc = "Next diagnostic" })
set("n", "<leader>dp", function()
	vim.diagnostic.jump({
		count = -1,
		severity = vim.diagnostic.severity.ERROR,
	})
end, { desc = "Previous diagnostic" })
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")
set("n", "<c-d>", "<c-d>zz", { desc = "Scroll down half screen" })
set("n", "<c-u>", "<c-u>zz", { desc = "Scroll down half screen" })

set("n", "º", "<cmd>cnext<CR>zz", { desc = "Go to next quickfix item" })
set("n", "∆", "<cmd>cprev<CR>zz", { desc = "Go to previous quickfix item" })

-- set("n", "º", ":m .+1<CR>==", { silent = true })
-- set("i", "º", "<Esc>:m .+1<CR>==", { silent = true })
-- set("v", "º", ":m '>+1<CR>gv=gv", { silent = true })
-- set("n", "∆", ":m .-2<CR>==", { silent = true })
-- set("i", "∆", "<Esc>:m .-2<CR>==", { silent = true })
-- set("v", "∆", ":m '<-2<CR>gv=gv", { silent = true })

set("n", "<leader>+", ':exe "vertical resize " . (winwidth(0) * 4/1)<CR>', { silent = true })
set("n", "<leader>-", ':exe "vertical resize " . (winwidth(0) * 1/4)<CR>', { silent = true })
set("n", "<C-b>", "<CMD>Oil<CR>", { desc = "Open Oil" })

require("gitsigns").setup()

require("nvim-highlight-colors").setup()

require("lualine").setup()

require("flash").setup({
	modes = {
		search = {
			enabled = true,
		},
		char = {
			enabled = true,
		},
	},
})

set("n", "s", function()
	require("flash").jump()
end, { desc = "Flash Jump" })

set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

-- require("github-theme").setup({})
-- vim.cmd("colorscheme github_dark_default")

require("tokyonight").setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})
vim.cmd([[ colorscheme tokyonight-night ]])

require("custom.auto_set_tabstop")

vim.g.conflict_marker_begin = "^<<<<<<<\\+ .*$"
vim.g.conflict_marker_common_ancestors = "^|||||||\\+ .*$"
vim.g.conflict_marker_end = "^>>>>>>>\\+ .*$"
vim.g.conflict_marker_highlight_group = ""

vim.cmd([[
        highlight ConflictMarkerBegin guibg=#2f7366
        highlight ConflictMarkerOurs guibg=#2e5049
        highlight ConflictMarkerTheirs guibg=#344f69
        highlight ConflictMarkerEnd guibg=#2f628e
        highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
]])

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({
	check_ts = true,
	enable_check_bracket_line = false,
	ts_config = {
		lua = { "string" },
		javascript = { "template_string" },
		javascriptreact = { "template_string" },
		typescript = { "template_string" },
		typescriptreact = { "template_string" },
	},
})

local ts_conds = require("nvim-autopairs.ts-conds")
npairs.add_rules({
	Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
	Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
})

require("nvim-ts-autotag").setup()
require("nvim-surround").setup()

require("spectre").setup({
	replace_engine = { ["sed"] = { cmd = "sed", args = { "-i", "", "-E" } } },
})

set("n", "<leader>sw", '<cmd>lua require("spectre").toggle()<CR>')

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		html = { "prettierd" },
		css = { "stylelint", "prettierd" },
		markdown = { "prettierd" },
		rust = { "rustfmt" },
		["_"] = { "trim_whitespace" },
		["*"] = { "codespell" },
	},
	format_on_save = {
		timeout_ms = 2000,
		lsp_format = "fallback",
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Format eslint on save",
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
	group = vim.api.nvim_create_augroup("FormatEslint", { clear = true }),
	callback = function(ev)
		vim.lsp.buf.code_action({
			context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
			apply = true,
		})
		vim.wait(100) -- Give LSP time to apply fixes
	end,
})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"cpp",
		"go",
		"lua",
		"python",
		"rust",
		"tsx",
		"javascript",
		"typescript",
		"vimdoc",
		"vim",
		"bash",
		"css",
		"gleam",
	},
	sync_install = false,
	ignore_install = {},
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<M-space>",
		},
	},
	modules = {},
})

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
		file_ignore_patterns = {
			"node_modules/",
			"%.git/",
			"%.tsbuildinfo$",
			"__image%-snapshots__/",
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

set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "[G]oto [D]efinition" })
set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
set("n", "gI", require("telescope.builtin").lsp_implementations, { desc = "[G]oto [I]mplementation" })
set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
		---@param client vim.lsp.Client
		---@param method vim.lsp.protocol.Method
		---@param bufnr? integer some lsp support methods only in specific files
		---@return boolean
		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("custom-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("custom-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({
						group = "custom-lsp-highlight",
						buffer = event2.buf,
					})
				end,
			})
		end

		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
					bufnr = event.buf,
				}))
			end, "[T]oggle Inlay [H]ints")
		end

		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_codeAction, event.buf) then
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ctions")
		end
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
	},
})

local blink_cmp = require("blink.cmp")

blink_cmp.setup({
	keymap = {
		preset = "default",
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },

		-- show with a list of providers
		["<C-space>"] = { "show", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = false,
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = { auto_show = false },
		menu = {
			draw = {
				treesitter = { "lsp" },
			},
		},
		trigger = {
			show_on_insert_on_trigger_character = true,
		},
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		min_keyword_length = 0,
		providers = {
			lsp = {
				min_keyword_length = 0,
			},
		},
	},

	fuzzy = { implementation = "prefer_rust_with_warning" },
})

local capabilities = blink_cmp.get_lsp_capabilities()

local servers = {
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
	cssls = {},
	css_variables = {},
	cssmodules_ls = {},
	eslint = {},
	stylelint_lsp = {},
	jqls = {},
	tailwindcss = {},
	vtsls = {},
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	-- Formatters and linters
	"stylua",
	"prettier",
	"prettierd",
	"eslint_d",
	"stylelint",
	"jsonlint",
	"jq",
})
require("mason").setup()
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

require("mason-lspconfig").setup({
	ensure_installed = {},
	automatic_installation = false,
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
})
