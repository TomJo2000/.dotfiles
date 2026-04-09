---@type Wezterm
local wezterm = require('wezterm')

---@since 20220101-133340-7edc5b5a
local hasklig_features = {
  '+calt', -- Contextual Alternates
  '+case', -- Case-sensitive Forms
  '+ccmp', -- Glyph (De-)compositions
  '+clig', -- Contextual Ligatures
  '+liga', -- Standard Ligatures
  '+mkmk', -- Mark to Mark Positioning (diacritics)
}
--[[ Ligature test
  <* <*> <+> <$> *** <| |> <> <|> !! ||
  == /= === => ==> <<< >>> ++ +++ <- ->
  >> << >>= =<< -< >- -<< >>- .. ... ::
--]]

local colorscheme = {
  ansi = {
    '#0A0400',
    '#D61E1C',
    '#1DA65A',
    '#EDBC00',
    '#0A75AD',
    '#FF33B8',
    '#00CEF1',
    '#B0B2B4',
  },
  brights = {
    '#4F4D4B',
    '#E03C31',
    '#64B141',
    '#E26D0E',
    '#2952B2',
    '#9010F0',
    '#39A78E',
    '#F5FBFD',
  },
  cursor_border = 'none',
  selection_bg = 'rgba(50% 50% 50% 50%)',
  selection_fg = 'none',

}

colorscheme.foreground = colorscheme.brights[8]
colorscheme.background = colorscheme.ansi[1]
colorscheme.cursor_fg = colorscheme.ansi[1]
colorscheme.cursor_bg = colorscheme.brights[8]
colorscheme.split = wezterm.color.parse(colorscheme.ansi[1]):desaturate(1):lighten(0.33) --[[@as string]]

--- If a setting or group of settings depends on a specified version
--- that is marked with a @since comment.
---@type Config
local config = {
  front_end = 'WebGpu', ---@since 20221119-145034-49b9839f (Forces Vulkan)
  term = 'wezterm',
  font_size = 10,
  freetype_load_target = 'Normal',
  font = wezterm.font({ family = 'HasklugNFM', harfbuzz_features = hasklig_features }),
  font_rules = {
    { -- Normal
      intensity = 'Normal',
      font = wezterm.font({ family = 'HasklugNFM', harfbuzz_features = hasklig_features }),
    },
    { -- Bold
      intensity = 'Bold',
      font = wezterm.font({ family = 'HasklugNFM-Bold', harfbuzz_features = hasklig_features }),
    },
    { -- Italic
      italic = true,
      font = wezterm.font({ family = 'HasklugNFM-Italic', harfbuzz_features = hasklig_features }),
    },
    { -- Bold and Italic
      intensity = 'Bold',
      italic = true,
      font = wezterm.font({ family = 'HasklugNFM-BoldItalic', harfbuzz_features = hasklig_features }),
    },
  },
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
  bold_brightens_ansi_colors = 'No',
  colors = colorscheme,
  pane_select_bg_color = colorscheme.split,
  -- pane_select_fg_color = ,
  inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.80,
  },
  window_frame = {
    -- This is used as a fallback by the
    -- command palette, pane selector, jump labels and tab bar
    font_size = 12,
    font = wezterm.font({ family = 'HasklugNFM', harfbuzz_features = hasklig_features }),

  },

  ---@since Nightly (> 20240203-110809-5046fc22)
  window_content_alignment = { horizontal = 'Right', vertical = 'Top' },
  ---@since 20211204-082213-a66c61ee9
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },

  ---@type LeaderKey
  leader = {
    mods = 'ALT',
    key = 'w',
    timeout_milliseconds = 1000,
  },
  --- @type KeyBinding[]
  keys = {
    { -- Swap panes automatcally or activate chooser
      mods = 'ALT|LEADER',
      key = 'w',
      action = wezterm.action_callback(
        ---@param win Window
        ---@param pane Pane
        function(win, pane)
          local panes = win:active_tab():panes()
          if #panes == 2 then
            -- There's no keep focus parameter for this,
            -- so swap focus back to the original pane after.
            win:perform_action(wezterm.action.RotatePanes('Clockwise'), pane)
            pane:activate()
          elseif #panes > 2 then
            win:perform_action(
              wezterm.action.PaneSelect({
                alphabet = '1234567890',
                mode = 'SwapWithActiveKeepFocus',
              }),
              pane
            )
          end
        end
      ),
    },
    { -- Enter another pane either automatcally or via chooser
      mods = 'ALT|LEADER',
      key = 'e',
      action = wezterm.action_callback(
        ---@param win Window
        ---@param pane Pane
        function(win, pane)
          local panes = win:active_tab():panes()
          if #panes == 2 then
            -- If we have 2 panes, :activate() the one that doesn't match the passed pane_id.
            (pane:pane_id() == panes[1]:pane_id() and panes[2] or panes[1]):activate()
          elseif #panes > 2 then
            win:perform_action(
              wezterm.action.PaneSelect({
                alphabet = '1234567890',
                mode = 'Activate',
              }),
              pane
            )
          end
        end
      ),
    },
  },
}

-- Finally, return the configuration to wezterm:
return config
