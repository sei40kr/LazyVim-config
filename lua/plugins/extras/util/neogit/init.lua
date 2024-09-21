return {
  {
    "NeogitOrg/neogit",
    dependencies = { "plenary.nvim", "telescope.nvim" },
    init = function()
      -- delete lazygit keymap for file history
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimKeymaps",
        once = true,
        callback = function()
          pcall(vim.keymap.del, "n", "<leader>gf")
        end,
      })
    end,
    opts = {
      graph_style = "unicode",
      telescope_sorter = function()
        if LazyVim.has("telescope-fzf-native.nvim") then
          return require("telescope").extensions.fzf.native_fzf_sorter()
        end
        return nil
      end,
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
    },
    config = function(_, opts)
      require("neogit").setup(opts)

      local augroup = vim.api.nvim_create_augroup("neogit_enable_copilot_in_commit_message", {})
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "NeogitCommitMessage",
        callback = function()
          -- HACK: List the commit message buffer to allow using Copilot in it.
          -- Be careful with this, as it may send the secrets in the diff to GitHub.
          vim.bo.buflisted = true
        end,
      })
    end,
    keys = {
      {
        "<leader>gg",
        function()
          require("neogit").open()
        end,
        desc = "Neogit",
      },
      {
        "<leader>gG",
        function()
          require("neogit").open({ cwd = LazyVim.root.get() })
        end,
        desc = "Neogit (cwd)",
      },
      {
        "<leader>gl",
        function()
          require("neogit").open({ "log" })
        end,
        desc = "Neogit Log",
      },
      {
        "<leader>gL",
        function()
          require("neogit").open({ "log", cwd = LazyVim.root.get() })
        end,
        desc = "Neogit Log (cwd)",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.disabled_filetypes.statusline = vim.list_extend(opts.options.disabled_filetypes.statusline, {
        "NeogitCommitSelectView",
        "NeogitCommitView",
        "NeogitConsole",
        "NeogitGitCommandHistory",
        "NeogitLogView",
        "NeogitPopup",
        "NeogitStatus",
      })
    end,
    optional = true,
  },
}
