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
    "nvim-treesitter",
    opts = function(_, opts)
      opts.incremental_selection.keymaps = {
        init_selection = "<leader>v",
        node_incremental = "v",
        scope_incremental = false,
        node_decremental = "V",
      }
    end,
    keys = function()
      local keymaps = LazyVim.opts("nvim-treesitter").incremental_selection.keymaps
      return {
        { keymaps.init_selection, desc = "Increment Selection" },
        { keymaps.node_incremental, desc = "Increment Selection", mode = "x" },
        { keymaps.node_decremental, desc = "Decrement Selection", mode = "x" },
      }
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

      if LazyVim.has("nvim-treesitter") then
        for i, spec in ipairs(opts.spec) do
          if spec.desc == "Decrement Selection" or spec.desc == "Increment Selection" then
            opts.spec[i] = nil
          end
        end
        local keymaps = LazyVim.opts("nvim-treesitter").incremental_selection.keymaps
        opts.spec[#opts.spec + 1] = { keymaps.init_selection, desc = "Increment Selection" }
        opts.spec[#opts.spec + 1] = { keymaps.node_incremental, desc = "Increment Selection", mode = "x" }
        opts.spec[#opts.spec + 1] = { keymaps.node_decremental, desc = "Decrement Selection", mode = "x" }
      end
    end,
    optional = true,
  },
}
