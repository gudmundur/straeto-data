fs = require 'fs'
path = require 'path'

_ = require 'underscore'
glob = require 'glob'

timetable = require './lib/timetable'

glob 'schedules/**.csv', (err, files) ->
    (_ files).each (file) ->
        stream = fs.createReadStream file

        timetable stream, (err, data) ->
            fs.writeFileSync "timetables/#{path.basename file, '.csv'}.json", JSON.stringify data
