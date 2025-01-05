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
    "blink.cmp",
    opts = function(_, opts)
      opts.completion.list = { selection = "manual" }

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
    "fzf-lua",
    dependencies = { "nvim-telescope/telescope-symbols.nvim" },
    keys = function(_, keys)
      ---@param sources string[]
      ---@return nil
      local function insert_symbol(sources)
        ---@type string[]
        local files = vim.tbl_filter(function(file)
          return vim.tbl_contains(sources, vim.fn.fnamemodify(file, ":t:r")) and vim.fn.filereadable(file) == 1
        end, vim.api.nvim_get_runtime_file("data/telescope-sources/*.json", true))

        require("fzf-lua").fzf_exec(function(fzf_cb)
          coroutine.wrap(function()
            local co = coroutine.running()
            for _, file in ipairs(files) do
              ---@diagnostic disable: redefined-local
              vim.uv.fs_open(file, "r", 438, function(err, fd)
                assert(not err, err)
                vim.uv.fs_fstat(fd, function(err, stat)
                  assert(not err, err)
                  ---@cast stat uv.fs_stat.result
                  vim.uv.fs_read(fd, stat.size, 0, function(err, data)
                    assert(not err, err)
                    ---@type { [1]: string, [2]: string }[]
                    local entries = vim.json.decode(data)
                    for _, entry in ipairs(entries) do
                      fzf_cb(entry[1] .. " " .. entry[2])
                    end
                    vim.uv.fs_close(fd, function()
                      coroutine.resume(co)
                    end)
                  end)
                end)
              end)
              ---@diagnostic enable: redefined-local
              coroutine.yield()
            end
            fzf_cb()
          end)()
        end, {
          winopts = {
            title = " Symbols ",
            title_pos = "center",
          },
          actions = {
            default = function(selected)
              vim.cmd([[startinsert]])
              for _, entry in ipairs(selected) do
                local symbol = entry:match("^%S+")
                vim.api.nvim_put({ symbol }, "", true, true)
              end
            end,
          },
        })
      end

      keys[#keys + 1] = {
        "<leader>ie",
        function()
          insert_symbol({ "emoji" })
        end,
        desc = "Emoji",
      }
      keys[#keys + 1] = {
        "<leader>im",
        function()
          insert_symbol({ "math" })
        end,
        desc = "Math Symbol",
      }
      keys[#keys + 1] = {
        "<leader>in",
        function()
          insert_symbol({ "nerd" })
        end,
        desc = "Nerd Font Symbol",
      }
      keys[#keys + 1] = {
        "<leader>ig",
        function()
          insert_symbol({ "gitmoji" })
        end,
        desc = "Gitmoji",
        ft = "gitcommit",
      }
      keys[#keys + 1] = {
        "<leader>ij",
        function()
          insert_symbol({ "julia" })
        end,
        desc = "Julia Unicode Symbol",
        ft = "julia",
      }
    end,
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
      opts.sources = { "filesystem" }
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
    "sei40kr/nvimacs",
    event = { "InsertEnter", "CmdlineEnter" },
  },
  {
    "snacks.nvim",
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
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
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
