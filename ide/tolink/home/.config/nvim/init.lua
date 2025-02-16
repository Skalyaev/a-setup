vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.python3_host_prog = "~/.local/share/pyenv/bin/python"

vim.g.loaded_python_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.number = true

vim.opt.whichwrap:append("<")
vim.opt.whichwrap:append(">")

require("lazyload")
require("binds")
