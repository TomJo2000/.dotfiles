---@type Wezterm
local wezterm = require('wezterm')

--- If a setting or group of settings depends on a specified version
--- that is marked with a @since comment.
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
    },
    ---@diagnostic enable: assign-type-mismatch
  }), ---@since 20220101-133340-7edc5b5a
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

  use_resize_increments = true, ---@since 20240127-113634-bbcac864

  default_cursor_style = 'SteadyUnderline',
  force_reverse_video_cursor = true, ---@since 20220319-142410-0fcdea07
  reverse_video_cursor_min_contrast = 4.5, ---@since Nightly (> 20240203-110809-5046fc22)

  color_scheme = 'Termstream',

  window_frame = {
    -- This is used as a fallback by the
    -- command palette, pane selector, jump labels and tab bar
    font_size = 12,
    font = wezterm.font({
      family = 'HasklugNFM',
      weight = 'Bold',
      --- The '+feature' variant isn't covered by the type definitions yet.
      ---@diagnostic disable: assign-type-mismatch
      harfbuzz_features = {
        '+calt', -- Contextual Alternates
        '+case', -- Case-sensitive Forms
        '+ccmp', -- Glyph (De-)compositions
        '+clig', -- Contextual Ligatures
        '+liga', -- Standard Ligatures
        '+mkmk', -- Mark to Mark Positioning (diacritics)
      },
      ---@diagnostic enable: assign-type-mismatch
    }), ---@since 20220903-194523-3bb1ed61
  },

  ---@since Nightly (> 20240203-110809-5046fc22)
  window_content_alignment = { horizontal = 'Right', vertical = 'Top' },
  ---@since 20211204-082213-a66c61ee9
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },

}

-- Finally, return the configuration to wezterm:
return config
