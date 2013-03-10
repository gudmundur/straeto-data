_ = require 'underscore'
Hash = require 'hashish'

converter = require './converter'
importer = require './importer'

unusedStop = ([s, t]) -> t is null
pairStopTime = (stops, times) -> _.zip stops, times
toTime = (t) -> if t is null then null else t.format 'HH:mm'
merge = (arrays) -> [].concat.apply [], arrays

expandSection = (stops, section, callback) ->
    expanded = converter.expandRange section

    trips = (_ expanded).map (e) ->
        times = (_ e).map toTime
        pairs = pairStopTime stops, times
        (_ pairs).reject unusedStop

    days: section.days
    trips: trips

module.exports = (stream, callback) ->
    importer.importCsvStream stream, (err, data) ->
        stops = data.stops
        sections = (_ data.sections).map (s) -> expandSection stops, s
        byDays = ((_ sections).groupBy (s) -> s.days)
        timetable = Hash.map(byDays, (v) -> merge (_ v).pluck 'trips')

        callback undefined, timetable
