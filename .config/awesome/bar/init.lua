local gears = require("gears")
local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local beautiful = require("beautiful")
local wibox = require("wibox")
local lain = require("lain")

local bar = {}

function bar.mem()

	local mymem = lain.widget.mem({
		timeout = 1,
	    settings = function()
	           widget:set_markup("MEM:" .. mem_now.perc .. "% ")
	       end
	})
	return mymem

end

function bar.cpu()

	local mycpu = lain.widget.cpu({
		timeout = 1,
	    settings = function()
	           widget:set_markup("CPU:" .. cpu_now.usage .. "% ")
	       end
	})
	return mycpu

end

function bar.volbar()

	local volume = lain.widget.alsa({

		timeout = 1,
	    settings = function()
			if volume_now.status == "off" then
				volume_now.level = "M"
			end	          
			widget:set_markup("VOL:" .. volume_now.level .. "% ")
	       end
	})
	return volume

end

return bar
