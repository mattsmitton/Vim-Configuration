local lspconfig = require("lspconfig")
lspconfig.gopls.setup({})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format({ async = false }) -- For synchronous formatting
    end,
})

-- Initialize Copilot, CopilotChat, and nvim-cmp integration
require("copilot").setup({})
-- require("CopilotChat").setup { debug = false }
-- require("copilot_cmp").setup()
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

require("mcphub").setup({
  extensions = {
    avante = {
        make_slash_commands = true, -- make /slash commands from MCP server prompts
    }
  }
})

-- Function to wait for MCPHub initialization and then setup Avante
local function setup_avante_with_mcphub()
  local max_attempts = 50  -- Maximum number of attempts
  local attempt_delay = 100  -- Delay between attempts in milliseconds
  local current_attempt = 0

  local function try_setup()
    current_attempt = current_attempt + 1
    local hub = require("mcphub").get_hub_instance()

    if hub then
      -- MCPHub is ready, setup Avante with full integration
      print("MCPHub initialized, setting up Avante with MCP tools...")

      require('avante').setup({
        -- These conflict with MCPHub
        disabled_tools = {
          "list_files",    -- Built-in file operations
          "search_files",
          "read_file",
          "create_file",
          "rename_file",
          "delete_file",
          "create_dir",
          "rename_dir",
          "delete_dir",
          "bash",         -- Built-in terminal access
        },
        input = {
          provider = "snacks",
          provider_opts = {
            -- Snacks input configuration
            title = "Avante Input",
            icon = " ",
            placeholder = "Enter your API key...",
          },
        },
        provider = "copilot",
        system_prompt = function()
          local hub_instance = require("mcphub").get_hub_instance()
          return hub_instance and hub_instance:get_active_servers_prompt() or ""
        end,
        custom_tools = function()
          local hub_instance = require("mcphub").get_hub_instance()
          if not hub_instance then
            return {}
          end

          local ext_ok, ext = pcall(require, "mcphub.extensions.avante")
          if not ext_ok then
            return {}
          end

          local mcp_tool = ext.mcp_tool()
          if not mcp_tool then
            return {}
          end

          return { mcp_tool }
        end,
      })

    elseif current_attempt < max_attempts then
      -- MCPHub not ready yet, try again after delay
      vim.defer_fn(try_setup, attempt_delay)
    else
      -- Max attempts reached, setup Avante without MCP integration
      print("MCPHub initialization timeout, setting up Avante without MCP tools...")

      require('avante').setup({
        input = {
          provider = "snacks",
          provider_opts = {
            -- Snacks input configuration
            title = "Avante Input",
            icon = " ",
            placeholder = "Enter your API key...",
          },
        },
        provider = "copilot",
        system_prompt = "",
        custom_tools = function()
          return {}
        end,
      })
    end
  end

  -- Start the initialization check
  vim.defer_fn(try_setup, attempt_delay)
end

-- Setup Avante with MCPHub integration after a short delay
setup_avante_with_mcphub()
