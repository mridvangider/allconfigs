if vim.fn.has('nvim-0.12') == 1 then
    require("init-0.12")
else
    require("config.lazy")
end
