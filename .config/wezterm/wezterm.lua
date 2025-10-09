---@type Wezterm
local wezterm = require('wezterm')

---@type Config
local config = {
  term = 'wezterm',
  font_size = 10,
  font = wezterm.font({
    family = 'HasklugNFM',
    weight = 'Medium',
    --- The '+feature' variant isn't covered by the type definitions yet.
    ---@diagnostic disable: assign-type-mismatch
    harfbuzz_features = {
      '+calt', -- Contextual Alternates
      '+case', -- Case-sensitive Forms
      '+ccmp', -- Glyph (De-)compositions
      '+clig', -- Contextual Ligatures
      '+liga', -- Standard Ligatures
      '+mkmk', -- Mark to Mark Positioning (diacritics)
      '+ss06', -- Slashed dollar sign [$]
    },
    ---@diagnostic enable: assign-type-mismatch
  }),
  --[[ Ligature test
      <* <*> <+> <$> *** <| |> <> <|> !! ||
      == /= === => ==> <<< >>> ++ +++ <- ->
      >> << >>= =<< -< >- -<< >>- .. ... ::
  --]]

  initial_cols = 120,
  initial_rows = 36,

  enable_scroll_bar = true,
  scrollback_lines = 32768,

  -- Still a bit wonky.
  -- https://github.com/wezterm/wezterm/issues/986
  enable_kitty_graphics = true,

  hide_tab_bar_if_only_one_tab = true,

  window_content_alignment = { horizontal = 'Right', vertical = 'Top' },

  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },

  use_resize_increments = true,

  default_cursor_style = 'SteadyUnderline',
  force_reverse_video_cursor = true,
  reverse_video_cursor_min_contrast = 2.5,

  color_scheme = 'Termstream',
}

-- Finally, return the configuration to wezterm:
return config
