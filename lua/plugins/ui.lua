return {
  -- 美麗なカラーテーマ
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        -- 💡 画面左側：独自の強力コンボ系（SpaceとSurround）
        lualine_c = {
          {
            function()
              return "[Space] ➡️ f:検索 │ g:Git │ t:テスト"
            end,
            color = { fg = "#f9e2af", gui = "bold" }, -- 鮮やかなイエロー
          },
        },

        -- 💡 画面右側：エディタ基本操作と各種ツリー
        lualine_x = {
          {
            function()
              return " [g]:LSP解読 │ [-]:Oil │ [C-n]:Tree │ [[ ]]:Git差分(ghp:プレビュー/ghr:戻す) | [s a/d/r txt-obj {[( ]: かこむ/はずす/かえる"
            end,
            color = { fg = "#a6e3a1", gui = "bold" }, -- 綺麗なネオングリーン
          },
        },

        lualine_y = { "filetype" },
        lualine_z = { "location" },
      },
    },
  },

  -- コマンドライン、通知、ポップアップをモダンにするUIエンジン
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.styling_textarea"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },

  -- インデントの視覚化
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
}
