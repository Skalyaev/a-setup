vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.whichwrap:append("<")
vim.opt.whichwrap:append(">")

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.number = true

vim.g.python3_host_prog = "~/.local/share/pyenv/bin/python"

require("lazyload")
require("binds")
