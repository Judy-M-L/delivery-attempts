# Amazon Failed Delivery Analysis (SQL)

## Overview
When a driver tries to deliver a package but can't (nobody home, can't access the building, etc.), the package has to be delivered again. This costs time and money. In this project I used real Amazon delivery data to find which delivery stations have the most failed deliveries, and where a pilot program to reduce them would make the most sense.

## Dataset
- Source: 2021 Amazon Last Mile Routing Research Challenge (public data on AWS)
- I used the first 250 routes in the training package file
- 17 US delivery stations, July 20 – August 26, 2018
- 59,803 packages in total
- Each package has one of 3 statuses:
  - `DELIVERED`
  - `DELIVERY_ATTEMPTED` (tried but failed)
  - `REJECTED`
- I counted the statuses for each route and saved it as `route_scans.csv` (one row per route)

| Column | Meaning |
|---|---|
| sample_row | route number in my sample (1–250) |
| station | delivery station code |
| route_date | date of the route |
| delivered | number of packages delivered |
| attempted | number of failed delivery attempts |
| rejected | number of rejected packages |

## Questions
1. What is the overall failed delivery rate?
2. Which stations have the most failed deliveries?
3. Which stations have the highest failed delivery rate?
4. If we run a pilot, which station would save more money?

## Project Structure
```
delivery-attempts/
├── README.md
├── route_scans.csv
├── delivery.sqlite
└── sql/
    ├── 01_explore.sql         # looking at the data
    ├── 02_station_summary.sql # count and rate for each station
    ├── 03_top_stations.sql    # top stations by count and by rate
    └── 04_pilot_cost.sql      # pilot savings scenarios
```

## Key Findings

**Overall:** 59,294 delivered, 508 failed (0.85%), 1 rejected.

**Top stations:**

| Station | Routes | Packages | Failed | Fail Rate |
|---|---:|---:|---:|---:|
| DLA7 | 53 | 12,569 | 99 | 0.79% |
| DLA3 | 14 | 2,983 | 75 | 2.51% |
| DSE4 | 26 | 6,316 | 70 | 1.11% |

- **DLA7 has the most failed deliveries (99)**, but its rate is only 0.79% because it has a lot of packages.
- **DLA3 has the highest rate (2.51%)**. That's about 25 failed deliveries per 1,000 packages, compared to 8 at DLA7.
- So the answer depends on what we look at. Ranking by count and ranking by rate give different results.

**Pilot savings** (assuming 20% of failed deliveries can be prevented and each saves $8):
- DLA7: 99 × 0.20 × $8 = **$158.40**
- DLA3: 75 × 0.20 × $8 = **$120.00**
- But for the same pilot size (1,000 packages), DLA3 saves more: about $40 vs $13.

## Recommendation
- If the goal is saving the most money with the current volume, start with **DLA7**.
- If the goal is fixing service quality, look at **DLA3** first because its rate is 3 times higher.
- Before spending money, we need more data: total station volume, why deliveries failed, and the real cost of a failed delivery.

## Limitations
- Only 250 routes, and some stations have very few routes (DBO1 only has 2), so their rates are not reliable.
- The data doesn't say *why* a delivery failed.
- 20% and $8 are my assumptions, not real numbers.
- This is 2018 US data, so it may not apply to today or to Canada.

## Tools
- SQLite
- Python (to convert the original JSON files to CSV)

## How to Run
Create the database from the CSV:
```
sqlite3 delivery.sqlite
.import --csv route_scans.csv route_scans
.quit
```
Then run the queries:
```
sqlite3 -header -column delivery.sqlite < sql/02_station_summary.sql
sqlite3 -header -column delivery.sqlite < sql/03_top_stations.sql
sqlite3 -header -column delivery.sqlite < sql/04_pilot_cost.sql
```

## What I Learned
- Using `GROUP BY` and `SUM` to make a summary for each station
- Calculating a rate needs the right denominator (all packages, not just delivered)
- The station with the highest count is not always the station with the highest rate
- Results can change a lot depending on the assumptions, so it's important to write them down

## Next Steps
- Use all 6,112 routes instead of 250
- Check if failed deliveries are higher on certain days of the week
- Look at individual routes to see if a few bad routes cause most of the failures

## Data Source
Merchán, D., Arora, J., Pachon, J., Konduri, K., Winkenbach, M., Parks, S., & Noszek, J. (2022). *2021 Amazon Last Mile Routing Research Challenge: Data Set.* Transportation Science. https://doi.org/10.1287/trsc.2022.1173

Data: https://registry.opendata.aws/amazon-last-mile-challenges/ (CC BY-NC 4.0). I selected 250 routes and counted package statuses per route.
