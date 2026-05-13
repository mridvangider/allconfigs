return {
    {
        'https://github.com/neovim/nvim-lspconfig',
        config = function()
            vim.lsp.enable('basedpyright')
            vim.lsp.enable('luals')
            vim.lsp.enable('clangd')
        end
    },
}
