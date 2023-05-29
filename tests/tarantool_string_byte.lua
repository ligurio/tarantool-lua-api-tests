local luzer = require("luzer")

local function TestOneInput(buf)
    local fdp = luzer.FuzzedDataProvider(buf)
    local b = fdp:consume_string(1)
    if #b ~= 0 then
        local char_code = string.byte(b)
        assert(type(char_code) == "number")
        local byte = string.char(char_code)
        assert(byte == b)
    end
end

local args = {
    max_len = 4096,
    artifact_prefix = "string_byte",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
