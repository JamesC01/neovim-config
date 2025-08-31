require("config.lazy")

vim.lsp.enable("clangd")
vim.diagnostic.config({virtual_text=true})

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")

lspconfig["clangd"].setup {
    capabilities = cmp_capabilities
}

local luasnip = require("luasnip")

local cmp = require("cmp")

local cmp_confirm = function()
    return cmp.mapping.confirm({
        behaviour = cmp.ConfirmBehavior.Replace,
        select = true
    })
end

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        -- Confirm selected with tab or enter
        ["<CR>"] = cmp_confirm(),
        ["<Tab>"] = cmp_confirm(),

        --navigating through completion list
        ["<C-J>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-K>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        -- navigating through parameters in autocompleted function
        ["<C-H>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-L>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        
    }),
    sources = cmp.config.sources({
        {name = "nvim_lsp"},
        {name = "luasnip"},
    },
    {
        {name = "buffer"}
    }
    )
}


vim.cmd.colorscheme("catppuccin-mocha")

--Session stuff
vim.keymap.set("n", "<Leader>ms", ":mks!<cr>")
vim.keymap.set("n", "<Leader>ls", ":source Session.vim<cr>")

vim.keymap.set("n", "<Leader>fe", ":Explore<cr>")

vim.keymap.set("n", "<c-m-h>", ":-tabmove<cr>")
vim.keymap.set("n", "<c-m-l>", ":+tabmove<cr>")
vim.keymap.set("n", "<c-h>", "gT")
vim.keymap.set("n", "<c-l>", "gt")

vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "<c-o>", "<c-o>zz")
vim.keymap.set("n", "<c-}>", "<c-}>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- don't want to get into the habit of making too many custom short cuts, but
-- [[ and ]] are so common that I want it to be easier on my fingers.
vim.keymap.set("n", "{", "[[zz")
vim.keymap.set("n", "}", "]]zz")

--LSP diagnostics
-- Doesn't work. Ideally, [d should just execute the usual [d, but with an extra zz to center
-- it, but it doesn't work. I think it unbinds the default.
--vim.keymap.set("n", "[d", "[dzz", {remap = false})
--vim.keymap.set("n", "]d", "]dzz", {remap = false})

vim.keymap.set("x", "<leader>p", "\"_dP")

--Enclose with (), {}, [], "" and '' keymaps
--Note: There's a bug if you are doing this to the end of the string,
--      since the placement of the cursor is different. Usually the
--      cursor moves forward, but when there's no where else to move,
--      it stays, which moves the letter the cursor is on to after
--      the pair. Not a big problem 90% of the time, though.
vim.keymap.set("v", "<leader>(", "di()<Esc>P")
vim.keymap.set("v", "<leader>{", "di{}<Esc>p")
vim.keymap.set("v", "<leader>[", "di[]<Esc>p")
vim.keymap.set("v", "<leader>\"", "di\"\"<Esc>p")
vim.keymap.set("v", "<leader>'", "di''<Esc>p")

--Run usual build script, build.bat on windows, build on linux
vim.keymap.set("n", "<leader>b", ":!build.bat<cr>")
--vim.keymap.set("n", "<leader>b", ":!./build<cr>")

vim.keymap.set("n", "<leader>ss", ":ClangdSwitchSourceHeader<Enter>")

vim.opt.expandtab = false
vim.opt.softtabstop = 0
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.syntax = "on"
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true

vim.g.sessionoptions = "curdir, folds, tabpages, winsize"

-- LSP bindings

vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
