routes = require '../lib/routes'

twoDirections = """
1,red,Hlemmur » Kópavogur » Garðabær » Fjörður » Vellir,Vellir » Fjörður » Garðabær » Kópavogur » Hlemmur
"""

oneDirection = """
23,blue,Ásgarður » Álftanes » Ásgarður
"""

describe 'Route Importer', ->
    it 'processes two directional routes', (done) ->
        routes.importCsv twoDirections, (err, data) ->

            expect(data).to.be.an.array
            expect(data).to.have.length 1

            route = data[0]

            expect(route.route).to.be.equal 1
            expect(route.color).to.be.equal 'red'
            expect(route.directions).to.have.length 2
            expect(route.directions[0]).to.have.length 5

            done()

    it 'processes one directional routes', (done) ->
        routes.importCsv oneDirection, (err, data) ->
            expect(data).to.be.an.array
            expect(data).to.have.length 1

            route = data[0]

            expect(route.route).to.be.equal 23
            expect(route.color).to.be.equal 'blue'
            expect(route.directions).to.have.length 1
            expect(route.directions[0]).to.have.length 3
