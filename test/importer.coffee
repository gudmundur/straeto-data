importer = require '../lib/importer'
_        = require 'underscore'
fs       = require 'fs'


stops = ",,,,90000295,90000052"

single = """
,,,,90000295,90000052,90000053,90000054,90000055,90000056,90000296,90000297,90000298,90000458,90000460,90000015,10000802,10000802,10000854,13001201,13001523,13001300,13001525,14001526,14001527,14001528,14001500,14001500,14001561,14001626,14001542,14001543,14001544,14001620,14001612,14001616,14001617,14001602,14001660,14001603,14001604,14001647,14001648,14001649,14001655
From (time),To (time),Every (minutes),Days,Hlemmur,Barónsstígur,Frakkastígur,Þjóðleikhúsið,Lækjartorg,Ráðhúsið,Háskóli Íslands,BSÍ,Landspítalinn,Klambratún,Hlíðar,Kringlan,Hamraborg,Hamraborg,Sunnuhlíð,Arnarneshæð,Hegranes,Ásgarður,Ásar,Hjallabraut,Hraunbrún,Hellisgerði,Fjörður,Fjörður,Lækjargata,Grænakinn,Flensborg,Hlíðarbraut,Suðurbæjarlaug,Kelduhvammur,Haukahús,Ásvallalaug,Kirkjutorg,Kirkjuvellir,Akurvellir,Daggarvellir,Hraunvallaskóli,Hvannavellir,Glitvellir,Hnoðravellir,Klukkuvellir
7:35:00,,,saturdays,A,,,,,,,,,,,,,,0,1,1,1,1,1,2,1,1,2,3,2,0,1,1,1,1,1,0,1,0,1,1,1,1,0,1,1
"""

range = """
,,,,90000295,90000052,90000053,90000054,90000055,90000056,90000296,90000297,90000298,90000458,90000460,90000015,10000802,10000802,10000854,13001201,13001523,13001300,13001525,14001526,14001527,14001528,14001500,14001500,14001561,14001626,14001542,14001543,14001544,14001620,14001612,14001616,14001617,14001602,14001660,14001603,14001604,14001647,14001648,14001649,14001655
From (time),To (time),Every (minutes),Days,Hlemmur,Barónsstígur,Frakkastígur,Þjóðleikhúsið,Lækjartorg,Ráðhúsið,Háskóli Íslands,BSÍ,Landspítalinn,Klambratún,Hlíðar,Kringlan,Hamraborg,Hamraborg,Sunnuhlíð,Arnarneshæð,Hegranes,Ásgarður,Ásar,Hjallabraut,Hraunbrún,Hellisgerði,Fjörður,Fjörður,Lækjargata,Grænakinn,Flensborg,Hlíðarbraut,Suðurbæjarlaug,Kelduhvammur,Haukahús,Ásvallalaug,Kirkjutorg,Kirkjuvellir,Akurvellir,Daggarvellir,Hraunvallaskóli,Hvannavellir,Glitvellir,Hnoðravellir,Klukkuvellir
6:42:00,18:12:00,15,weekdays,A,0,1,1,1,2,1,2,2,1,2,2,2,5,1,1,2,1,2,1,2,1,2,2,2,3,1,1,1,1,1,1,0,1,0,1,1,1,1,0,1,2
"""


nullOrNumber = (x) -> x is null or (_ x).isNumber()


describe 'Timetable Importer', ->
    it 'processes stops', (done) ->
        importer.importCsv stops, (err, data) ->
            expect(err).to.be.null
            expect(data).to.be.an.object
            expect(data.stops).to.have.length 2
            expect(data.stops).to.include '90000295', '90000052'
            done()

    it 'processes single sections', (done) ->
        importer.importCsv single, (err, data) ->
            expect(data.sections).to.have.length 1
            section = data.sections[0]

            expect(section.type).to.be.equal 'single'
            expect(section).not.to.include.keys 'endTime', 'every'
            done()

    it 'processes range sections', (done) ->
        importer.importCsv range, (err, data) ->
            expect(data.sections).to.have.length 1
            section = data.sections[0]
            expect(section.type).to.be.equal 'range'
            expect(section).to.include.keys 'endTime', 'every'
            done()

    it 'processes multiple sections', (done) ->
        stream = fs.createReadStream "schedules/1-A-Klukkuvellir.csv"

        importer.importCsvStream stream, (err, data) ->
            expect(err).to.be.null
            expect(data.stops).to.have.length.at.least 1
            expect(data.sections).to.have.length.at.least 2
            stream.destroy()
            done()

    describe 'converts offsets', ->
        it 'with nulls', (done) ->
            importer.importCsv single, (err, data) ->
                section = data.sections[0]
                offsets = section.offsets

                expect(offsets).to.have.length data.stops.length
                expect(offsets).to.include null
                expect(offsets).to.satisfy (ls) -> (_ ls).all nullOrNumber
                done()

        it 'without nulls', (done) ->
            importer.importCsv range, (err, data) ->
                section = data.sections[0]
                offsets = section.offsets

                expect(offsets).to.have.length data.stops.length
                expect(offsets).not.to.include null
                expect(offsets).to.satisfy (ls) -> (_ ls).all _.isNumber
                done()
