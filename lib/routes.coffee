csv = require 'csv'
_ = require 'underscore'

splitDirections = (d) -> d.split ' » '

parseCsv = (csv, callback) ->
    routes = []

    csv
        .on('record', (row, index) ->
            [route, color, directions...] = row
            routes.push
                route: (Number route),
                color: color
                directions: (_ directions).map splitDirections
        )
        .on('error', (err) -> callback err)
        .on('end', (count) -> callback null, routes)

@importCsv = (string, callback) ->
    parseCsv csv().from(string), callback

@importCsvStream = (stream, callback) ->
    parseCsv csv().from.stream(stream), callback
