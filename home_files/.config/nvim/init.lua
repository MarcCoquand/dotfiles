-- INIT.vim ENTRY
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
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

-- [[ TERMINAL ]]
vim.o.splitbelow = true
vim.keymap.set("n", "<leader>to", ":split | resize 10 | term<CR>", { desc = "[T]erminal [O]pen" })

-- [[ NEOVIDE ]]
if vim.g.neovide then
  vim.o.guifont = "Pragmasevka Nerd Font:h12:sb"
  vim.opt.linespace = 10
  vim.g.neovide_background_color = "#FFF"
end

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

  -- Fix explorer to be more ergonmic with `-` to trigger it
  'tpope/vim-vinegar',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Color theme
  'andreypopp/vim-colors-plain',

  {
    'ggandor/leap.nvim',
    dependencies = 'tpope/vim-repeat'
  },

  -- Debugger
  {
    'mfussenegger/nvim-dap',
    dependencies = 'mxsdev/nvim-dap-vscode-js'
  },

  -- 'kyazdani42/nvim-web-devicons',
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
    'folke/trouble.nvim',
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
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lsp-document-symbol',
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" }
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

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- UI Select fuzzy find with telescope
  'nvim-telescope/telescope-ui-select.nvim',

  {
    -- Auto resize windows
    'anuvyklack/windows.nvim',
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim"
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()
    end
  },

  'https://git.sr.ht/~marcc/BufferBrowser',

  'chentoast/marks.nvim',

  -- ORG
  'nvim-orgmode/orgmode',
  'joaomsa/telescope-orgmode.nvim',

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


-- [[ COLOR SCEHEME THEME]]
-- vim.cmd("set background=dark")
vim.cmd("colorscheme plain")
if vim.opt.background:get() == 'dark' then
  vim.cmd("highlight VertSplit guifg=#646464")
end

-- [[ BUFFER HISTORY ]]
vim.keymap.set("n", "[b", require('buffer_browser').prev, { desc = "[B]uffers Previous" })
vim.keymap.set("n", "]b", require('buffer_browser').next, { desc = "[B]uffers Next" })
require('buffer_browser').setup({
  filetype_filters = { 'netrw', 'gitcommit', 'TelescopePrompt' }
})
-- Close netrw buffer immediately
vim.cmd("let g:netrw_fastbrowse = 0")

-- [[ STATUS LINE]]
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
vim.opt.statusline = "%#PmenuSel#%m %l:%c %f %= %{FugitiveStatusline()}"

-- [[ NVIM-DAP ]]
require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- Path to vscode-js-debug installation.
  debugger_path = vim.fn.stdpath('data') .. "/lazy/nvim-dap-vscode-js",
  -- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

local js_based_languages = { "typescript", "javascript", "typescriptreact" }

vim.keymap.set('n', '<F5>', require 'dap'.continue)
vim.keymap.set('n', '<F10>', require 'dap'.step_over)
vim.keymap.set('n', '<F11>', require 'dap'.step_into)
vim.keymap.set('n', '<F12>', require 'dap'.step_out)

for _, language in ipairs(js_based_languages) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require 'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Start Chrome with \"localhost\"",
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
      userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
    }
  }
end


-- [[ TROUBLE ]]
require("trouble").setup {
  auto_close = true,
  auto_preview = false,
  icons = false,
  fold_open = "v",      -- icon used for open folds
  fold_closed = ">",    -- icon used for closed folds
  indent_lines = false, -- add an indent guide below the fold icons
  use_diagnostic_signs = true,
  signs = {
    -- icons / text used for a diagnostic
    error = "E",
    warning = "W",
    hint = "H",
    information = "I"
  },
}
vim.keymap.set("n", "<leader>od", "<cmd>TroubleToggle<cr>",
  { silent = true, noremap = true, desc = "[O]pen [D]iagnostics " }
)

-- [[ MOTION ]]
vim.keymap.set("n", "[[", "<C-I>", { silent = true, desc = "[ Jump back" })
vim.keymap.set("n", "<leader>x", "<C-O>", { silent = true, desc = "] Jump back" })



-- [[ MARKS ]]
require('marks').setup {
  force_write_shada = false,
  mappings = {
    set_next = "m,",
    toggle = "mm",
    next = "]m",
    prev = "[m",
    delete_line = "dm-",
    preview = "m:",
    annotate = "mi"
  },
}
vim.cmd('hi MarkSignHl guifg=#b6d6fd ctermfg=159')

-- [[ LEAP ]]
require('leap').add_default_mappings()
require('leap').opts.equivalence_classes = {
  '\r\n',
  ')]}>',
  '([{<',
  { '"', "'", '`' },
}
require('leap').opts.substitute_chars = {
  ['\r'] = '¬'
}
require('leap').opts.labels = {
  "r", "t", "k", "n", "i", "f", "m", "b", "l", "j", "v", "p", "d", "c", "x", "/", "z", "R", "T", "K", "N", "I", "F", "M",
  "B", "L", "J", "V", "P", "D", "C", "X", "?", "Z"
}
require('leap').opts.sepcial_keys = {
  next_group = '<tab>',
  prev_group = '<s-tab>'
}
vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })
if vim.opt.background:get() == 'dark' then
  vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
    fg = '#000000', bg = '#ffffff', bold = true, nocombine = true,
  })
else
  vim.api.nvim_set_hl(0, 'LeapLabelPrimary', {
    fg = '#ffffff', bg = '#000000', bold = true, nocombine = true,
  })
end

-- [[ SNIPRUN ]]
-- Code execution
vim.keymap.set("n", "gr", ":SnipRun<CR>", { desc = "Run in [R]epl" })
vim.keymap.set("v", "gr", ":SnipRun<CR>", { desc = "Run in [R]epl" })
require('sniprun').setup({
  display = {
    "TerminalWithCode",
  },
  selected_interpreters = { "JS_TS_deno" },
  repl_enable = { "JS_TS_deno" },
  display_options = {
    terminal_scrollback = vim.o.scrollback, -- change terminal display scrollback lines
  }
})

-- [[ ORG_MODE ]]
require('orgmode').setup_ts_grammar()
require('orgmode').setup({
  org_agenda_files = { "~/Library/Mobile Documents/com~apple~CloudDocs/org/**" },
  org_default_notes_file = '~/Library/Mobile Documents/com~apple~CloudDocs/org/inbox.org',
})
require('telescope').load_extension('orgmode')
vim.keymap.set("n", "<leader>of", function()
    require('telescope').extensions.orgmode.search_headings(require('telescope.themes').get_ivy({}))
  end,
  { desc = "[O]rg [F]ind in Agenda" })
vim.opt.conceallevel = 2

-- [[ FUGITIVE ]]
vim.keymap.set("n", "<leader>gg", ":Git<CR>", { desc = "[G]it To[g]gle" })
vim.keymap.set("n", "<leader>gv", ":Gdiff<CR>", { desc = "[G]it [V]iew Diff" })
vim.keymap.set("n", "<leader>gpy", ":Git push<CR>", { desc = "[G]it [P]ush (Confirm [Y])" })

-- [[ RESIZE ]]
vim.keymap.set("n", "<leader>wr2", ":resize20", { desc = "[W]indow [R]esize [2]0" })
vim.keymap.set("n", "<leader>wr1", ":resize10", { desc = "[W]indow [R]esize [1]0" })
vim.keymap.set("n", "<leader>wr3", ":resize30", { desc = "[W]indow [R]esize [3]0" })
vim.keymap.set("n", "<leader>wr4", ":resize40", { desc = "[W]indow [R]esize [4]0" })
vim.keymap.set("n", "<leader>wr5", ":resize50", { desc = "[W]indow [R]esize [5]0" })
-- [[ GITSIGNS ]]
require('gitsigns').setup {
  -- See `:help gitsigns.txt`
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 500,
    ignore_whitespace = true,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '<leader>g]', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "[C]hange Next" })

    map('n', '<leader>g[', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "[C]hange Previous" })
    map('n', '<leader>gs', gs.stage_hunk, { desc = "[G]it [S]tage Line" })
    map('n', '<leader>gr', gs.reset_hunk, { desc = "[G]it [R]eset Line" })
    map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end)
    map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end)
    map('n', '<leader>gtd', gs.toggle_deleted, { desc = "[G]it [T]oggle [D]iff inline" })
    -- map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = "[G]it [B]lame Line" })
  end
}

-- [[ COLORIZER ]]
require("colorizer").setup({
  filetypes = {
    'css',
    'javascript',
    'typescript',
    'elm',
    'liquid',
    'njk',
    'html',
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

-- [[ COPILOT + CMD ]]
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
  ["markdown"] = true
}
vim.g.copilot_assume_mapped = true


-- [[ AUTOFORMAT ]]
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- [[ NULL_LS ]]
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    require("typescript.extensions.null-ls.code-actions"),
  },
})

-- [[ GENERAL SETTINGS ]]
-- Set highlight on search
vim.o.hlsearch = false

-- Set wildmenu
-- vim.o.wildmenu = true
-- vim.o.wildignore = '*/node_modules/**,*.o,*/coverage/**'

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

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


-- [[ BASIC KEYMAPS ]]
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

-- Change directory
vim.keymap.set('n', '<leader>cd', ':lcd %:p:h<CR>', { desc = "[C]hange [D]irectory", silent = true })

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

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[TODO-COMMENTS]]
require('todo-comments').setup({
  signs = false,
  keywords = {
    TODO = { icon = " ", color = "info" },
    WARN = { icon = " ", color = "warning" },
  },
  search = {
    pattern = [[TODO:]],
  }
})

vim.keymap.set("n", "t]", function()
  require("todo-comments").jump_next({
    keywords = { "TODO" },
  })
end, { desc = "[T]odo Next" })

vim.keymap.set("n", "t[", function()
  require("todo-comments").jump_prev({
    keywords = { "TODO" },
  })
end, { desc = "[T]odo Previous" })
require('telescope').load_extension('todo-comments')

vim.keymap.set("n", "<leader>t", ":Telescope todo-comments theme=get_ivy<CR>", { desc = "[T]odo [f]ind" })


-- [[ AUTOPAIRS ]]
require('mini.pairs').setup()

-- [[ TELESCOPE ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    live_grep = {
      layout_strategy = 'bottom_pane',
      -- Since get_ivy didn't work. I just copy pasted the implementation
      border = true,
      borderchars = {
        "z",
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    },
    lsp_references = {
      layout_strategy = 'bottom_pane',
      -- Since get_ivy didn't work. I just copy pasted the implementation
      border = true,
      borderchars = {
        "z",
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
      show_line = false
    },
    find_files = {
      layout_strategy = 'bottom_pane',
      -- Since get_ivy didn't work. I just copy pasted the implementation
      border = true,
      borderchars = {
        "z",
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
    },
    lsp_document_symbols = {
      layout_strategy = 'bottom_pane',
      -- Since get_ivy didn't work. I just copy pasted the implementation
      border = true,
      borderchars = {
        "z",
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      }
    },
    marks = {
      layout_strategy = 'bottom_pane',
      -- Since get_ivy didn't work. I just copy pasted the implementation
      border = true,
      borderchars = {
        "z",
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " " },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      }
    }
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_cursor {
      }
    }
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>>', function()
  require('telescope.builtin').buffers(require('telescope.themes').get_ivy({}))
end, { desc = '[>] Find existing buffers' })
vim.keymap.set('n', '<leader><space>',
  function()
    require('telescope.builtin').find_files(require('telescope.themes').get_ivy({}))
  end,
  { desc = '[ ] Search Files' })
local utils = require("telescope.utils")
vim.keymap.set('n', '<leader>.', function()
    require('telescope.builtin').find_files({ cwd = utils.buffer_dir() })
  end,
  { desc = '[.] Search Files from Buffer' })

vim.keymap.set('n', '<leader>mf', require('telescope.builtin').marks, { desc = '[M]arks [F]ind' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').lsp_document_symbols, { desc = '[/] Search Workspace' })
vim.keymap.set('n', '<leader>,', function()
  require('telescope.builtin').live_grep({ cwd = utils.buffer_dir() })
end, { desc = '[,] Search Current Directory' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>gb', function()
  require('telescope.builtin').git_branches({ cwd = utils.buffer_dir() })
end, { desc = '[G]it [B]ranch checkout' })
require("telescope").load_extension("ui-select")


-- [[ TREESITTER ]]
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

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>cs', vim.lsp.buf.rename, '[C]ode Rename [S]ymbol')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('<leader>cr', require('telescope.builtin').lsp_references, '[C]ode [R]eferences')
  nmap('<leader>cI', vim.lsp.buf.implementation, '[C]ode [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

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

-- [[ CMP ]]
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
require("luasnip.loaders.from_vscode").lazy_load()
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
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
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
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'fuzzy_path', option = { fd_timeout_msec = 1500 } },
    { name = 'buffer' },
    { name = 'path' },
  },
}

cmp.setup.cmdline('/', {
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
