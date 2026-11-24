-- look at the data first
SELECT * FROM route_scans LIMIT 10;

-- how many routes
SELECT COUNT(*) AS total_routes FROM route_scans;

-- how many stations
SELECT COUNT(DISTINCT station) AS total_stations FROM route_scans;

-- date range
SELECT MIN(route_date) AS first_date, MAX(route_date) AS last_date FROM route_scans;

-- total packages by status
SELECT SUM(delivered) AS delivered,
       SUM(attempted) AS attempted,
       SUM(rejected) AS rejected,
       SUM(delivered + attempted + rejected) AS total_packages
FROM route_scans;

-- overall failed delivery rate (%)
SELECT ROUND(SUM(attempted) * 100.0 / SUM(delivered + attempted + rejected), 2) AS fail_rate_pct
FROM route_scans;

-- routes with no failed deliveries
SELECT COUNT(*) AS routes_with_no_fails
FROM route_scans
WHERE attempted = 0;
