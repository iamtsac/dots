local M = {}
local theme_utils = require("utils.theme_utils")
local snacks = require("snacks")

local theme_data = require("themes.themes")
local original_theme_state = nil

local function apply_theme(item, is_final)
    theme_utils.update_stylerc(item.theme, item.style, item.variant)
    theme_utils.load_theme()

    if is_final then
        theme_utils.sync_system_theme()
    end
end

local function variant_picker(main_name, variants)
    snacks.picker.pick({
        source = "theme_variants",
        items = variants,
        title = main_name .. " Options",
        layout = { preview = false, layout = { height = 0.3 } },
        win = {
            input = {
                keys = {
                    ["<BS>"] = { "back_to_main", mode = { "n", "i" } },
                },
            },
        },
        actions = {
            back_to_main = function(picker)
                vim.g.theme_picker_navigating = true
                picker:close()
                M.theme_picker()
            end,
        },
        on_change = function(picker, item)
            if item then
                apply_theme(item, false)
            end
        end,
        on_close = function()
            if original_theme_state and not vim.g.theme_picker_confirmed and not vim.g.theme_picker_navigating then
                apply_theme(original_theme_state, true)
                original_theme_state = nil
            end
        end,
        confirm = function(picker, item)
            vim.g.theme_picker_confirmed = true
            picker:close()
            if not item then
                return
            end

            apply_theme(item, true)
            local msg = string.format("Theme: %s | Style: %s | Variant: %s", main_name, item.style, item.variant)
            vim.notify(msg, vim.log.levels.INFO)
            original_theme_state = nil
        end,
        format = "text",
        transform = function(item)
            item.text = item.name
            return item
        end,
    })
end

M.theme_picker = function()
    vim.g.theme_picker_confirmed = false
    vim.g.theme_picker_navigating = false

    if not original_theme_state then
        local current_colorscheme = vim.g.colors_name or ""
        for _, variants in pairs(theme_data) do
            for _, v in ipairs(variants) do
                if current_colorscheme == v.theme or current_colorscheme:find(v.variant) then
                    original_theme_state = v
                    break
                end
            end
            if original_theme_state then
                break
            end
        end
    end

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
        layout = { preview = false, layout = { height = 0.3 } },
        on_change = function(picker, item)
            if item then
                local variants = theme_data[item.name]
                if variants and #variants > 0 then
                    apply_theme(variants[1], false)
                end
            end
        end,
        on_close = function()
            if original_theme_state and not vim.g.theme_picker_confirmed and not vim.g.theme_picker_navigating then
                apply_theme(original_theme_state, true)
                original_theme_state = nil
            end
        end,
        confirm = function(picker, item)
            if not item then
                picker:close()
                return
            end

            local variants = theme_data[item.name]

            if #variants == 1 then
                vim.g.theme_picker_confirmed = true
                picker:close()
                apply_theme(variants[1], true)
                local msg = string.format(
                    "Theme: %s | Style: %s | Variant: %s",
                    item.name,
                    variants[1].style,
                    variants[1].variant
                )
                vim.notify(msg, vim.log.levels.INFO)
                original_theme_state = nil
            else
                vim.g.theme_picker_navigating = true
                picker:close()
                vim.schedule(function()
                    vim.g.theme_picker_navigating = false
                    variant_picker(item.name, variants)
                end)
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
