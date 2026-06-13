vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim（プラグインマネージャー）の自動インストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 核心となる設定ファイルの読み込み
require("core.options")
require("core.keymaps")

-- plugins ディレクトリ内のプラグインを自動読み込み
require("lazy").setup("plugins")
