_ = require 'underscore'

converter = require '../lib/converter'

describe 'Timetable Converter', ->
    it 'expands ranges', ->
        offsets = [0, 0, 1, 1, 1, 1, 1, 2, 3, 2, 5, 2, 1, 2, 1, 2, 1, 2, 2, 1, 1, 1, 3]

        tripTimes = converter.expandRange {
             startTime: '6:46:00'
             endTime: '9:16:00'
             every: 15
             days: 'weekdays'
             type: 'range'
             offsets: offsets
        }

        tripDuration = (_ offsets).reduce ((a, b) -> a + b), 0

        expect(tripTimes).to.have.length 11

        [firstTrip, trips..., lastTrip] = tripTimes
        [firstTime, times..., lastTime] = firstTrip

        expect(firstTrip).to.have.length 23
        expect(firstTrip[0].format 'HH:mm').to.be.equal '06:46'
        expect(lastTrip[0].format 'HH:mm').to.be.equal '09:16'

        expect(lastTime.diff firstTime, 'minutes').to.be.equal tripDuration

    it 'expands single trips', ->
        tripTimes = converter.expandRange {
            startTime: '7:48:00'
            endTime: null
            every: null
            days: 'saturdays'
            type: 'single'
            offsets: [0, 1, 1, 1, 3]
        }

        trip = tripTimes[0]

        expect(tripTimes).to.have.length 1
        expect(trip).to.have.length 5
        expect(trip[0].format 'HH:mm').to.be.equal '07:48'
        expect(trip[4].format 'HH:mm').to.be.equal '07:54'

    it 'expands with nulls', ->
        offsets = [null, null, 0, 1, 1, 1, 3]

        tripTimes = converter.expandRange {
            startTime: '7:48:00'
            endTime: null
            every: null
            days: 'saturdays'
            type: 'single'
            offsets: offsets
        }

        nulls = (_ tripTimes[0]).filter (t) -> t is null
        expect(nulls).to.have.length 2

    it 'expands with embedded nulls', ->
        offsets = [0,1,1,1,1,null,null,null,1,2]
        tripTimes = converter.expandRange {
            startTime: '7:48:00'
            endTime: null
            every: null
            days: 'saturdays'
            type: 'single'
            offsets: offsets
        }

        times = (_ tripTimes[0])
        expect(times.indexOf null).to.be.equal 5
        expect(times.lastIndexOf null).to.be.equal 7

        before = tripTimes[0][4]
        after = tripTimes[0][8]

        expect(after.diff before, 'seconds', true).to.be.equal 60

        nulls = (times).filter (t) -> t is null
        expect(nulls).to.have.length 3
