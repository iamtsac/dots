local utils = require("utils.theme")
local args = utils.read_args(os.getenv("HOME") .. "/.config/stylerc")

local theme_name = args.theme
local style = args.style

if not theme_name then
    vim.notify("No theme defined in ~/.config/stylerc", vim.log.levels.WARN)
    return
end

-- Load the specific theme module
local ok, theme_module = pcall(require, "themes." .. theme_name)
if ok then
    theme_module.setup(style, utils)
else
    vim.notify("Could not load theme: " .. theme_name, vim.log.levels.ERROR)
end
