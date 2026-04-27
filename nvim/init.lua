if vim.fn.has('nvim-0.12') == 1 then
    require("config.init12")
else
    require("config.lazy")
end
