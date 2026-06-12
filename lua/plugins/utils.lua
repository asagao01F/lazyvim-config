return {
  -- 1. Telescope（あいまいファイル検索 & 全ファイル内Grep検索）
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
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
}
