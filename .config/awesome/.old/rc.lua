-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local charitable = require("libs/charitable")
local bling = require("libs/bling")
local mybar = require("bar")

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

local function print_d(te)
	naughty.notify({ preset = naughty.config.presets.critical,
	title = te,
	text = tostring(err) })
end



-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/mytheme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

local focus_titlebar_settings = {
		size = 4,
		position = 'top',
		bg_normal= "transparent",
		bg_focus =  beautiful.yellow1,
	}
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

mykeyboardlayout = awful.widget.keyboardlayout()

mytray = wibox.widget.systray()
mytray:set_base_size(18)
-- mytray.forced_width = 40

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
			awful.button({ }, 1, function(t) charitable.select_tag(t, awful.screen.focused()) end),
			awful.button({ }, 3, function(t) charitable.toggle_tag(t, awful.screen.focused()) end),
			awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
			awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local mem = mybar.mem()
local cpu = mybar.cpu()
local vol = mybar.volbar()

local tags = charitable.create_tags(
   { "I", "II", "III", "IV", "V", "VI"},
   {
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
   }
)
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
	 for i = 1, #tags do
	         if not tags[i].selected then
	             tags[i].screen = s
	             tags[i]:view_only()
	             break
	         end
	    end

    s.scratch = awful.tag.add('scratch-' .. s.index, {})

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
       screen = s,
       filter  = awful.widget.taglist.filter.noempty,
       buttons = taglist_buttons,
       source = function(screen, args) return tags end,
    })

    s.mywibar = awful.wibar({
		position = "top",
		screen = s,
		height=15,
		bg='#000000',
		fg=beautiful.fg_widget
	})

    s.mywibar:setup {
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
		},
		{
			layout = wibox.layout.fixed.horizontal,
		},
		{
			layout = wibox.layout.fixed.horizontal,
			mytray,
			vol.widget,
			cpu.widget,
			mem.widget,
			mykeyboardlayout,
			mytextclock,
			s.mylayoutbox,
		},
	}

end)
awful.screen.focus(tags[1].screen)
-- }}}

local disc_scratch = bling.module.scratchpad {
    command = "discord",           -- How to spawn the scratchpad
    rule = { name = "Discord" },                     -- The rule that the scratchpad will be searched by
    sticky = true,                                    -- Whether the scratchpad should be sticky
    autoclose = true,                                 -- Whether it should hide itself when losing focus
    floating = true,                                  -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
    geometry = { width = 1820, height = 1000, y = 55, x = 55 }, -- The geometry in a floating state
    reapply = true,                                   -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
    dont_focus_before_close  = false,                 -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
    --rubato = {x = anim_x, y = anim_y}                 -- Optional. This is how you can pass in the rubato tables for animations. If you don't want animations, you can ignore this option.
}
local clickup_scratch = bling.module.scratchpad {
    command = "clickup",           -- How to spawn the scratchpad
    rule = { class = "ClickUp" },                     -- The rule that the scratchpad will be searched by
    sticky = true,                                    -- Whether the scratchpad should be sticky
    autoclose = true,                                 -- Whether it should hide itself when losing focus
    floating = true,                                  -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
    geometry = { width = 1820, height = 1000, y = 55, x = 55 }, -- The geometry in a floating state
    reapply = true,                                   -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
    dont_focus_before_close  = false,                 -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
    --rubato = {x = anim_x, y = anim_y}                 -- Optional. This is how you can pass in the rubato tables for animations. If you don't want animations, you can ignore this option.
}
local confluence_scratch = bling.module.scratchpad {
    command = "/usr/lib/brave-bin/brave --profile-directory=Default --app-id=lfbalflefjopodjicnjnnhhfhaonlncp",
    rule = { class = "crx_lfbalflefjopodjicnjnnhhfhaonlncp" },-- The rule that the scratchpad will be searched by
    sticky = true,                                    -- Whether the scratchpad should be sticky
    autoclose = true,                                 -- Whether it should hide itself when losing focus
    floating = true,                                  -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
    geometry = { width = 1820, height = 1000, y = 55, x = 55 }, -- The geometry in a floating state
    reapply = true,                                   -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
    dont_focus_before_close  = false,                 -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
    --rubato = {x = anim_x, y = anim_y}                 -- Optional. This is how you can pass in the rubato tables for animations. If you don't want animations, you can ignore this option.
}
-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
--    awful.key({ modkey, "Control"  }, "d", function()
--		scratch.toggle("discord", {instance = 'disc'})
--	end),
--
--    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
--              {description = "view previous", group = "tag"}),
--    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
--              {description = "view next", group = "tag"}),
--    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
--              {description = "go back", group = "tag"}),
--    awful.key({ modkey,  "Control" ,"Shift"     }, "w", function () mymainmenu:show() end,
--              {description = "show main menu", group = "awesome"}),
--    awful.key({ modkey,           }, "Tab",
--        function ()
--            awful.client.focus.history.previous()
--            if client.focus then
--                client.focus:raise()
--            end
--        end,
--        {description = "go back", group = "client"}),
--    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
--              {description = "jump to urgent client", group = "client"}),
--    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
--              {description = "increase the number of master clients", group = "layout"}),
--    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
--              {description = "decrease the number of master clients", group = "layout"}),
--
--    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
--              {description = "increase the number of columns", group = "layout"}),
--    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
--              {description = "decrease the number of columns", group = "layout"}),
--	-- Menubar
--    awful.key({ modkey }, "p", function() menubar.show() end,
--              {description = "show the menubar", group = "launcher"})
--    awful.key({ modkey }, "x",
--              function ()
--                  awful.prompt.run {
--                    prompt       = "Run Lua code: ",
--                    textbox      = awful.screen.focused().mypromptbox.widget,
--                    exe_callback = awful.util.eval,
--                    history_path = awful.util.get_cache_dir() .. "/history_eval"
--                  }
--              end,
--              {description = "lua execute prompt", group = "awesome"})
    awful.key({ modkey,           }, "j", function () awful.client.focus.byidx( 1) end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,  }, "period", function () awful.screen.focus(1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey,  }, "comma", function () awful.screen.focus(2) end,
              {description = "focs the previous screen", group = "screen"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "w", function () awful.spawn("brave") end,
              {description = "open a browser", group = "launcher"}),
    awful.key({ modkey, "Control"  }, "d", function() disc_scratch:toggle() end,
			  {description = "open discord scratchpad", group = "launcher"}),

    awful.key({ modkey, "Control"  }, "t", function() clickup_scratch:toggle() end,
			  {description = "Open ClickUp scratchpad", group = "launcher"}),

    awful.key({ modkey, "Control"  }, "c", function() confluence_scratch:toggle() end,
			  {description = "Open Confluence Scratchpad", group = "launcher"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ "Control", }, "Right", function () awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +3%") end,
              {description = "Raise Volume", group = "volume"}),
    awful.key({ "Control",  }, "Left", function () awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -3%") end,
              {description = "Lower Volume", group = "volume"}),
    awful.key({ "Control",           }, "Delete", function () awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
              {description = "Mute Volume", group = "volume"}),
    awful.key({ modkey, "Shift" }, "s", function () awful.spawn.with_shell( "maim -s | xclip -selection clipboard -t image/png") end,
              {description = "Screenshot copy to clipboard", group = "Screenshots"}),

    awful.key({}, "F1",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "p",     function () awful.spawn("rofi -show combi") end,
              {description = "run rofi", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, }, "BackSpace",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey,  }, "t",  function (c)
		c.floating = not c.floating
		c:emit_signal("toggle")
	end,
	{description = "toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "s",  function (c)
		c.sticky = not c.sticky
		c:emit_signal("toggle")
	end,
    {description = "togge sticky", group = "client"}),

    awful.key({ modkey,  "Shift" }, "t",function (c)
		c.ontop = not c.ontop
		c:emit_signal("toggle")
		end,
        {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey, "Shift"   }, "comma",      function (c) c:move_to_screen(-1)               end,
              {description = "move client to prev screen ", group = "screen"}),
    awful.key({ modkey, "Shift"   }, "period",      function (c) c:move_to_screen(1)               end,
              {description = "move clienbt to next screen ", group = "screen"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local hist = {tags[2]}
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
					  if tags[i] ~= awful.screen.focused().selected_tag then
						  local  cur_screen = awful.screen.focused()
						  hist[i] = cur_screen.selected_tag
						  charitable.select_tag(tags[i], awful.screen.focused())
						  awful.screen.focus(cur_screen)
					  else
						  local  cur_screen = awful.screen.focused()
						  if cur_screen.selected_tag == hist[i] then
							  hist[i] = cur_screen.selected_tag
						  end
						  charitable.select_tag(hist[i], awful.screen.focused())
						  awful.screen.focus(cur_screen)
					  end
					end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
					  if not tags[i].selected then
						  charitable.toggle_tag(tags[i], awful.screen.focused())
					  elseif tags[i].selected and tags[i].screen == awful.screen.focused() then
						  charitable.toggle_tag(tags[i], awful.screen.focused())
					  end

				  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

	{ rule = { name = "Discord" },
	  properties = { floating = true,
					 titlebars_enabled = false,
					 placement = awful.placement.centered,
					}
				 },
	{ rule = { name = "ClickUp" },
	  properties = { floating = true,
					 titlebars_enabled = false,
					 placement = awful.placement.centered,
					}
				 },
	{ rule = { name = "Discord Updater" },
	  properties = { floating = true,
					 titlebars_enabled = false,
					 --placement = awful.placement.centered,
					 below = true
					}
				 },
        { rule = { class = { "Skype", "microsoft teams - preview" } },
            properties = { tag = "IV" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
tag.connect_signal("request::screen", function(t)
    t.selected = false
    for s in capi.screen do
        if s ~= t.screen then
            t.screen = s
            return
        end
    end
end)

client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c,focus_titlebar_settings)


end)
-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)
client.connect_signal("property::floating", function(c)
	if not c.class == "Discord" then
	local titlebar_settings = shallowCopy(focus_titlebar_settings)
	titlebar_settings.bg_focus = beautiful.blue1
	awful.titlebar(c,titlebar_settings)
end
end)

client.connect_signal("toggle_float", function(c)
	local titlebar_settings = shallowCopy(focus_titlebar_settings)
	if c.floating then
		titlebar_settings.bg_focus = beautiful.blue1
		awful.titlebar(c,titlebar_settings)
	else
		awful.titlebar(c,focus_titlebar_settings)
	end
end)

client.connect_signal("toggle", function(c)
	local titlebar_settings = shallowCopy(focus_titlebar_settings)
	if c.sticky then
		titlebar_settings.bg_focus = beautiful.purple1
		awful.titlebar(c,titlebar_settings)
	elseif c.floating then
		titlebar_settings.bg_focus = beautiful.blue1
		awful.titlebar(c,titlebar_settings)
	elseif c.ontop then
		titlebar_settings.bg_focus = beautiful.white2
		awful.titlebar(c,titlebar_settings)
	else
		awful.titlebar(c,focus_titlebar_settings)
	end
end)

client.connect_signal("toggle_ontop", function(c)
	local titlebar_settings = shallowCopy(focus_titlebar_settings)
	if c.ontop then
		titlebar_settings.bg_focus = beautiful.white2
		awful.titlebar(c,titlebar_settings)
	else
		awful.titlebar(c,focus_titlebar_settings)
	end
end)

tag.connect_signal("property::layout", function(t)
	local titlebar_settings = shallowCopy(focus_titlebar_settings)
	titlebar_settings.bg_focus = beautiful.blue1
	for k,c in pairs(t:clients()) do
		if awful.layout.getname(t.layout) == "floating" then
			awful.titlebar(c,titlebar_settings)
		else
			awful.titlebar(c,focus_titlebar_settings)
		end
	end

end)

-- tag.connect_signal("view_here", function(t)
-- 	local titlebar_settings = shallowCopy(focus_titlebar_settings)
-- 	titlebar_settings.bg_focus = beautiful.green1
--
-- 	for k,c in pairs(t:clients()) do
-- 			awful.titlebar(c,titlebar_settings)
-- 	end
-- end)

tag.connect_signal("property::selected", function(t)
	local titlebar_settings = shallowCopy(focus_titlebar_settings)
	titlebar_settings.bg_focus = beautiful.green1

	if awful.screen.focused().selected_tag ~= t then
		for k,c in pairs(t:clients()) do
			if not c.sticky then
				awful.titlebar(c,titlebar_settings)
			end
		end
	else
		for k,c in pairs(t:clients()) do
			awful.titlebar(c,focus_titlebar_settings)
		end
	end
end)

awesome.connect_signal("startup", function(c)
	awful.screen.focus(1)
	local titlebar_settings = shallowCopy(focus_titlebar_settings)
	for s in screen do
		for k,t in pairs(s.tags) do
			for k,c in pairs(t:clients()) do
				if c.sticky then
					titlebar_settings.bg_focus = beautiful.purple1
					awful.titlebar(c,titlebar_settings)
				elseif c.ontop then
					titlebar_settings.bg_focus = beautiful.white2
					awful.titlebar(c,titlebar_settings)
				elseif c.floating then
					titlebar_settings.bg_focus = beautiful.blue1
					awful.titlebar(c,titlebar_settings)
				else
					awful.titlebar(c,focus_titlebar_settings)
				end
			end
		end
	end
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
	c.border_width = beautiful.border_width
end)
client.connect_signal("unfocus", function(c)
	c.border_width = 0
end)
-- }}}
-- bling.module.window_swallowing.toggle() -- toggles window swallowing
awful.tag.history.restore = function() end

awful.spawn.with_shell(gears.filesystem.get_configuration_dir() .. "scripts/autostart.sh")


naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "top_right"

naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
	font = beautiful.font,
	fg = beautiful.black1,
	bg = beautiful.white2,
}

naughty.config.presets.low = {
	font = beautiful.font,
	fg = beautiful.black1,
	bg = beautiful.yellow2,
}

naughty.config.presets.critical = {
	font = beautiful.font,
	fg = beautiful.black1,
	bg = beautiful.red1,
	timeout = 0,
}

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

