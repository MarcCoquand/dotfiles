local ht = require('haskell-tools')
local def_opts = { noremap = true, silent = true, }
ht.start_or_attach {
  hls = {
    on_attach = function(client, bufnr)
      local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr, })
      -- haskell-language-server relies heavily on codeLenses,
      -- so auto-refresh (see advanced configuration) is enabled by default
      vim.keymap.set('n', '<space>ca', vim.lsp.codelens.run, opts)
      vim.keymap.set('n', '<space>cgd', ht.hoogle.hoogle_signature, opts)
      vim.keymap.set('n', '<space>cea', ht.lsp.buf_eval_all, opts)
      vim.cmd('hi! link LspCodeLens DiagnosticOk')


      -- Toggle a GHCi repl for the current package
      vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
      -- Toggle a GHCi repl for the current buffer
      vim.keymap.set('n', '<leader>rf', function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, def_opts)
      vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>cs', vim.lsp.buf.rename, '[C]ode Rename [S]ymbol')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      -- TODO: Replace lsp references lookup
      nmap('<leader>ci', vim.lsp.buf.implementation, '[C]ode [I]mplementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      -- TODO: Replace document symbol lookup
      -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
      opts = { noremap = true, silent = true, buffer = bufnr } -- bufnr is an argument of the on_attach function
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    end,
    default_settings = {
      haskell = { -- haskell-language-server options
        formattingProvider = 'fourmolu',
      }
    }
  },

}
-- Detect nvim-dap launch configurations
-- (requires nvim-dap and haskell-debug-adapter)
ht.dap.discover_configurations(bufnr)
