-- https://www.tarantool.io/en/doc/latest/reference/reference_lua/decimal/

local luzer = require("luzer")
local decimal = require("decimal")

local function TestOneInput(buf)
    local ok, res = pcall(decimal.new, buf)
    if ok == false then
        return
    end
    assert(res ~= nil)
    assert(decimal.is_decimal(res) == true)
    assert(res - res == 0)
end

local args = {
    max_len = 4096,
    print_pcs = 1,
    artifact_prefix = "decimal_new_",
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
