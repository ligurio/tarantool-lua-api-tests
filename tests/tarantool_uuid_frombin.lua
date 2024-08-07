-- https://www.tarantool.io/en/doc/latest/reference/reference_lua/uuid/

local uuid = require("uuid")
local luzer = require("luzer")

local function TestOneInput(buf)
    local ok, res = pcall(uuid.frombin, buf)
    if ok == true then
        assert(res ~= nil)
        assert(uuid.is_uuid(res))
        assert(res:str())
    end
end

local args = {
    print_pcs = 1,
    max_len = 1024,
    artifact_prefix = "uuid_frombin_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
