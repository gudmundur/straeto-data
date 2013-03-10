csv = require 'csv'
fs  = require 'fs'
_   = require 'underscore'

toInt = (ls) -> (_ ls).map (x) -> if x.length is 0 then null else Number x

parseCsv = (csv, callback) ->
    data = {
        stops: []
        sections: []
    }

    csv
    .on('record', (row, index) ->
        switch index
            when 0
                # stops
                data.stops = (_ row).filter (r) -> r.length > 0
            when 1
            else
                # data
                [startTime, endTime, every, days, scheduleType, offsets...] = row

                section = { startTime, days, scheduleType, offsets: toInt offsets }

                if endTime.length > 0 and every.length > 0
                    section = _.extend section, { endTime, every: (Number every), type: 'range' }
                else
                    section.type = 'single'

                data.sections.push section
    )
    .on('error', (err) -> callback err)
    .on('end', (count) -> callback null, data)

@importCsv = (string, callback) ->
    parseCsv csv().from(string), callback

@importCsvStream = (stream, callback) ->
    parseCsv csv().from.stream(stream), callback
