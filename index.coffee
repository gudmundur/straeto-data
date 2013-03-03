fs = require 'fs'
_ = require 'underscore'

converter = require './lib/converter'
importer = require './lib/importer'

stream = fs.createReadStream 'schedules/23-A-Asgardur.csv'
importer.importCsvStream stream, (err, data) ->
    timetable = (_ data.sections)
                    .chain()
                    .map((s) -> converter.expandRange s)
                    .flatten(true)
                    .value()

    console.log timetable.length
    #console.log _.zip data.stops, timetable[0]
