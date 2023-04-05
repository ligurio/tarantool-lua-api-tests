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

local script_path = debug.getinfo(1).source:match("@?(.*/)")

local args = {
    max_total_time = 100 * 60,
    corpus = script_path .. "/tarantool-corpus/box_GHSA-74jr-2fq7-vp42",
}
luzer.Fuzz(TestOneInput, nil, args)
