local harpoon = require("harpoon")
harpoon:setup({})

-- picker
local function generate_harpoon_picker()
    local file_paths = {}
    for _, item in ipairs(harpoon:list().items) do
        table.insert(file_paths, {
            text = item.value,
            file = item.value
        })
    end
    return file_paths
end
