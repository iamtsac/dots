local Snacks = require("snacks")
local conf = require("configs/snacks_configs").snacks_config()

Snacks.setup({
    terminal = conf.terminal,
    bigfile = { enabled = true },
    dashboard = { enabled = false },
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
    styles = {
        notification = {
            -- wo = { wrap = true } -- Wrap notifications
        },
    },
    picker = conf.picker,
    zen = conf.zen,
    toggle = { enabled = true },
    rename = { enabled = false },
})

Snacks.config.style("snacks_image", conf.image_style)
vim.g.snacks_scroll = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker_input",
  callback = function(args)
    vim.keymap.set("i", "<C-t>", "<nop>", {
      buffer = args.buf,
    })
  end,
})
