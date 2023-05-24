local wezterm = require "wezterm"

local merge_tables = function(x1, x2)
    local out = {}
    for k, v in pairs(x1) do
        out[k] = v
    end
    for k, v in pairs(x2) do
        out[k] = v
    end
    return out
end

local colors = {
    background = '#151515',
    foreground = '#eeffff',
    cursor_bg = '#ffffff',
    cursor_border = '#ffffff',
    cursor_fg = '#ffffff',
    selection_bg = '#eeffff',
    selection_fg = '#545454',
    black1 = '#000000',
    red1 = '#ff5370',
    green1 = '#c3e88d',
    yellow1 = '#ffcb6b',
    blue1 = '#82aaff',
    magenta1 = '#c792ea',
    cyan1 = '#89ddff',
    white1 = '#ffffff',
    black2 = '#545454',
    red2 = '#ff5370',
    green2 = '#c3e88d',
    yellow2 = '#ffcb6b',
    blue2 = '#82aaff',
    magenta2 = '#c792ea',
    cyan2 = '#89ddff',
    white2 = '#ffffff',
}

local window_config = {
    -- The default text color
    foreground = colors.foreground,
    -- The default background color
    background = colors.background,
    -- Overrides the cell background color when the current cell is occupied by the
    -- cursor and the cursor style is set to Block
    cursor_bg = colors.cursor_bg,
    -- Overrides the text color when the current cell is occupied by the cursor
    cursor_fg = colors.cursor_fg,
    -- Specifies the border color of the cursor when the cursor style is set to Block,
    -- or the color of the vertical or horizontal bar when the cursor style is set to
    -- Bar or Underline.
    cursor_border = colors.cursor_border,
    -- the foreground color of selected text
    selection_fg = colors.selection_fg,
    -- the background color of selected text
    selection_bg = colors.selection_bg,
    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = '#222222',
    -- The color of the split lines between panes
    split = '#444444',
    ansi = {
        colors.black1,
        colors.red1,
        colors.green1,
        colors.yellow1,
        colors.blue1,
        colors.magenta1,
        colors.cyan1,
        colors.white1,
    },
    brights = {
        colors.black2,
        colors.red2,
        colors.green2,
        colors.yellow2,
        colors.blue2,
        colors.magenta2,
        colors.cyan2,
        colors.white2,
    },
    -- Arbitrary colors of the palette in the range from 16 to 255
    -- indexed = { [136] = '#af8700' },
    -- Since: 20220319-142410-0fcdea07
    -- When the IME, a dead key or a leader key are being processed and are effectively
    -- holding input pending the result of input composition, change the cursor
    -- to this color to give a visual cue about the compose state.
    compose_cursor = 'orange',
    -- Colors for copy_mode and quick_select
    -- available since: 20220807-113146-c2fee766
    -- In copy_mode, the color of the active text is:
    -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
    -- 2. selection_* otherwise
    copy_mode_active_highlight_bg = { Color = '#000000' },
    -- use `AnsiColor` to specify one of the ansi color palette values
    -- (index 0-15) using one of the names "Black", "Maroon", "Green",
    --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
    -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
    copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
    copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
    copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },
    quick_select_label_bg = { Color = 'peru' },
    quick_select_label_fg = { Color = '#ffffff' },
    quick_select_match_bg = { AnsiColor = 'Navy' },
    quick_select_match_fg = { Color = '#ffffff' },
}

local tab_bar_config = {
    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- (does not apply when fancy tab bar is in use)
        background = colors.background,
        -- The active tab is the one that has focus in the window
        active_tab = {
            -- The color of the background area for the tab
            bg_color = colors.yellow1,
            -- The color of the text for the tab
            fg_color = colors.black1,
            -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
            -- label shown for this tab.
            -- The default is "Normal"
            intensity = 'Normal',
            -- Specify whether you want "None", "Single" or "Double" underline for
            -- label shown for this tab.
            -- The default is "None"
            underline = 'None',
            -- Specify whether you want the text to be italic (true) or not (false)
            -- for this tab.  The default is false.
            italic = false,
            -- Specify whether you want the text to be rendered with strikethrough (true)
            -- or not for this tab.  The default is false.
            strikethrough = false,
        },
       -- Inactive tabs are the tabs that do not have focus
        inactive_tab = {
            bg_color = colors.background,
            fg_color = colors.foreground
            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab`.
        },
        -- You can configure some alternate styling when the mouse pointer
        -- moves over inactive tabs
        inactive_tab_hover = {
            bg_color = colors.black2,
            fg_color = colors.foreground,
            italic = false,
            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `inactive_tab_hover`.
        },
        -- The new tab button that let you create new tabs
        new_tab = {
            bg_color = colors.background,
            fg_color = colors.foreground,
            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `new_tab`.
        },
        -- You can configure some alternate styling when the mouse pointer
        -- moves over the new tab button
        new_tab_hover = {
            bg_color = colors.background,
            fg_color = colors.background,
            italic = false,
            -- The same options that were listed under the `active_tab` section above
            -- can also be used for `new_tab_hover`.
        },
    },
}

local window_frame_config = {
    font = wezterm.font {family = 'IosevkaTerm Nerd Font', weight = 'Bold'},
    font_size = 13.0,
    active_titlebar_bg = colors.background,
    inactive_titlebar_bg = colors.background,
}


return colors, merge_tables(window_config, tab_bar_config), window_frame_config
