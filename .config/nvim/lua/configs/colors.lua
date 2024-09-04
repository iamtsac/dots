local fn = vim.fn

local get_color = function(group, attr)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

local colors = {
    bg = get_color("Normal", "bg"),
    fg = get_color("Normal", "fg"),
    yellow = get_color("DiagnosticWarn", "fg"),
    cyan = get_color("Identifier", "fg"),
    darkblue = get_color("Structure", "fg"),
    green = get_color("String", "fg"),
    orange = get_color("Constant", "fg"),
    violet = get_color("Character", "fg"),
    magenta = get_color("qFileName", "fg"),
    blue = get_color("Function", "fg"),
    red = get_color("Boolean", "fg"),
    gray = get_color("NormalFloatNC", "bg"),
}

return colors
