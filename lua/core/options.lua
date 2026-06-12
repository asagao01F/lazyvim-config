local opt = vim.opt

opt.number = true           -- 行番号表示
opt.relativenumber = false
opt.clipboard = "unnamedplus" -- システムのクリップボードと同期
opt.splitright = true       -- 垂直分割時に右に開く
opt.splitbelow = true       -- 水平分割時に下に開く
opt.termguicolors = true    -- TrueColor対応（リッチなUIに必須）
opt.shiftwidth = 2          -- インデントの幅
opt.tabstop = 2
opt.expandtab = true        -- タブをスペースに変換
opt.ignorecase = true       -- 検索時に大文字小文字を区別しない
opt.smartcase = true        -- 大文字が含まれていたら区別する
