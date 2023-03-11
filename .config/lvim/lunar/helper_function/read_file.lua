local function read_file(file_name)
    local f = assert(io.open(file_name, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

return read_file
