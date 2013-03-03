_       = require 'underscore'
moment  = require 'moment'

nullOr = (x, fn) -> if x is null then null else fn x

dayAt = (day, offset) -> day.clone().startOf('day').hours(offset.hours()).minutes(offset.minutes())
todayAt = (time) -> dayAt moment(), (moment time, "H:m:s")
timePlusMinutes = (d, m) -> nullOr m, -> d.clone().add('m', m)
offsetTimes = (d, offsets) -> (_ offsets).map (m) -> timePlusMinutes d, m

prefixSum = (l) ->
    t = 0
    (_ l).map (x) -> nullOr x, -> t = t + x


calculateTripStarts = (startTime, endTime, every) ->
    st = todayAt startTime

    # TODO Return the count
    count = if endTime and every
        endTime = startTime unless endTime
        et = todayAt endTime
        (et.diff st, 'minutes') / every
    else
        0

    (_ [0..count]).map (i) -> timePlusMinutes st, i*every

@expandRange = (range) ->
    { startTime, endTime, every, offsets } = range

    timeOffsets = prefixSum offsets
    tripStarts = calculateTripStarts startTime, endTime, every

    (_ tripStarts).map (ts) -> offsetTimes ts, timeOffsets
