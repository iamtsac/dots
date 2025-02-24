local Snacks = require("snacks")
local conf = require("configs/snacks_configs").snacks_config()



Snacks.setup({
    ---@type snacks.Config
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = true },
    image = { enabled = true },
    indent = conf.indent,
    input = { enabled = true },
    notifier = {
        enabled = false,
        timeout = 3000,
    },
    quickfile = { enabled = true },
    git = {enabled = true},
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = conf.statuscolumn,
    words = { enabled = true },
    styles = {
        notification = {
            -- wo = { wrap = true } -- Wrap notifications
        },
    },
    picker = conf.picker,
    zen = conf.zen,
    toggle = { enabled = true }
})
