function Linemode:custom()
    local f = self._file
    local size = f:size()

    -- Format size to a readable string (e.g., 100K, 2.5M)
    local readable_size = size and ya.readable_size(size) or " "

    -- Get modification time and format it
    local time_stamp = math.floor(f.cha.mtime or 0)
    local formatted_time = ""
    if time_stamp > 0 then
        -- Example format: "Jan 01 2025" for last year, "Jan 01 10:30" for current year
        if os.date("%Y", time_stamp) == os.date("%Y") then
            formatted_time = os.date("%b %d %H:%M", time_stamp)
        else
            formatted_time = os.date("%b %d %Y", time_stamp)
        end
    end

    -- Create the final line. string.format allows control over spacing.
    return ui.Line(string.format(
        "%8s %s", -- Adjust the 8s to control spacing for size
        readable_size,
        formatted_time
    ))
end
