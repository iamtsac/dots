local Snacks = require("snacks")
local conf = require("configs.snacks_configs")

Snacks.setup({
    terminal = conf.terminal,
    bigfile = { enabled = true },
    dashboard = conf.dashboard,
    explorer = { enabled = false },
    image = conf.image_opts,
    indent = conf.indent,
    input = { enabled = true },
    profiler = { enabled = false },
    notifier = {
        enabled = false,
        timeout = 3000,
    },
    quickfile = { enabled = true },
    git = { enabled = true },
    scope = { enabled = true },
    scroll = conf.scroll,
    statuscolumn = conf.statuscolumn,
    words = { enabled = false },
    picker = conf.picker,
    zen = conf.zen,
    toggle = { enabled = true },
    rename = { enabled = false },
    styles = {},
})

Snacks.config.style("snacks_image", conf.image_style)
-- vim.g.snacks_scroll = false

vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks_picker_input",
    callback = function(args)
        vim.keymap.set("i", "<C-t>", "<nop>", {
            buffer = args.buf,
        })
    end,
})
