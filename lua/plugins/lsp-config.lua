return {
    "https://github.com/neovim/nvim-lspconfig",
    init = function()
        require'lspconfig'.clangd.setup{}

        vim.keymap.set("n", "<leader>ss", ":ClangdSwitchSourceHeader<Enter>")
    end
}
