return {
  -- 1. Telescope（あいまいファイル検索 & 全ファイル内Grep検索）
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "gr", "<cmd>Telescope lsp_references<CR>", desc = "Go to references" },
    },
    opts = {},
  },

  -- 2. Oil.nvim（テキスト編集のように操作できるファイルエクスプローラ）
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon" },
        sync_with_cwd = true,
        view_options = { show_hidden = true },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory with Oil" })
    end,
  },

  -- 3. Mini.surround（爆速かつリピート対応の文字囲み・変更・削除）
  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "sa",
          delete = "sd",
          find = "sf",
          find_left = "sF",
          highlight = "sh",
          replace = "sr",
          update_n_lines = "sn",
        },
      })
    end,
  },

  -- 4. Flash.nvim（新世代EasyMotion、閃光の画面内ジャンプ）
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      search = { mode = "search" },
      labels = "asdfghjklqwertyuiopzxcvbnm",
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- 5. ToggleTerm（一発で浮かび上がる zsh ポップアップターミナル）
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        shell = "zsh",
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        direction = "float",
        float_opts = {
          border = "curved",
          winblend = 3,
        },
      })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-\\>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], opts)
      end

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          set_terminal_keymaps()
        end,
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antlr/antlr4", -- 構文解析用
      "nvim-treesitter/nvim-treesitter",
      -- お使いの言語に合わせてアダプターを追加（ここでは例として主要言語を網羅）
      "haydenmeade/neotest-jest",     -- TS / JS 用 (Jest)
      "marilari88/neotest-vitest",   -- TS / JS 用 (Vitest)
      "nvim-neotest/neotest-plenary", -- Lua 用
      "rouge8/neotest-rust",         -- Rust 用
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jest_cmd = require("neotest-jest.utils").find_jest_cmd,
          }),
          require("neotest-vitest"),
          require("neotest-rust"),
        },
        -- リッチなUI設定
        status = { virtual_text = true }, -- コードの横に成否アイコンを表示
        output = { open_on_run = true },  -- テスト失敗時に自動で詳細バッファを開く
      })

      -- 爆速テスト実行のキーバインド
      local neotest = require("neotest")
      -- スペース + tr: カーソルがある「その関数だけ」を実行（これが一番早い！）
      vim.keymap.set("n", "<leader>tr", function() neotest.run.run() end, { desc = "Run nearest test" })
      -- スペース + tf: 今開いている「ファイル全体」のテストを実行
      vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
      -- スペース + ts: テスト結果のサマリー（VS CodeのようなツリーUI）をトグル開閉
      vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      current_line_blame = true, -- 【プロ仕様】今いる行を「誰が・いつ・何のコミットで変えたか」を薄い文字で自動表示
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Hunk（変更の塊）単位での爆速移動
        map('n', ']c', function()
          if vim.wo.diff then vim.cmd.feedkeys(vim.api.nvim_replace_termcodes(']c', true, true, true), 'n') else gitsigns.nav_hunk('next') end
        end, { desc = "Next Git Change" })
        map('n', '[c', function()
          if vim.wo.diff then vim.cmd.feedkeys(vim.api.nvim_replace_termcodes('[c', true, true, true), 'n') else gitsigns.nav_hunk('prev') end
        end, { desc = "Prev Git Change" })

        -- その行だけの Git 操作
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = "Preview Git Hunk" }) -- 変更前のコードをポップアップ表示
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = "Reset Git Hunk" })     -- その変更だけを元に戻す
      end
    }
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- 美しいDiff（差分）表示に必須
      "nvim-telescope/telescope.nvim"
    },
    config = true,
    keys = {
      -- スペース + gg でいつでも最強のGitコントロール画面を起動
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit Status" },
    }
  },
}
