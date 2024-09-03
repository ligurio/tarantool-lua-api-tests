local datetime = require("datetime")
local datetime_lib = require("tarantool_datetime_lib")
local luzer = require("luzer")

local function TestOneInput(buf)
    local fdp = luzer.FuzzedDataProvider(buf)
    local dt_fields1 = datetime_lib.random_dt_str(fdp)
    local dt_fields2 = datetime_lib.random_dt_str(fdp)
    local dt1 = datetime.new(dt_fields1)
    local dt2 = datetime.new(dt_fields2)

    -- PROPERTY: B - (B - A) == A
    -- Blocked by https://github.com/tarantool/tarantool/issues/7145
    local sub_dt = dt1 - dt2
    local add_dt = sub_dt + dt2
    assert(add_dt == dt1, "(A - B) + B != A")

    -- PROPERTY: A - A == B - B == +0 seconds
    local iv1 = datetime.interval.new()
    assert(dt1 - dt1 == dt2 - dt2, "A - A == B - B")
    assert(dt1 - dt1 == iv1, "A - A == +0 seconds")

    -- PROPERTY: dt1 + dt2 == dt1:add(dt2)
    -- assert(dt + dt_fields == dt:add(dt_fields), "dt1 + dt2 == dt1:add(dt2)")
    -- BROKEN: addition makes date less than minimum allowed -5879610-06-22

    -- PROPERTY: 31.12.YYYY + 1 day == 01.01.(YYYY + 1)
    -- "February 29 is not the only day affected by the leap year. Another very
    -- important date is December 31, because it is the 366th day of the year and
    -- many applications mistakenly hard-code a year as 365 days."
    -- Source: https://azure.microsoft.com/en-us/blog/is-your-code-ready-for-the-leap-year/
    dt1 = dt1:add({ day = 1})
    -- TODO: assert(dt.day == 1, ('31 Dec + 1 day != 1 Jan (%s)'):format(dt))

    -- PROPERTY: dt1.wday == (dt1 + 7 days).wday
    iv1 = datetime.interval.new({ day = 7 })
    assert((dt1 + iv1).wday == dt1.wday, "")
    assert(dt1:add({ day = 7 }).wday == dt1.wday, "")
end

local args = {
    print_pcs = 1,
    artifact_prefix = "datetime_arith_",
    max_len = 2048,
    max_total_time = 60,
}
luzer.Fuzz(TestOneInput, nil, args)
