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
          j = { k = "<C-\\><C-n>" },
        },
      },
    },
    event = { "CmdlineEnter", "InsertEnter", "TermEnter" },
  },
  {
    "blink.cmp",
    opts = function(_, opts)
      opts.completion.list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      }

      opts.completion.documentation = {
        auto_show = true,
        window = { border = "rounded" },
      }

      opts.keymap["<C-j>"] = { "select_next", "fallback" }
      opts.keymap["<C-k>"] = { "select_prev", "fallback" }
    end,
    optional = true,
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
    "noice.nvim",
    opts = function(_, opts)
      opts.presets.lsp_doc_border = true
    end,
    optional = true,
  },
  {
    "sei40kr/nvimacs",
    event = { "InsertEnter", "CmdlineEnter" },
  },
  {
    "snacks.nvim",
    ---@param opts snacks.Config
    opts = function(_, opts)
      opts.dashboard.preset.header = [[
██╗   ██╗ ██████╗ ███╗   ██╗██╗   ██╗██╗███╗   ███╗
╚██╗ ██╔╝██╔═══██╗████╗  ██║██║   ██║██║████╗ ████║
 ╚████╔╝ ██║   ██║██╔██╗ ██║██║   ██║██║██╔████╔██║
  ╚██╔╝  ██║   ██║██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║   ╚██████╔╝██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
      opts.dashboard.sections = {
        { section = "header" },
        {
          pane = 2,
          section = "terminal",
          cmd = "colorscript -e square",
          height = 5,
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              title = "Notifications",
              cmd = "gh-notify -s -a -n5",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "n",
              icon = " ",
              height = 5,
              enabled = true,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 7,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "p",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 7,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      }

      opts.picker.sources = {
        files = { hidden = true },
        explorer = { hidden = true },
        grep = { hidden = true },
      }
      opts.picker.win.preview = {
        wo = { wrap = true },
      }

      opts.scroll = { enabled = false }
    end,
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
