local presets = require("markview.presets").headings
require("markview").setup({
    markdown = {
        enable = true,
        headings = presets.numbered,
        tables = { enable = true },
        code_blocks = { enable = true },
        list_items = {
            shift_width = function(buffer, item)
                ---@type integer Parent list items indent. Must be at least 1.
                local parent_indnet = math.max(4, item.indent - vim.bo[buffer].shiftwidth)
                return item.indent * (1 / (parent_indnet * 2))
            end,
            marker_minus = {
                add_padding = function(_, item)
                    return item.indent > 1
                end,
            },
        },
    },
    markdown_inline = {
        tags = {
            default = {
                hl = "MarkviewCodeInfo",
                padding_left = "",
                padding_left_hl = "MarkviewCodeFg",
                padding_right = "",
                padding_right_hl = "MarkviewCodeFg",
            },
            enable = true,
        },
    },
    preview = { enable = true },
    latex = {
        enable = false,
        blocks = {
            enable = true,
            hl = "MarkviewCode",
            text = "  LaTeX ",
        },
    },

    html = { enable = true },
    comment = {
        enable = true,
        code_blocks = { enable = true },
        mentions = { enable = true },
        tasks = { enable = true },
        urls = { enable = true },
        task_scopes = { enable = true },
        taglinks = { enable = true },
    },
    hybrid_modes = { "n", "i" },
})

require("markview.extras.checkboxes").setup()
require("markview.extras.headings").setup()
require("markview.extras.editor").setup()
