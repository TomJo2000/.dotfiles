return {
    'nvim-telescope/telescope.nvim',
    keys = {
      { '<leader>ff' },
      { '<leader>fs' },
      { '<leader>fg' },
      { '<leader>fw' },
      { '<leader>fc' },
    },
    cmd = 'Telescope',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    ---@see Adapted from: https://github.com/ribru17/nvim/blob/088d0924454b3f558b4bc222541cb4e735e7088e/lua/plugins/ui.lua#L183-L273
    config = function()
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local previewers = require('telescope.previewers')
      local builtin = require('telescope.builtin')

      local get_git_delta_opts = function()
        return {
          'git',
          '-c',
          'core.pager=delta',
          '-c',
          'delta.paging=always',
          '-c',
          'delta.side-by-side=false',
          '-c',
          'delta.line-numbers=false',
          '-c',
          'delta.hunk-header-style=omit',
        }
      end

      local delta_status = previewers.new_termopen_previewer {
        get_command = function(entry)
          if entry.status == '??' or entry.status == 'A ' then
            -- show a diff against the null file, since the current file is
            -- either untracked or was just added
            return vim.list_extend(
              get_git_delta_opts(),
              { 'diff', '--no-index', '--', '/dev/null', entry.value }
            )
          end
          -- show the regular diff of the file against HEAD
          return vim.list_extend(get_git_delta_opts(), {
            'diff',
            'HEAD',
            '--',
            entry.value,
          })
        end,
      }

      local delta_b = previewers.new_termopen_previewer {
        get_command = function(entry)
          return vim.list_extend(get_git_delta_opts(), {
            '-c',
            'delta.file-style=omit',
            'diff',
            entry.value .. '^!',
            '--',
            entry.current_file,
          })
        end,
      }

      local delta = previewers.new_termopen_previewer {
        get_command = function(entry)
          return vim.list_extend(get_git_delta_opts(), {
            'diff',
            entry.value .. '^!',
          })
        end,
      }

      local function delta_git_commits(opts)
        opts = opts or {}
        opts.previewer = {
          delta,
          previewers.git_commit_message.new(opts),
          previewers.git_commit_diff_as_was.new(opts),
        }
        builtin.git_commits(opts)
      end

      local function delta_git_bcommits(opts)
        opts = opts or {}
        opts.previewer = {
          delta_b,
          previewers.git_commit_message.new(opts),
          previewers.git_commit_diff_as_was.new(opts),
        }
        builtin.git_bcommits(opts)
      end

      local function delta_git_status(opts)
        opts = opts or {}
        opts.previewer = {
          delta_status,
          previewers.git_commit_message.new(opts),
          previewers.git_commit_diff_as_was.new(opts),
        }
        builtin.git_status(opts)
      end

      builtin.delta_git_commits = delta_git_commits
      builtin.delta_git_bcommits = delta_git_bcommits
      builtin.delta_git_status = delta_git_status

      -- open selected buffers in new tabs
      local function multi_tab(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local multi_selection = picker:get_multi_selection()

        if #multi_selection > 1 then
          require('telescope.pickers').on_close_prompt(prompt_bufnr)
          pcall(vim.api.nvim_set_current_win, picker.original_win_id)

          for _, entry in ipairs(multi_selection) do
            local filename, row, col

            if entry.path or entry.filename then
              filename = entry.path or entry.filename

              row = entry.row or entry.lnum
              col = vim.F.if_nil(entry.col, 1)
            elseif not entry.bufnr then
              local value = entry.value
              if not value then
                return
              end

              if type(value) == 'table' then
                value = entry.display
              end

              local sections = vim.split(value, ':')

              filename = sections[1]
              row = tonumber(sections[2])
              col = tonumber(sections[3])
            end

            local entry_bufnr = entry.bufnr

            if entry_bufnr then
              if not vim.api.nvim_buf_get_option(entry_bufnr, 'buflisted') then
                vim.api.nvim_buf_set_option(entry_bufnr, 'buflisted', true)
              end
              pcall(vim.cmd.sbuffer, {
                filename,
                mods = {
                  tab = 1,
                },
              })
            else
              filename = require('plenary.path')
                :new(vim.fn.fnameescape(filename))
                :normalize(vim.loop.cwd())
              pcall(vim.cmd.tabedit, filename)
            end

            if row and col then
              pcall(vim.api.nvim_win_set_cursor, 0, { row, col - 1 })
            end
          end
        else
          actions.select_tab(prompt_bufnr)
        end
      end

      local putils = require('telescope.previewers.utils')
      local telescope = require('telescope')

      telescope.setup {
        defaults = {
          set_env = {
            LESS = '',
            DELTA_PAGER = 'less',
          },
          preview = {
            filetype_hook = function(filepath, bufnr, opts)
              -- don't display jank pdf previews
              if opts.ft == 'pdf' then
                putils.set_preview_message(
                  bufnr,
                  opts.winid,
                  'Not displaying ' .. opts.ft
                )
                return false
              end
              -- don't syntax highlight minified js
              if
                filepath:find('[-.]min%.js$') or filepath:find('app/out.*js$')
              then
                vim.schedule(function()
                  vim.treesitter.stop(bufnr)
                end)
              end
              return true
            end,
          },
          borderchars = ({
            none = { '', '', '', '', '', '', '', '' },
            single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
            rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
            solid = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
            shadow = { '', '', '', '', '', '', '', '' },
          })[BORDER_STYLE],
          layout_config = {
            horizontal = {
              preview_cutoff = 0,
              preview_width = 0.5,
            },
          },
          prompt_prefix = '  ',
          initial_mode = 'normal',
          mappings = {
            n = {
              ['<Tab>'] = multi_tab, -- <Tab> to open as tab
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<Space>'] = {
                actions.toggle_selection + actions.move_selection_previous,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
              ['q'] = {
                actions.close,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
              ['<C-l>'] = actions.preview_scrolling_right,
              ['<C-h>'] = actions.preview_scrolling_left,
            },
            i = {
              ['<Tab>'] = multi_tab, -- <Tab> to open as tab
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-Space>'] = {
                actions.toggle_selection + actions.move_selection_previous,
                type = 'action',
                opts = { nowait = true, silent = true, noremap = true },
              },
              ['<C-l>'] = false, -- override telescope's default
              ['<M-BS>'] = { '<C-s-w>', type = 'command' },
            },
          },
        },
      }

      vim.keymap.set('n', '<leader>ff', function()
        -- ignore opened buffers if not in dashboard or directory
        if
          vim.fn.isdirectory(vim.fn.expand('%')) == 1
          or vim.bo.filetype == 'alpha'
        then
          builtin.find_files()
        else
          local function literalize(str)
            return str:gsub('[%(%)%.%%%+%-%*%?%[%]%^%$]', function(c)
              return '%' .. c
            end)
          end

          local function get_open_buffers()
            local buffers = {}
            local len = 0
            local vim_fn = vim.fn
            local buflisted = vim_fn.buflisted

            for buffer = 1, vim_fn.bufnr('$') do
              if buflisted(buffer) == 1 then
                len = len + 1
                -- get relative name of buffer without leading slash
                buffers[len] = '^'
                  .. literalize(
                    string
                      .gsub(
                        vim.api.nvim_buf_get_name(buffer),
                        literalize(vim.loop.cwd()),
                        ''
                      )
                      :sub(2)
                  )
                  .. '$'
              end
            end

            return buffers
          end

          builtin.find_files {
            file_ignore_patterns = get_open_buffers(),
          }
        end
      end, {})
      vim.keymap.set('n', '<leader>fg', function()
        builtin.grep_string { search = vim.fn.input('Grep > ') }
      end, {})
      vim.keymap.set('n', '<leader>fs', function()
        builtin.live_grep { initial_mode = 'insert' }
      end, {})
      vim.keymap.set('n', '<leader>fw', builtin.git_files, {})
      vim.keymap.set('n', '<leader>fc', function()
        local load_scheme = require('lazy.core.loader').colorscheme
        for _, value in
          pairs(require('rileybruins.settings').lazy_loaded_colorschemes)
        do
          load_scheme(value)
        end
        vim.keymap.set('n', '<leader>fc', function()
          builtin.colorscheme { enable_preview = true }
        end)
        builtin.colorscheme { enable_preview = true }
      end, {})

      telescope.load_extension('fzf')
    end,
  }
