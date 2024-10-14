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
    opts = function(_, opts)
      opts.options.always_show_bufferline = true
    end,
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
    "dressing.nvim",
    opts = function(_, opts)
      opts.input = vim.tbl_extend("force", opts.input or {}, { relative = "editor" })
    end,
    optional = true,
  },
  {
    "edgy.nvim",
    opts = {
      exit_when_last = true,
    },
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
    "mason.nvim",
    enabled = false,
  },
  {
    "mason-lspconfig.nvim",
    enabled = false,
  },
  {
    "mason-nvim-dap.nvim",
    enabled = false,
  },
  {
    "neo-tree.nvim",
    dependencies = { "sei40kr/neo-tree-evil-mappings.nvim" },
    opts = function(_, opts)
      local evil_mappings = require("neo-tree-evil-mappings")
      opts.use_popups_for_input = false
      opts.commands = vim.tbl_extend("force", opts.commands or {}, evil_mappings.commands)
      opts.window = opts.window or {}
      opts.window.mappings = vim.tbl_extend("force", opts.window.mappings or {}, evil_mappings.mappings)
      opts.filesystem = opts.filesystem or {}
      opts.filesystem.filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".git" },
      }
      opts.filesystem.window = opts.filesystem.window or {}
      opts.filesystem.window.mappings =
        vim.tbl_extend("force", opts.filesystem.window.mappings or {}, evil_mappings.filesystem_mappings)
    end,
    optional = true,
  },
  {
    "noice.nvim",
    opts = function(_, opts)
      opts.presets.lsp_doc_border = true
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
    opts = function(_, opts)
      opts.icons = opts.icons or {}
      opts.icons.mappings = false
      opts.win = opts.win or {}
      opts.win.no_overlap = false
    end,
    optional = true,
  },
}
