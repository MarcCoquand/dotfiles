-- INIT.vim ENTRY
-- Set <space> as the leader key
-- See `:help mapleader`
-- Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Allow clipboard copy paste in neovim
vim.g.neovide_input_use_logo = 1
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',



  'MarcCoquand/Prototype.vim',
  'ThePrimeagen/refactoring.nvim',
  -- Automatically cd to project root dir
  'airblade/vim-rooter',

  'chentoast/marks.nvim',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Adds context to where you're in the project
  'nvim-treesitter/nvim-treesitter-context',

  -- Color theme
  'andreypopp/vim-colors-plain',

  {
    'mrcjkb/haskell-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    branch = '1.x.x', -- recommended
  },
  -- Motion
  "rlane/pounce.nvim",

  -- Trouble diagnostics window
  {
    "folke/trouble.nvim",
    opts = {
      icons = false,
      group = true,
      auto_preview = true,
      auto_close = true,
      padding = false,
      action_keys = {
        jump_close = { "<CR>" },
      },
      fold_open = "",    -- icon used for open folds
      fold_closed = "",  -- icon used for closed folds
      indent_lines = false, -- add an indent guide below the fold icons
      signs = {
        -- icons / text used for a diagnostic
        other = "",
      },
      use_diagnostic_signs = true
    },
  },
  -- Debugger
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
      "mxsdev/nvim-dap-vscode-js",
      'theHamsta/nvim-dap-virtual-text',
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
      }
    },
    keys = {
      { "<leader>db", function() require('dap').toggle_breakpoint() end },
      { "<leader>dc", function() require('dap').continue() end },
      { "<C-'>",      function() require 'dap'.step_over() end },
      { "<C-;>",      function() require 'dap'.step_into() end },
      { "<C-:>",      function() require 'dap'.step_out() end },
    },
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            -- use nvim-dap-vscode-js's pwa-node debug adapter
            type = "pwa-node",
            -- attach to an already running node process with --inspect flag
            -- default port: 9222
            request = "attach",
            -- allows us to pick the process using a picker
            processId = require 'dap.utils'.pick_process,
            -- name of the debug action you have to select for this config
            name = "Attach debugger to existing `node --inspect` process",
            -- for compiled languages like TypeScript or Svelte.js
            sourceMaps = true,
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**" },
            -- path to src in vite based projects (and most other projects as well)
            cwd = "${workspaceFolder}/src",
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
          },
          {
            type = "pwa-chrome",
            name = "Launch Chrome to debug client",
            request = "launch",
            url = "http://localhost:5173",
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}/src",
            -- skip files from vite's hmr
            skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
          },
          {
            name = "Debug Jest Tests",
            type = "pwa-node",
            request = "launch",
            runtimeArgs = {
              "--inspect-brk",
              "node_modules/.bin/jest",
              "--runInBand"
            },
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
            port = 9229
          },
          -- only if language is javascript, offer this debug action
          language == "javascript" and {
            -- use nvim-dap-vscode-js's pwa-node debug adapter
            type = "pwa-node",
            -- launch a new process to attach the debugger to
            request = "launch",
            -- name of the debug action you have to select for this config
            name = "Launch file in new node process",
            -- launch current file
            program = "${file}",
            cwd = "${workspaceFolder}",
          } or nil,
        }
      end
      require("dap")
    end
  },

  'github/copilot.vim',

  {
    -- CODE EXECUTION
    'michaelb/sniprun',
    build = "bash ./install.sh"
  },

  'NvChad/nvim-colorizer.lua',

  {
    'folke/todo-comments.nvim',
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },

  { -- Autocomplete
    'ms-jpq/coq_nvim'
  },
  {
    'stevearc/oil.nvim',
    opts = {},
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {

      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      {
        'j-hui/fidget.nvim',
        opts = {
          -- Make sure diagnostics just follow the color of background
          window = {
            blend = 0
          }
        }
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lsp-signature-help' },
  },
  {
    -- Get fuzzy matching in normal commands
    'tzachar/cmp-fuzzy-path',
    dependencies = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim' }
  },

  'jose-elias-alvarez/null-ls.nvim',

  'jose-elias-alvarez/typescript.nvim',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',                     opts = {} },

  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },


  'https://git.sr.ht/~marcc/BufferBrowser',
  -- ORG
  'nvim-orgmode/orgmode',

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          visual = "X",
          visual_line = "gX",
        }
      })
    end
  },
  'echasnovski/mini.pairs',

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },
}, {})

-- NOTE: MARKS
require("marks").setup({
  mappings = {
    next = ']m',
    prev = '[m'
  }
})

vim.keymap.set("n", "<leader>mo", function()
  vim.cmd ":MarksListAll"
  vim.cmd ":lclose"
  vim.cmd ":Trouble loclist"
end, { noremap = true, silent = true, expr = false, desc = "[M]arks [O]pen" })

-- NOTE: REFACTORING

require('refactoring').setup({})
-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
  { noremap = true, silent = true, expr = false, desc = "[R]efactor [E]xtract function" })
vim.api.nvim_set_keymap("v", "<leader>rf",
  [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
  { noremap = true, silent = true, expr = false, desc = "[R]efactor Extract Function to [F]ile" })
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
  { noremap = true, silent = true, expr = false, desc = "[R]efactor Extract [V]ariable" })
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { noremap = true, silent = true, expr = false, desc = "[R]efactor Extract [I]inline variable" })

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
  { noremap = true, silent = true, expr = false })
vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
  { noremap = true, silent = true, expr = false })

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  { noremap = true, silent = true, expr = false })

-- NOTE: BUFFERBROWSER
require 'buffer_browser'.setup({
  filetype_filters = { 'gitcommit', 'TelescopePrompt', 'oil' }
})
vim.keymap.set('n', ']b', require 'buffer_browser'.next, { desc = "Next [B]uffer" })
vim.keymap.set('n', '[b', require 'buffer_browser'.prev, { desc = "Previous [B]uffer" })

-- NOTE: COLOR SCEHEME THEME
-- vim.cmd("set background=dark")
vim.cmd("colorscheme plain")
if vim.opt.background:get() == 'dark' then
  vim.cmd("highlight VertSplit guifg=#646464")
end

-- NOTE: OIL
require("oil").setup({
  win_options = {
    list = true
  },
  view_options = {
    show_hidden = true,
  }
})
vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd('hi! link OilDir Whitespace')


-- NOTE: STATUS LINE
--
-- SETTING EXPLANATION
-- set_color_1 = "%#PmenuSel#"
-- branch = git_branch()
-- set_color_2 = "%#LineNr#"
-- file_name = " %f"
-- modified = "%m"
-- align_right = "%="
-- fileencoding = " %{&fileencoding?&fileencoding:&encoding}"
-- fileformat = " [%{&fileformat}]"
-- filetype = " %y"
-- percentage = " %p%%"

function ErrorHighlight()
  local errorCount = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  if (errorCount > 0) then
    return '%#WildMenu#[ERR] '
  end
  return '%#StatusLine#'
end

function GetGitSignsHead()
  local gitsigns = vim.b.gitsigns_head
  if (gitsigns ~= nil) then
    return "'" .. gitsigns
  end
  return ''
end

function HasChanged()
  if (vim.bo.modified) then
    return ' -- Edited'
  end
  return ''
end

vim.opt.statusline =
"%{%luaeval('ErrorHighlight()')%}%l:%c %f%{%luaeval('HasChanged()')%}%=  %{luaeval('GetGitSignsHead()')}%*"

-- NOTE: NVIM-DAP

local dap = require('dap')
dap.adapters.language = function(cb, config)
  if config.request == 'attach' then
    cb({ type = "server", port = 9222 })
  else
    if config.request == 'launch' then
      cb({ type = 'executable', command = 'path/to/executable' })
    end
  end
end
require("nvim-dap-virtual-text").setup()

-- NOTE: MOTION
vim.keymap.set("n", "[[", "<C-I>", { silent = true, desc = "[ Jump back" })
vim.keymap.set("n", "<leader>x", "<C-O>", { silent = true, desc = "] Jump back" })

-- NOTE: POUNCE

require('pounce').setup {
  accept_keys = "NTESIRAHDKLVPBJGMUCFYXW:QZ",
}
vim.keymap.set("n", "s", function() require 'pounce'.pounce {} end)
vim.keymap.set("v", "s", function() require 'pounce'.pounce {} end)
vim.keymap.set("x", "s", function() require 'pounce'.pounce {} end)
vim.keymap.set("o", "gs", function() require 'pounce'.pounce {} end)
vim.keymap.set("n", "S", function() require 'pounce'.pounce { input = { reg = "/" } } end)

-- NOTE: SNIPRUN
-- Code execution
vim.keymap.set("n", "gr", ":SnipRun<CR>", { desc = "Run in [R]epl" })
vim.keymap.set("v", "gr", ":SnipRun<CR>", { desc = "Run in [R]epl" })
require('sniprun').setup({
  display = {
    "Terminal",
  },
  -- selected_interpreters = { "JS_TS_deno" },
  -- repl_enable = { "JS_TS_deno" },
  live_display = { "Terminal" }, --# display mode used in live_mode
  -- display_options = {
  --   terminal_scrollback = vim.o.scrollback, -- change terminal display scrollback lines
  -- }
})

-- NOTE: ORG_MODE
require('orgmode').setup_ts_grammar()
require('orgmode').setup({
  org_agenda_files = { "~/Library/Mobile Documents/com~apple~CloudDocs/org/**" },
  org_default_notes_file = '~/Library/Mobile Documents/com~apple~CloudDocs/org/inbox.org',
  org_capture_templates = {
    t = { description = 'Task', template = '* TODO %?\n  %u' },
    j = {
      description = 'Journal',
      template = '* %U: %?',
      target = '~/Library/Mobile Documents/com~apple~CloudDocs/org/journal.org'
    }
  }
})
vim.opt.conceallevel = 2
vim.keymap.set("n", "<leader>oj", ":e ~/Library/Mobile Documents/com~apple~CloudDocs/org/journal.org<CR>",
  { desc = "[O]rg [J]ournal", silent = true })

-- NOTE: FUGITIVE
vim.keymap.set("n", "<leader>gg", ":Git<CR>", { desc = "[G]it To[g]gle" })
vim.keymap.set("n", "<leader>gv", ":Gdiff<CR>", { desc = "[G]it [V]iew Diff" })
vim.keymap.set("n", "<leader>gpy", ":Git push<CR>", { desc = "[G]it [P]ush (Confirm [Y])" })

-- NOTE: RESIZE
vim.keymap.set("n", "<leader>wr2", ":resize20", { desc = "[W]indow [R]esize [2]0" })
vim.keymap.set("n", "<leader>wr1", ":resize10", { desc = "[W]indow [R]esize [1]0" })
vim.keymap.set("n", "<leader>wr3", ":resize30", { desc = "[W]indow [R]esize [3]0" })
vim.keymap.set("n", "<leader>wr4", ":resize40", { desc = "[W]indow [R]esize [4]0" })
vim.keymap.set("n", "<leader>wr5", ":resize50", { desc = "[W]indow [R]esize [5]0" })

-- NOTE: GITSIGNS
require('gitsigns').setup {
  -- See `:help gitsigns.txt`
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  current_line_blame = false,
  current_line_blame_opts = {
    delay = 500,
    ignore_whitespace = true,
    virt_text_pos = 'right_align'
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']g', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "[C]hange Next" })

    map('n', '[g', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "[C]hange Previous" })
    map('n', '<leader>gs', gs.stage_hunk, { desc = "[G]it [S]tage Line" })
    map('n', '<leader>gr', gs.reset_hunk, { desc = "[G]it [R]eset Line" })
    map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end)
    map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end)
    map('n', '<leader>gd', gs.toggle_deleted, { desc = "[G]it [T]oggle [D]iff inline" })
    map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = "[G]it [B]lame Line" })
  end
}

-- NOTE: COLORIZER
require("colorizer").setup({
  filetypes = {
    'css',
    'javascript',
    'typescript',
    'elm',
    'liquid',
    'njk',
    'html',
    'vim',
    html = { mode = 'foreground', }
  },
  user_default_options = {
    css = true,
    css_fn = true,
    tailwind = true,
    mode = "virtualtext",
    virtualtext = "█"
  }
})

-- NOTE: COPILOT + CMD
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.g.copilot_filetypes = {
  ["*"] = false,
  ["javascript"] = true,
  ["typescript"] = true,
  ["lua"] = true,
  ["rust"] = true,
  ["c"] = true,
  ["c#"] = true,
  ["c++"] = true,
  ["go"] = true,
  ["python"] = true,
  ["haskell"] = true,
  ["elixir"] = true,
  ["clojure"] = true,
  ["elm"] = true,
  ["html"] = true,
  ["css"] = true,
  ["sql"] = true,
  ["sh"] = true,
  ["markdown"] = true
}
vim.g.copilot_assume_mapped = true


-- NOTE: AUTOFORMAT
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- NOTE: NULL_LS
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.formatting.fourmolu.with({
      extra_args = { "-o", "-XOverloadedRecordDot", "-o", "-XDuplicateRecordFields", "-o", "-XImplicitParams" }
    }),
    require("typescript.extensions.null-ls.code-actions"),
  },
})

-- NOTE: GENERAL SETTINGS
-- TODO: Set up symbols for errors and warnings, to differentiate between marks and diagnostics
-- TODO: Implement search for current word and add to quickfix list
vim.o.splitbelow = true
vim.cmd('packadd cfilter')
vim.keymap.set("n", "<leader>gt", ":term<CR>A", { desc = "[G]oto New [T]erminal" })
vim.keymap.set("n", "<leader>z", ":b#<CR>", { desc = "[z] Last file" })
vim.keymap.set("n", "<leader>.", ":b ", { desc = "[.] Change Buffer" })
vim.keymap.set('n', '<leader><space>', ":e ", { desc = "[ ] Open file" })
vim.keymap.set('n', '<leader>on', ":e ~/.config/nvim/init.lua<CR>", { desc = "[O]pen [N]eovim config" })
vim.keymap.set('n', '<leader>ss', ":mksession! ~/sessions/", { desc = "[S]ession [S]ave" })
vim.keymap.set('n', '<leader>sl', ":source ~/sessions/", { desc = "[S]ession [L]oad" })
vim.keymap.set('n', '<leader>gc', ":Git checkout ", { desc = "[G]it [C]heckout" })
vim.keymap.set('n', '<leader>go', ":e ~/Library/Mobile Documents/com~apple~CloudDocs/org/<CR>", { desc = "[G]oto [O]rg" })
vim.keymap.set('n', '<leader>bd', ":bd<CR>", { desc = "[B]uffer [D]elete" })
vim.keymap.set("n", "<leader>od", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  { silent = true, noremap = true, desc = "[O]pen [D]iagnostics " }
)
vim.keymap.set('n', '<leader>lc', ":lclose<CR>", { desc = "[L]ocationlist [c]lose", silent = true })
vim.keymap.set('i', '<C-b>', 'b:gitsigns_head', { expr = true })
vim.keymap.set('c', '<C-b>', 'b:gitsigns_head', { expr = true })

-- Set diagnostic symbols
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


-- QUICKLIST
vim.keymap.set('n', '[q', ':cp<CR>', { desc = "[Q]uicklist List Prev", silent = true })
vim.keymap.set('n', ']q', ':cn<CR>', { desc = "[Q]uicklist List Next", silent = true })
vim.keymap.set('n', '<leader>qo', ':Trouble quickfix<CR>', { desc = "[Q]uicklist [O]pen", silent = true })
vim.keymap.set("n", "<leader>/", "mB:vimgrep //j src/**<left><left><left><left><left><left><left><left><left>",
  { desc = "[,] Search in project", silent = true })

vim.keymap.set('n', '<leader>cr', "<cmd>TroubleToggle lsp_references<cr>",
  { desc = "[/] Load file functions into quickfix list", silent = true })

-- Use spaces, 2 by default
vim.cmd('set tabstop=2')
vim.cmd('set shiftwidth=2')

vim.keymap.set('n', '[l', ':lprevious<CR>', { desc = "[L]location list Prev", silent = true })
vim.keymap.set('n', ']l', ':lnext<CR>', { desc = "[L]ocation list Next", silent = true })
-- Auto close location list window upon selecting item
vim.api.nvim_create_autocmd({ 'Filetype' }, {
  callback = function()
    vim.cmd('nmap <buffer> <cr> <cr>:cclose<cr>:lclose<cr>')
  end,
  pattern = 'qf',
})

vim.keymap.set('n', '<leader>>', function()
  -- Enter :e with current directory filled in
  vim.api.nvim_feedkeys(":e " .. vim.fn.expand('%:h') .. '/', 'n', false)
end, { desc = "[>] Open file from buffer location" })

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Auto close netrw buffers
vim.cmd("let g:netrw_fastbrowse = 0")

-- Set highlight on search
vim.o.hlsearch = false

-- NOTE: MARK RECENT FILES
vim.cmd [[augroup AutoMarkers]]
vim.cmd [[autocmd!]]
-- Last Opened Stylesheet
vim.cmd [[autocmd BufLeave,VimLeave *.scss,*.css normal! mS]]
-- Last Opened Programming File (Couldn't find a better name that doesn't conflict with other names)
vim.api.nvim_create_autocmd({ "BufLeave", "VimLeave" },
  {
    pattern = "*.js,*.ts,*.lua,*.hs,*.clj,*.html,*.njk,*.liquid, *.hs, *.lhs",
    callback = function()
      -- Not file match
      local function nfm(str)
        return not string.match(vim.fn.expand("%"), str)
      end

      -- Tests are stored separately
      if nfm("config.js") and nfm("conf.js") and nfm("test.ts") and nfm("test.js") and nfm("spec.js") and nfm("spec.ts") and nfm("*Spec.hs") then
        vim.cmd [[normal! mP]]
      end
    end
  })
-- Last Opened Test File
vim.cmd [[autocmd BufLeave,VimLeave *.test.js,*.test.ts,*.spec.js,*.spec.ts,*Spec.hs normal! mT]]
-- Last Opened Config
vim.cmd [[autocmd BufLeave,VimLeave *.json,*conf.js,*config.js,*.yml,*.yaml,*.cabal normal! mC]]
-- Last Opened Documentation
vim.cmd [[autocmd BufLeave,VimLeave *.md,*.org,*.txt normal! mD]]
vim.cmd [[augroup End]]

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Hide ugly ~ at the end and replace with a dot
vim.o.fillchars = 'eob:.'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true


-- NOTE: BASIC KEYMAPS
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Splits
vim.keymap.set('n', '<leader>w|', ":vsplit<CR>", { desc = "[W]indow [|] Split vertical" })
vim.keymap.set('n', '<leader>wh', ":split<CR>", { desc = "[W]indow Split [h]orizontal" })
vim.keymap.set('n', '<leader>wh', ":split<CR>", { desc = "[W]indow Split [h]orizontal" })
vim.keymap.set('n', '<leader>wx', "<C-w>x", { desc = "[W]indow [X] Swap Current With Next" })
vim.keymap.set('n', '<leader>ww', "<C-w>w", { desc = "[W]indow Next" })

-- Change directory
vim.keymap.set('n', '<leader>cd', ':lcd %:p:h<CR>', { desc = "[C]hange [D]irectory to current", silent = true })

-- Create autogroup for njk to use filetype html using lua syntax
vim.cmd [[augroup njk]]
vim.cmd [[autocmd!]]
vim.cmd [[autocmd BufNewFile,BufRead *.njk set filetype=html]]
vim.cmd [[augroup END]]


-- Tab
vim.keymap.set('n', '<leader><tab>n', ":tabnew<CR>", { desc = "[<Tab>] [n]ew" })
vim.keymap.set('n', '<leader><tab><tab>', ":tabNext<CR>", { desc = "[<Tab>][<Tab>] cycle" })
vim.keymap.set('n', '<leader><tab>x', ":tabclose<CR>", { desc = "[<Tab>] E[x]it" })
vim.keymap.set('n', '<leader><tab>1', "gt1<CR>", { desc = "[<Tab>] Goto tab [1]" })
vim.keymap.set('n', '<leader><tab>2', "gt2<CR>", { desc = "[<Tab>] Goto tab [2]" })
vim.keymap.set('n', '<leader><tab>3', "gt3<CR>", { desc = "[<Tab>] Goto tab [3]" })
vim.keymap.set('n', '<leader><tab>4', "gt4<CR>", { desc = "[<Tab>] Goto tab [4]" })
vim.keymap.set('n', '<leader><tab>5', "gt5<CR>", { desc = "[<Tab>] Goto tab [5]" })
vim.keymap.set('n', '<leader><tab>6', "gt6<CR>", { desc = "[<Tab>] Goto tab [6]" })

-- NOTE: TODO-COMMENTS
require('todo-comments').setup({
  signs = false,
  keywords = {
    TODO = { icon = "⚑", color = "info", alt = { "[TODO]" } },
    WARN = { icon = " ", color = "warning" },
    NOTE = { icon = " ", color = "hint", alt = { "INFO", "[NOTE]", "[INFO]" } },
  },
  search = {
    pattern = [[TODO:]],
  }
})

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next({
    keywords = { "TODO", "NOTE", "[NOTE]", "[INFO]", "INFO", "[TODO]" },
  })
end, { desc = "[T]odo Next" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev({
    keywords = { "TODO", "NOTE" },
  })
end, { desc = "[T]odo Previous" })

vim.keymap.set("n", "<leader>ot", "mB:TodoLocList<CR>", { silent = true, noremap = true, desc = "[O]pen [T]odolist" })


-- NOTE: AUTOPAIRS
require('mini.pairs').setup()

-- NOTE: TREESITTER
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'org' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
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
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  tsserver = {},
  tailwindcss = {},
  elmls = {},
  cssls = {},
  html = {},
  eslint = {},
  jsonls = {},


  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()
-- NOTE: NVIM-CMP
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}
local cmp = require('cmp')
local luasnip = require 'luasnip'
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  formatting = {
    format = function(entry, vim_item)
      vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
      return vim_item
    end
  },

  window = {
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'fuzzy_path',             option = { fd_timeout_msec = 1500 } },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'cmd_line' },
    { name = 'orgmode' },
  },
}

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  view = {
    entries = 'wildmenu'
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  view = {
    entries = 'wildmenu',
    separator = ' ',
    keyword_length = 50
  },
  sources = cmp.config.sources({
    { name = 'fuzzy_path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  }, { {
    name = 'buffer'
  } })
})
