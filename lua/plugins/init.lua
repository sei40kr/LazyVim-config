return {
  {
    "max397574/better-escape.nvim",
    opts = {
      default_mappings = true,
      mappings = {
        i = {
          j = { k = "<Esc>" },
        },
        c = {
          j = { k = "<Esc>" },
        },
        t = {
          j = { k = "<Esc>" },
        },
      },
    },
    event = { "CmdlineEnter", "InsertEnter", "TermEnter" },
  },
  {
    "bufferline.nvim",
    keys = {
      { "<M-Left>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<M-Right>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<M-S-Left>", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer prev" },
      { "<M-S-Right>", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer next" },
    },
    optional = true,
  },
  {
    "conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.nix = { "nixfmt" }
    end,
    optional = true,
  },
  {
    "gitsigns.nvim",
    opts = {
      attach_to_untracked = true,
      current_line_blame = true,
    },
    optional = true,
  },
  {
    "lualine.nvim",
    opts = function(_, opts)
      opts.options = vim.tbl_extend("force", opts.options or {}, {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      })
    end,
    optional = true,
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      return vim.tbl_deep_extend("force", opts, {
        completion = {
          completeopt = "menu,menuone,noinsert,noselect",
        },
        mapping = {
          ["<CR>"] = LazyVim.cmp.confirm({ select = false }),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
        },
      })
    end,
    optional = true,
  },
  {
    "telescope.nvim",
    opts = function(_, opts)
      local actions = require("telescope.actions")
      return vim.tbl_deep_extend("force", opts, {
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            },
          },
        },
      })
    end,
    optional = true,
  },
  {
    "which-key.nvim",
    opts = {
      icons = { mappings = false },
    },
    optional = true,
  },
}
