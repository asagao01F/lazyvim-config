return {
  -- ==========================================================================
  -- 1. Telescope（あいまいファイル検索 & 全ファイル内Grep検索）
  -- ==========================================================================
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>gr", "<cmd>Telescope lsp_references<CR>", desc = "Go to references" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Find Commands" },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob",
          "!**/.git/*",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    },
  },

  -- ==========================================================================
  -- 2. Oil.nvim（テキスト編集のように操作できるファイルエクスプローラ）
  -- ==========================================================================
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = false, -- 💡 修正: neo-treeと競合してエラーになるのを防ぐ
        columns = { "icon" },
        sync_with_cwd = true,
        view_options = { show_hidden = true },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory with Oil" })
    end,
  },

  -- ==========================================================================
  -- 2.5 Neo-tree.nvim（サイドバー型のモダンなファイルツリー）
  -- ==========================================================================
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-n>", "<cmd>Neotree toggle<cr>", desc = "NeoTree Toggle" },
    },
    opts = {
      window = {
        width = 30,
      },
      filesystem = {
        -- 💡 拡張設定: サイドバーでも .env などの隠しファイルを見えるようにする
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },

  -- ==========================================================================
  -- 3. Mini.surround（爆速かつリピート対応の文字囲み・変更・削除）
  -- ==========================================================================
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

  -- ==========================================================================
  -- 4. Flash.nvim（新世代EasyMotion、閃光の画面内ジャンプ）
  -- ==========================================================================
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

  -- ==========================================================================
  -- 5. ToggleTerm（一発で浮かび上がる zsh ポップアップターミナル）
  -- ==========================================================================
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

  -- ==========================================================================
  -- 6. Neotest（Spock / Java / TS 多言語フル対応高速テスト環境）
  -- ==========================================================================
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antlr/antlr4",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio", -- 💡 必須ライブラリを完全配備
      -- 各言語のアダプター群
      "rcarriga/neotest-java", -- 💡 Spock (JUnit Platform) / Java を動かす最強コア
      "haydenmeade/neotest-jest",
      "marilari88/neotest-vitest",
      "rouge8/neotest-rust",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          -- 💡 Spock / Java 用設定。build.gradle や pom.xml を自動解析
          require("neotest-java")({
            force_java_test_runner = "junit-platform",
          }),
          -- 💡 修正: バージョンアップで廃止された utils.find_jest_cmd のエラーを回避
          require("neotest-jest")({}),
          require("neotest-vitest"),
          require("neotest-rust"),
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
      })

      local neotest = require("neotest")
      vim.keymap.set("n", "<leader>tr", function() neotest.run.run() end, { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
      vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
    end,
  },

  -- ==========================================================================
  -- 7. Gitsigns & Neogit（歴史を操るGit完全統合UI）
  -- ==========================================================================
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
      current_line_blame = true,
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then vim.cmd.feedkeys(vim.api.nvim_replace_termcodes(']c', true, true, true), 'n') else gitsigns.nav_hunk('next') end
        end, { desc = "Next Git Change" })
        map('n', '[c', function()
          if vim.wo.diff then vim.cmd.feedkeys(vim.api.nvim_replace_termcodes('[c', true, true, true), 'n') else gitsigns.nav_hunk('prev') end
        end, { desc = "Prev Git Change" })

        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = "Preview Git Hunk" })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = "Reset Git Hunk" })
      end
    }
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = true,
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit Status" },
    }
  },

  -- ==========================================================================
  -- 8. Which-key（次に続く系統コマンドを完璧にナビゲートする案内人）
  -- ==========================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      wk.setup({
        preset = "modern", 
        win = { border = "single" },
        trigger_history = true,
        plugins = {
          marks = true,
          registers = true,
          spelling = { enabled = true, suggestions = 20 },
          presets = {
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
      })

      -- 1. グローバル（全体）で有効なルートマップを登録
      wk.add({
        -- 1打目：スペースキーから始まるコンボの案内
        { "<leader>f", group = "🎯 【検索・ナビ系】へのコマンド入力待ち... [f]" },
        { "<leader>g", group = "📦 【Git操作・管理系】へのコマンド入力待ち... [g]" },
        { "<leader>t", group = "🚦 【テスト・検証系】へのコマンド入力待ち... [t]" },
        { "<leader>gh", group = "🔍 【1マスの差分（Hunk）操作系】へ... [gh]" },
        
        -- 1打目：スペース以外の「標準キー」の案内
        { "g", group = "🚀 【LSP・コード解読系】へのコマンド入力待ち... [g]" },
        { "z", group = "📺 【画面スクロール・折りたたみ系】への入力待ち... [z]" },
        
        -- 💡 解決：文字列の末尾から Lua を勘違いさせる記号を完全に排除しました
        { "<bracketleft>", group = "⏮️  【前の要素（Git差分など）へ戻る】入力待ち" },
        { "<bracketright>", group = "⏭️  【次の要素（Git差分など）へ進む】入力待ち" },

        -- 単発キーの案内
        { "-", desc = "📂 【Oil】テキスト感覚でファイルを爆速編集する" },
        { "<C-n>", desc = "🌿 【Neo-tree】サイドバーのファイルツリーを開閉" },
      })

      -- 2. 【Oilの画面専用】のカンペ設定
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function()
          wk.add({
            { "g?", desc = "ℹ️  Oilの全操作コマンドヘルプを表示", buffer = true },
            { "<CR>", desc = "選択したファイルを開く / ディレクトリに入る", buffer = true },
            { "-", desc = "1つ上の親ディレクトリ（階層）に戻る", buffer = true },
            { "_", desc = "プロジェクトのルートディレクトリに一発ジャンプ", buffer = true },
          })
        end,
      })

      -- 3. 【Neo-treeの画面専用】のカンペ設定
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          wk.add({
            { "A", desc = "📁 新規ディレクトリ（フォルダ）を作成", buffer = true },
            { "a", desc = "📄 新規ファイルを作成", buffer = true },
            { "d", desc = "🗑️  選択したファイルを削除", buffer = true },
            { "r", desc = "🏷️  ファイル名をリネーム", buffer = true },
            { "c", desc = "📋 ファイルをコピー", buffer = true },
            { "x", desc = "✂️  ファイルを切り取り（移動準備）", buffer = true },
            { "p", desc = "📥 貼り付け（コピー/移動ファイルの配置）", buffer = true },
            { "R", desc = "🔄 ツリーの表示を最新状態に更新", buffer = true },
            { "?", desc = "ℹ️  Neo-treeの全ヘルプを表示", buffer = true },
          })
        end,
      })
    end,
  },
}