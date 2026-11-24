-- Q1. top 5 stations by NUMBER of failed deliveries
SELECT station,
       SUM(attempted) AS failed,
       SUM(delivered + attempted + rejected) AS packages
FROM route_scans
GROUP BY station
ORDER BY failed DESC
LIMIT 5;

-- Q2. top 5 stations by failed delivery RATE
SELECT station,
       COUNT(*) AS routes,
       ROUND(SUM(attempted) * 100.0 / SUM(delivered + attempted + rejected), 2) AS fail_rate_pct
FROM route_scans
GROUP BY station
ORDER BY fail_rate_pct DESC
LIMIT 5;

-- Q3. compare DLA7 and DLA3 (they are #1 in each list)
-- failed per 1000 packages
SELECT station,
       COUNT(*) AS routes,
       SUM(delivered + attempted + rejected) AS packages,
       SUM(attempted) AS failed,
       ROUND(SUM(attempted) * 1000.0 / SUM(delivered + attempted + rejected), 1) AS failed_per_1000
FROM route_scans
WHERE station IN ('DLA7', 'DLA3')
GROUP BY station;
