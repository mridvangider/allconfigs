local ts_branch = 'master'
if vim.fn.has('nvim-0.12') == 1 then
    ts_branch = 'main'
end

return {
    {"nvim-treesitter/nvim-treesitter", branch = ts_branch, lazy = false, build = ":TSUpdate"}
}
