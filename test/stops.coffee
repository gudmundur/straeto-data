stops = require '../lib/stops'

describe 'Stop Importer', ->
    it 'defaults', (done) ->
        stops.importDefault (err, stops) ->
            expect(stops).to.be.an.object

            stop = stops['90000270']

            expect(stop).to.deep.equal
                stopId: '90000270'
                longName: 'Menntaskólinn við Hamrahlíð / MH'
                shortName: 'MH'
                latitude: 64.131307999805
                longitude: -21.9072679997438

            done()
