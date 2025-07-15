-- Initialize Copilot, CopilotChat, and nvim-cmp integration
require("copilot").setup({})
require("CopilotChat").setup { debug = false }
require("copilot_cmp").setup()
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  },
  sources = {
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})
