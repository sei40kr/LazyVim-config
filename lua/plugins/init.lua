return {
  {
    "bufferline.nvim",
    keys = {
      { "<M-Left>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<M-Right>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<M-S-Left>", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer prev" },
      { "<M-S-Right>", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer next" },
    },
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
}
