local M = {}
local theme_utils = require("utils.theme")

local themes = {
    { name = "Koda",                theme = "koda",       style = "dark" },
    { name = "Kanso (Dark)",        theme = "kanso",      style = "dark" },
    { name = "Kanso (Light)",       theme = "kanso",      style = "light" },
    { name = "Vague",               theme = "vague",      style = "dark" },
    { name = "Neomodern (Dark)",    theme = "neomodern",  style = "dark" },
    { name = "Neomodern (Light)",   theme = "neomodern",  style = "light" },
    { name = "Oldworld",            theme = "oldworld",   style = "dark" },
    { name = "Modus (Dark)",        theme = "modus",      style = "dark" },
    { name = "Modus (Light)",       theme = "modus",      style = "light" },
    { name = "VSCode (Dark)",       theme = "vscode",     style = "dark" },
    { name = "VSCode (Light)",      theme = "vscode",     style = "light" },
    { name = "Black Metal",         theme = "black-metal",style = "dark" },
}

M.theme_picker = function()
    local snacks = require("snacks")
    snacks.picker.pick({
        source = "themes",
        items = themes,
        layout = { preview = false },
        ---@param item {name:string, theme:string, style:string}
        confirm = function(picker, item)
            picker:close()
            if not item then return end
            theme_utils.update_stylerc(item.theme, item.style)
            theme_utils.load_theme()
            theme_utils.sync_system_theme()
            vim.notify("Theme set to: " .. item.name, vim.log.levels.INFO)
        end,
        format = "text",
        transform = function(item)
            item.text = item.name
            return item
        end,
    })
end

return M
