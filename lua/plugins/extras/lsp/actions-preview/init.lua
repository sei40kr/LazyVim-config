return {
  "aznhe21/actions-preview.nvim",
  dependencies = { "telescope.nvim", optional = true },
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = {
      "<leader>ca",
      function()
        require("actions-preview").code_actions()
      end,
      desc = "Code Action",
      mode = { "n", "v" },
      has = "codeAction",
    }
  end,
  lazy = true,
}
