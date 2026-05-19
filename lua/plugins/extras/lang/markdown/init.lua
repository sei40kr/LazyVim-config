local pandoc_dir = vim.fn.stdpath("config") .. "/lua/plugins/extras/lang/markdown/pandoc"

local function output_path(ctx)
  local name = vim.fn.fnamemodify(ctx.file, ":t:r")
  local hash = vim.fn.sha256(ctx.file):sub(1, 8)
  return vim.fn.stdpath("cache") .. "/preview-" .. name .. "-" .. hash .. ".html"
end

return {
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    optional = true,
  },
  {
    "barrettruth/preview.nvim",
    cmd = "Preview",
    ft = { "markdown" },
    init = function()
      vim.g.preview = {
        github = {
          output = output_path,
          clean = function(ctx)
            return { "rm", "-f", output_path(ctx) }
          end,
          args = function(ctx)
            local template = vim.api.nvim_get_runtime_file("lua/preview/templates/gfm.html", false)[1]
            local args = {
              "-f",
              "gfm+hard_line_breaks",
              ctx.file,
              "-s",
              "--katex",
              "--no-highlight",
              "--lua-filter",
              pandoc_dir .. "/gfm-alerts.lua",
              "--lua-filter",
              pandoc_dir .. "/gfm-mermaid.lua",
              "--include-in-header",
              pandoc_dir .. "/header.html",
              "-o",
              ctx.output,
            }
            if template then
              vim.list_extend(args, { "--template", template })
            end
            return args
          end,
        },
      }
    end,
    keys = {
      { "<leader>cp", "<cmd>Preview toggle<cr>", ft = "markdown", desc = "Preview Toggle" },
    },
  },
}
