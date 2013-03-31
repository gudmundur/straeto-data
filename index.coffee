fs = require 'fs'
path = require 'path'

_ = require 'underscore'
glob = require 'glob'
async = require 'async'

timetable = require './lib/timetable'
stops = require './lib/stops'
routes = require './lib/routes'

glob 'schedules/**.csv', (err, files) ->
    (_ files).each (file) ->
        stream = fs.createReadStream file

        timetable stream, (err, data) ->
            fs.writeFileSync "timetables/#{path.basename file, '.csv'}.json", JSON.stringify data

stops.importDefault (err, stops) ->
    data = JSON.stringify stops
    fs.writeFileSync 'stops/allStops.json', data

routes.importDefault (err, routes) ->
    readStops = (file, callback) ->
        stream = fs.createReadStream file
        stops.importCsvStream stream, (err, data) ->
            callback undefined, (_ data).map (s) -> Number s.stopId

    addStops = (route, callback) ->
        glob "stops/#{route.route}-*.csv", (err, files) ->
            async.map files, readStops, (err, stops) ->
                route.stops = stops
                callback undefined, route

    async.map routes, addStops, (err, routes) ->
        fs.writeFileSync 'routes/routes.json', JSON.stringify routes

