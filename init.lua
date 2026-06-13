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
-- ==========================================================================
-- 🧭 画面最下部：キーコンボ起点ルート【常時カンニングペーパー】
-- ==========================================================================
-- 下部のメッセージ表示エリアを「2行」に広げて、カンペが途切れないように固定します
vim.opt.cmdheight = 2

local function display_permanent_guide()
  -- 1行目：スペースキーから始まる、あなたが作り込んだ強力な自作コンボ系統
  local line1 = "👑 [Space] ➡️  🎯 f:検索・ナビ待ち...  |  📦 g:Git管理待ち...  |  🚦 t:テスト検証待ち..."
  -- 2行目：Vim標準キーや単発キーから始まる、エディタの根幹操作系統
  local line2 = "🚀 [g]:LSPコード解読待ち  |  📺 [z]:画面・折畳み待ち  |  📂 [-]:Oil編集  |  🌿 [Ctrl+n]:NeoTree開閉  |  ⏮️ ⏭️ [[ ]]:Git差分移動"

  -- Neovimの最下部に2行同時にドカンと焼き付けます
  vim.api.nvim_echo({ { line1 .. "\n" .. line2, "MsgArea" } }, false, {})
end

-- Neovim起動時、バッファ（ファイル）切り替え時、コマンド終了時に常に再描画して消えないようにします
vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "CmdlineLeave" }, {
  callback = function()
    -- 少しだけタイミングを遅らせて、他のシステムメッセージに上書きされるのを防ぎます
    vim.defer_fn(display_permanent_guide, 50)
  end,
})