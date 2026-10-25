return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main', -- Neovim 0.12+; master uses the old Treesitter API.
    lazy = false,
    config = function()
      local treesitter = require 'nvim-treesitter'
      -- Prefer the rebuilt parsers over any left in the old plugin directory.
      treesitter.setup { install_dir = vim.fn.stdpath 'data' .. '/site' }
      vim.treesitter.language.register('bash', 'sh')
      vim.treesitter.language.register('json', 'jsonc')
      vim.treesitter.language.register('git_config', 'gitconfig')
      vim.treesitter.language.register('ssh_config', 'sshconfig')
      treesitter.install {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'cpp',
        'python',
      }

      -- The main branch installs parsers; highlighting and indentation are opt-in.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('alevitskii-treesitter', { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if not lang then
            return
          end

          local function attach()
            if not vim.api.nvim_buf_is_valid(event.buf) or vim.bo[event.buf].filetype ~= event.match then
              return
            end
            if not vim.treesitter.language.add(lang) then
              return
            end
            vim.treesitter.start(event.buf, lang)
            if event.match == 'ruby' then
              -- Ruby's indent rules still need regex syntax highlighting.
              vim.bo[event.buf].syntax = 'ruby'
            else
              vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end

          if vim.treesitter.language.add(lang) then
            attach()
          elseif require('nvim-treesitter.parsers')[lang] then
            -- Install missing parsers without blocking editing, then attach.
            treesitter.install({ lang }):await(vim.schedule_wrap(function(err)
              if err then
                vim.notify(tostring(err), vim.log.levels.ERROR)
                return
              end
              attach()
            end))
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        multiwindow = false, -- Enable multiwindow support.
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
