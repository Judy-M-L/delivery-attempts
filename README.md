# Amazon Failed Delivery Analysis (SQL)

## What I wanted to check
Which Amazon delivery stations have the most failed deliveries (driver tried but couldn't deliver), and where would a pilot to reduce them make the most sense?

## Data I used
- 2021 Amazon Last Mile Routing Research Challenge (public data on AWS)
- First 250 routes in the training package file
- 17 US stations, July 20 – August 26, 2018, 59,803 packages
- Each package is `DELIVERED`, `DELIVERY_ATTEMPTED` (failed) or `REJECTED`
- I counted the statuses per route and saved them in `route_scans.csv`, one row per route:
  `sample_row, station, route_date, delivered, attempted, rejected`

## Files
- `route_scans.csv`: the data
- `delivery.sqlite`: the database made from the csv
- `sql/01_explore.sql`: checking the data
- `sql/02_station_summary.sql`: count and rate for each station
- `sql/03_top_stations.sql`: top stations by count and by rate
- `sql/04_pilot_cost.sql`: pilot savings scenarios

## What I found

Overall: 59,294 delivered, 508 failed (0.85%), 1 rejected.

| Station | Routes | Packages | Failed | Fail Rate |
|---|---:|---:|---:|---:|
| DLA7 | 53 | 12,569 | 99 | 0.79% |
| DLA3 | 14 | 2,983 | 75 | 2.51% |
| DSE4 | 26 | 6,316 | 70 | 1.11% |

- DLA7 has the most failed deliveries (99), but only a 0.79% rate because it has the most packages.
- DLA3 has the highest rate, 2.51%. About 25 failures per 1,000 packages vs 8 at DLA7.
- Ranking by count and ranking by rate give a different #1.

Pilot savings, assuming 20% of failures can be prevented and each one saves $8:
- DLA7: 99 × 0.20 × $8 = $158.40
- DLA3: 75 × 0.20 × $8 = $120.00
- For the same pilot size (1,000 packages), DLA3 comes out ahead: about $40 vs $13.

## My take
- More savings at current volume: DLA7.
- Worse service quality: DLA3, rate is about 3 times higher.
- I'd want total station volume, failure reasons, and the real cost of a failed delivery before picking one.

## What this doesn't cover
- Only 250 routes. Some stations have very few routes (DBO1 has 2), so their rates aren't reliable.
- No information on why a delivery failed.
- 20% and $8 are my assumptions.
- 2018 US data. May not apply to today or to Canada.

## Tools
- SQLite
- Python (to convert the original JSON files to CSV)

## How to run
Make the database from the csv:
```
sqlite3 delivery.sqlite
.import --csv route_scans.csv route_scans
.quit
```
Run the queries:
```
sqlite3 -header -column delivery.sqlite < sql/02_station_summary.sql
sqlite3 -header -column delivery.sqlite < sql/03_top_stations.sql
sqlite3 -header -column delivery.sqlite < sql/04_pilot_cost.sql
```

## What I used in this project
- `GROUP BY` with `SUM` and `COUNT` for station summaries
- Rate = attempted / (delivered + attempted + rejected)
- `ORDER BY ... LIMIT 5` for top 5 lists
- `WHERE station IN (...)` to compare two stations

## Next
- All 6,112 training routes instead of 250
- Fail rate by day of the week
- Check whether a few routes cause most of the failures

## Data source
Merchán, D., Arora, J., Pachon, J., Konduri, K., Winkenbach, M., Parks, S., & Noszek, J. (2022). *2021 Amazon Last Mile Routing Research Challenge: Data Set.* Transportation Science. https://doi.org/10.1287/trsc.2022.1173

Data: https://registry.opendata.aws/amazon-last-mile-challenges/ (CC BY-NC 4.0). I selected 250 routes and counted package statuses per route.
