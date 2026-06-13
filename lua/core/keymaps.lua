local keymap = vim.keymap

-------------------------------------------------------------------------------
-- 1. 画面割（ウィンドウ）の操作
-------------------------------------------------------------------------------
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })   -- 垂直分割
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- 水平分割
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })    -- サイズを均等に
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })-- 現在の分割を閉じる

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-------------------------------------------------------------------------------
-- 2. タブ操作
-------------------------------------------------------------------------------
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })   -- 新しいタブを開く
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- タブを閉じる
keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Go to next tab" })   -- 次のタブへ
keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" }) -- 前のタブへ

-------------------------------------------------------------------------------
-- 3. 編集の快適化（トッププロ必須設定）
-------------------------------------------------------------------------------
-- インサートモードを抜ける（ホームポジションのまま）
keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-------------------------------------------------------------------------------
-- 4. インサートモード（入力中）でのカーソル移動
-------------------------------------------------------------------------------
keymap.set("i", "<C-h>", "<Left>", { desc = "Move cursor left in insert mode" })
keymap.set("i", "<C-j>", "<Down>", { desc = "Move cursor down in insert mode" })
keymap.set("i", "<C-k>", "<Up>", { desc = "Move cursor up in insert mode" })
keymap.set("i", "<C-l>", "<Right>", { desc = "Move cursor right in insert mode" })

-- 検索時のハイライトを一時的に消す
keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- ビジュアルモードで選択した行を、そのまま上下に移動（コードの並び替え）
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual block down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual block up" })

-- ページスクロール（Ctrl+d, Ctrl+u）時にカーソルを常に画面中央に固定
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- 検索移動（n, N）時にマッチした文字を常に画面中央に固定
keymap.set("n", "n", "nzzzv", { desc = "Next search match and center" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search match and center" })

-- ノーマルモードで m を押したとき、押しづらい %（対応する括弧へジャンプ）の挙動にする
vim.keymap.set("n", "m", "%", { remap = true, desc = "Jump to matching pairs" })
