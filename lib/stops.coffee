csv = require 'csv'

parseCsv = (csv, callback) ->
    stops = {}

    csv
        .on('record', (row, index) ->
            return if index is 0

            [stopId, longName, shortName, latitude, longitude] = row
            stops[stopId] = { stopId, longName, shortName, latitude, longitude }
        )
        .on('error', (err) -> callback err)
        .on('end', (count) -> callback null, stops)

@importCsv = (string, callback) ->
    parseCsv csv().from(string), callback

@importCsvStream = (stream, callback) ->
    parseCsv csv().from.stream(stream), callback
