# Strætó data

This repository contains data files for (hopefully) all publicly available and user contributed static data for [Strætó bs.][straeto] which provides the public transportation for the greater Reykjavík area.

## Which data is available

- [List of all stops](https://github.com/gudmundur/straeto-data/blob/master/stops/allStops.csv).
- Stops in order per direction, for all routes available in the [real-time feed][realtimefeed].
- [Rough route paths](https://github.com/gudmundur/straeto-data/blob/master/routes/routes.json).
- Timetables.

## Route stops

In the `stops` folder, the files are named as such

	routeNr-direction-endStop.csv

For example route 1 going from Hlemmur towards Klukkuvellir is named `1-A-Klukkuvellir.csv`.

## Route paths

The routes data is included in the `routes` folder. The format should be fairly self-explanatory but one should be aware that the data is drafted up in Google Earth so it is far from perfect.

## Schedules

The schedules from the [Strætó][straeto] website have been processed into a [computer friendly format][schedules].

Each column represents trips that are alike. The start of a trip is marked by a `0` and the consequent numbers represent how long it takes in minutes to reach that stop from the previous one.

## Timetables

In the `timetables` folder, the same naming pattern is used as for the route stops above. The timetables are generated and expanded from the schedules. 

## Contributing

If you would like to contribute data that you have, either fork this repository and send a pull request or submit an issue with whatever you have.

## License

The `allStops.csv` file was provided by Strætó bs. and the license of which is unclear, but could be published online.

The remaining data is dual licenced under [CC BY-SA 3.0][cc-by-sa] and [ODbl 1.0][odbl].

![CC BY-SA 3.0](http://i.creativecommons.org/l/by-sa/3.0/80x15.png)

## Thanks (in no particular order)

* [Strætó bs.][straeto]
* [Björgvin Ragnarsson](https://github.com/nifgraup).
* [Árni Hermann Reynisson](https://github.com/arnihermann).
* [Kristján Bjarni Guðmundsson](https://market.android.com/details?id=is.taktu_straeto).
* [Hrafn Eiríksson](https://market.android.com/details?id=com.aldasoftware.bus).

[straeto]: http://www.straeto.is
[realtimefeed]: http://www.straeto.is/rauntimakort/
[scraper]: https://github.com/gudmundur/straeto-scraper
[schedules]: https://docs.google.com/spreadsheet/ccc?key=0AsyYqUhG4vXTdFE1TklaMl84MjduNTRFVmpVQ2FzVVE&usp=sharing
[cc-by-sa]: http://creativecommons.org/licenses/by-sa/3.0/
[odbl]: http://opendatacommons.org/licenses/odbl/summary/

