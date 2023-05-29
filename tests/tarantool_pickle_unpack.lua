-- https://www.tarantool.io/en/doc/latest/reference/reference_lua/pickle/

local pickle = require("pickle")
local luzer = require("luzer")

local function TestOneInput(buf)
    local ok, unpacked = pcall(pickle.unpack, buf)
    if ok == true then
        local packed = pickle.pack(unpacked)
        assert(#packed == #buf)
    end
end

local args = {
    max_len = 4096,
    artifact_prefix = "pickle_unpack_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
