local M = {}
local theme_utils = require("utils.theme")
local snacks = require("snacks")

local theme_data = {
    ["Neomodern"] = {
        { name = "Moon (Dark)", theme = "neomodern", style = "dark", variant = "moon" },
        { name = "Iceclimber (Dark)", theme = "neomodern", style = "dark", variant = "iceclimber" },
        { name = "Gyokuro (Dark)", theme = "neomodern", style = "dark", variant = "gyokuro" },
        { name = "Hojicha (Dark)", theme = "neomodern", style = "dark", variant = "hojicha" },
        { name = "RosePrime (Dark)", theme = "neomodern", style = "dark", variant = "roseprime" },
        { name = "Moon (Light)", theme = "neomodern", style = "light", variant = "moon" },
        { name = "Iceclimber (Light)", theme = "neomodern", style = "light", variant = "iceclimber" },
        { name = "Gyokuro (Light)", theme = "neomodern", style = "light", variant = "gyokuro" },
        { name = "Hojicha (Light)", theme = "neomodern", style = "light", variant = "hojicha" },
        { name = "RosePrime (Light)", theme = "neomodern", style = "light", variant = "roseprime" },
    },
    ["Kanso"] = {
        { name = "Zen (Dark)", theme = "kanso", style = "dark", variant = "zen" },
        { name = "Mist (Dark)", theme = "kanso", style = "dark", variant = "mist" },
        { name = "Ink (Dark)", theme = "kanso", style = "dark", variant = "ink" },
        { name = "Pearl (Light)", theme = "kanso", style = "dark", variant = "pearl" },
    },
    ["Modus"] = {
        { name = "Dark", theme = "modus", style = "dark", variant = "default" },
        { name = "Light", theme = "modus", style = "light", variant = "default" },
    },
    ["Black-Metal"] = {
        { name = "Default (Dark)", theme = "black-metal", style = "dark", variant = "default" },
        { name = "Nile (Dark)", theme = "black-metal", style = "dark", variant = "nile" },
        { name = "Khold (Dark)", theme = "black-metal", style = "dark", variant = "khold" },
        { name = "Bathory (Dark)", theme = "black-metal", style = "dark", variant = "bathory" },
        { name = "Burzum (Dark)", theme = "black-metal", style = "dark", variant = "burzum" },
        { name = "Gorgoroth (Dark)", theme = "black-metal", style = "dark", variant = "gorgoroth" },
        { name = "Marduk (Dark)", theme = "black-metal", style = "dark", variant = "marduk" },
        { name = "Mayhem (Dark)", theme = "black-metal", style = "dark", variant = "mayhem" },
        { name = "Venom (Dark)", theme = "black-metal", style = "dark", variant = "venom" },
        { name = "Immortal (Dark)", theme = "black-metal", style = "dark", variant = "immortal" },
        { name = "Dark Funeral (Dark)", theme = "black-metal", style = "dark", variant = "dark-funeral" },
    },
    ["Koda"] = { { name = "Default", theme = "koda", style = "dark", variant = "default" } },
    ["Oldworld"] = { { name = "Default", theme = "oldworld", style = "dark", variant = "default" } },
    ["VSCode"] = {
        { name = "Dark", theme = "vscode", style = "dark", variant = "default" },
        { name = "Light", theme = "vscode", style = "light", variant = "default" },
    },
    ["Vague"] = { { name = "Default", theme = "vague", style = "dark", variant = "default" } },
}

local function apply_theme(item, main_name)
    vim.schedule(function()
        theme_utils.update_stylerc(item.theme, item.style, item.variant)
        theme_utils.load_theme()
        theme_utils.sync_system_theme()
        local msg = string.format("Theme: %s | Style: %s | Variant: %s", main_name, item.style, item.variant)
        vim.notify(msg, vim.log.levels.INFO)
    end)
end

local function variant_picker(main_name, variants)
    snacks.picker.pick({
        source = "theme_variants",
        items = variants,
        title = main_name .. " Options",
        layout = { preview = false, preset = "vscode" },
        win = {
            input = {
                keys = {
                    -- Hit Backspace to go back to the main list
                    ["<BS>"] = { "back_to_main", mode = { "n", "i" } },
                },
            },
        },
        actions = {
            back_to_main = function(picker)
                picker:close()
                M.theme_picker()
            end,
        },
        confirm = function(picker, item)
            picker:close()
            if not item then
                return
            end
            apply_theme(item, main_name)
        end,
        format = "text",
        transform = function(item)
            item.text = item.name
            return item
        end,
    })
end

M.theme_picker = function()
    local main_items = {}
    for name, _ in pairs(theme_data) do
        table.insert(main_items, { name = name })
    end
    table.sort(main_items, function(a, b)
        return a.name < b.name
    end)

    snacks.picker.pick({
        source = "themes",
        items = main_items,
        title = "Select Colorscheme",
        layout = { preview = false, preset = "vscode" },
        confirm = function(picker, item)
            picker:close()
            if not item then
                return
            end

            local variants = theme_data[item.name]

            if #variants == 1 then
                apply_theme(variants[1], item.name)
            else
                variant_picker(item.name, variants)
            end
        end,
        format = "text",
        transform = function(item)
            item.text = item.name
            return item
        end,
    })
end

return M
