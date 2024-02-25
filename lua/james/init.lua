require("james/mappings")
require("james/options")

vim.cmd.colorscheme "catppuccin-frappe"

require'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "html", "css", "javascript", "typescript" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	highlight = {
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}
local ls = require"luasnip"
local cmp = require"cmp"

cmp.setup({
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end
	},
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({select = true})
			elseif ls.expand_or_jumpable() then
				ls.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if ls.jumpable(-1) then
				ls.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		['<C-j>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, {"i", "s"}),
		['<C-k>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, {"i", "s"}),
	}),

	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {{name = buffer}}),
})


local lspc = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspc.clangd.setup {
	capabilities = capabilities
}

lspc.tsserver.setup {
	capabilities = capabilities
}
