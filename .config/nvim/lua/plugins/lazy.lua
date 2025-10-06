-- Config for Lazy.nvim itself.
return {
  -- stylua: ignore
  ui = {
    -- a number <1 is a percentage., >1 is a fixed size
    size = { width = 7/9, height = 0.9 },
    wrap = true, -- wrap the lines in the ui
    -- Valid border options
    border = 'none',    ---@type 'none'|'single'|'double'|'rounded'
    title = nil,        ---@type string? only works when border is not "none"
    title_pos = 'left', ---@type "center" | "left" | "right"
    pills = true,       ---@type boolean
    icons = {
      cmd = '', config = '', event = '', ft = '',
      init = '', import = '', keys = '', lazy = '󰒲',
      loaded = '●', not_loaded = '○', plugin = '', runtime = '',
      require = '󰢱', source = '', start = '', task = '✔',
      list = {
        '●',
        '➜',
        '★',
        '',
      },
    },
  },
  diff = { cmd = 'terminal_git' },
  -- Enable profiling of lazy.nvim. This will add some overhead,
  -- so only enable this when you are debugging lazy.nvim
  profiling = {
    -- Enables extra stats on the debug tab related to the loader cache.
    -- Additionally gathers stats about all package.loaders
    -- loader = true,
    loader = false,
    -- Track each new require in the Lazy profiling tab
    -- require = true,
    require = false,
  },
  headless = { colors = true }
}
