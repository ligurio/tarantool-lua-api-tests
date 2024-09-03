local function TestOneInput(buf)
    local fdp = luzer.FuzzedDataProvider(buf)

    -- PROPERTY: The fields in datetime constructor must be equal
    -- to the same fields in datetime object and `:totable()`.

    -- PROPERTY: datetime.parse(tostring(dt)):format() == tostring(dt)
    dt1 = datetime.new(time_units1)
    dt2 = datetime.new(time_units2)
    local dt_iso8601 = datetime.parse(tostring(dt1), {format = 'iso8601'}):format()
    assert(dt_iso8601 == tostring(dt1), ('Parse roundtrip with iso8601 %s'):format(tostring(dt1)))
    local dt_rfc3339 = datetime.parse(tostring(dt1), {format = 'rfc3339'}):format()
    assert(dt_rfc3339 == tostring(dt1), ('Parse roundtrip with rfc3339 %s'):format(tostring(dt1)))

    -- PROPERTY: Formatted datetime is the same as produced by os.date().
    dt1 = datetime.new(time_units1)
    -- Seems `os.date()` does not support negative epoch.

    -- PROPERTY: 28.02.YYYY + 1 year == 28.02.(YYYY + 1), where YYYY is a non-leap year.
    local dt1 = datetime.new(time_units1)
    dt1:set({
        year = random_year(fdp, false),
        month = 02,
        day = 28,
    })
    local dt_plus_1y = dt1:add({year = 1})
    -- https://www.quora.com/When-did-using-a-leap-year-start
    if dt_plus_1y.year > 1584 then
        local msg = ('Non-leap year: 28.02.YYYY + 1Y != 28.02.(YYYY + 1): %s + 1y != %s '):format(dt1, dt_plus_1y)
        -- TODO: assert(dt_plus_1y.day == 28, msg)
    end

    -- PROPERTY: 29.02.YYYY + 1 year == 28.02.(YYYY + 1),
    -- where YYYY is a leap year.
    local dt1 = datetime.new(time_units1)
    dt1:set({
        year = random_year(fdp, true),
        month = 02,
        day = 29,
    })
    dt_plus_1y = dt1:add({year = 1})
    -- https://www.quora.com/When-did-using-a-leap-year-start
    if dt_plus_1y.year > 1584 then
        local msg = ('Leap year: 29.02.YYYY + 1Y != 28.02.(YYYY + 1): %s + 1y != %s'):format(dt1, dt_plus_1y)
        assert(dt_plus_1y.day == 28, msg)
    end

    -- PROPERTY: 31.03.YYYY + 1 month == 30.04.YYYY
    local dt1 = datetime.new(time_units1)
    dt1:set({
        month = 03,
        day = 31,
    })
    local dt_plus_1m = dt1
    dt_plus_1m:add({ month = 1 })
    local msg = ('31.03.YYYY + 1m != 30.04.YYYY: %s + 1m != %s'):format(dt1, dt_plus_1m)
    -- TODO: assert(dt_plus_1m.day == 30, msg)
    msg = ('31.03.YYYY + 1m != 30.04.YYYY: %s + 1m != %s'):format(dt1, dt_plus_1m)
    assert(dt_plus_1m.month == 04, msg)

    -- PROPERTY: Difference of datetimes with leap and non-leap
    -- years is a 1 second.
    local leap_year = datetime_lib.random_year(fdp, true)
    local non_leap_year = datetime_lib.random_year(fdp, false)
    dt1 = datetime.new({ year = leap_year })
    dt2 = datetime.new({ year = non_leap_year })
    --local diff = datetime.new():set({ year = leap_year - non_leap_year, sec = 1 })
    -- TODO: assert(dt1 - dt2 == single_sec, ('%s - %s != 1 sec (%s)'):format(dt1, dt2, dt1 - dt2))
end
