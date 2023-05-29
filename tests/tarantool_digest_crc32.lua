-- lua: rewrite crc32 digest via Lua C API,
-- https://github.com/tarantool/tarantool/pull/6956/commits/b2c3f868e98f5ff35469bf6a7d06a6f25b682f8e
-- https://github.com/tarantool/tarantool/issues/7937

local luzer = require("luzer")
local digest = require("digest")

local function TestOneInput(buf)
    local fdp = luzer.FuzzedDataProvider(buf)
    local a = fdp:consume_string(10)
    local b = fdp:consume_string(10)

	-- calculate crc32 with one step.
    local ok, res1 = pcall(digest.crc32.new, a .. b)
    assert(ok == true)
    assert(res1)

	-- calculate crc32 incrementally.
    local res2 = digest.crc32.new()
    res2:update(a)
    res2:update(b)

	assert(res1 == res2)
end

local args = {
    max_len = 4096,
    print_pcs = 1,
    artifact_prefix = "digest_crc32_",
    max_total_time = 60,
    print_final_stats = 1,
}
luzer.Fuzz(TestOneInput, nil, args)
