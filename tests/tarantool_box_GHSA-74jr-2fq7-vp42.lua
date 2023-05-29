-- https://github.com/tarantool/security/issues/20
-- Disable panic "failed to eval/fetch replication_synchro_quorum" in src/box/box.cc.

local luzer = require("luzer")

local function TestOneInput(buf)
    rawset(_G, 'res', false)
    local ok = pcall(box.cfg, {replication_synchro_quorum = buf})
    if ok == false then
        return -1
    end
    assert(rawget(_G, 'res') == false)
end

local args = {
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
