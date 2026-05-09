local filetypes = { "julia", "python", "r" }

local function with_kernel(action)
  return function()
    local jupyter = require("jupyter")
    if vim.b.jupyter_kernel_attached then
      action(jupyter)
      return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_create_autocmd("User", {
      pattern = "JupyterKernelReady",
      once = true,
      callback = function(ev)
        if ev.data.bufnr == bufnr then
          action(jupyter)
        end
      end,
    })
    jupyter.start_kernel()
  end
end

return {
  {
    "sei40kr/jupyter.nvim",
    dependencies = { "folke/snacks.nvim" },
    build = ":UpdateRemotePlugins",
    ft = filetypes,
    event = "BufReadCmd *.ipynb",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function(args)
          require("which-key").add({
            buffer = args.buf,
            { "<localleader>j", group = "jupyter" },
            { "<localleader>je", group = "execute" },
          })
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "JupyterKernelReady",
        callback = function(ev)
          vim.b[ev.data.bufnr].jupyter_kernel_attached = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "JupyterDeinitPost",
        callback = function(ev)
          vim.b[ev.data.bufnr].jupyter_kernel_attached = false
        end,
      })
    end,
    opts = {
      display = {
        image = {
          renderer = "snacks",
        },
      },
    },
    keys = {
      {
        "]j",
        function()
          require("jupyter").next_cell()
        end,
        desc = "Next Cell",
        ft = filetypes,
      },
      {
        "[j",
        function()
          require("jupyter").prev_cell()
        end,
        desc = "Prev Cell",
        ft = filetypes,
      },
      {
        "<M-CR>",
        with_kernel(function(jupyter)
          jupyter.execute_and_advance()
        end),
        desc = "Execute Cell and Advance",
        mode = { "n", "i" },
        ft = filetypes,
      },
      {
        "<localleader>jee",
        with_kernel(function(jupyter)
          jupyter.execute_cell()
        end),
        desc = "Execute Cell",
        ft = filetypes,
      },
      {
        "<localleader>jea",
        with_kernel(function(jupyter)
          jupyter.execute_all()
        end),
        desc = "Execute All Cells",
        ft = filetypes,
      },
      {
        "<localleader>jc",
        function()
          require("jupyter").clear_all_outputs()
        end,
        desc = "Clear All Outputs",
        ft = filetypes,
      },
      {
        "<localleader>jo",
        function()
          require("jupyter").insert_cell_below()
        end,
        desc = "Insert Cell Below",
        ft = filetypes,
      },
      {
        "<localleader>jO",
        function()
          require("jupyter").insert_cell_above()
        end,
        desc = "Insert Cell Above",
        ft = filetypes,
      },
      {
        "<localleader>jd",
        function()
          require("jupyter").delete_cell()
        end,
        desc = "Delete Cell",
        ft = filetypes,
      },
      {
        "<localleader>jm",
        function()
          require("jupyter").merge_with_prev()
        end,
        desc = "Merge with Previous Cell",
        ft = filetypes,
      },
      {
        "<localleader>js",
        function()
          require("jupyter").split_at_cursor()
        end,
        desc = "Split Cell at Cursor",
        ft = filetypes,
      },
      {
        "<localleader>jr",
        function()
          require("jupyter").restart_kernel()
        end,
        desc = "Restart Kernel",
        ft = filetypes,
      },
    },
  },
}
