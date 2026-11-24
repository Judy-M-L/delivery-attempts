-- how much money could a pilot save?
-- assumptions (not real Amazon numbers):
--   each prevented failed delivery saves $8
--   the pilot can prevent 10%, 20% or 30% of failed deliveries

-- 20% scenario
SELECT station,
       SUM(attempted) AS failed,
       SUM(attempted) * 0.20 AS prevented,
       ROUND(SUM(attempted) * 0.20 * 8, 2) AS savings_usd
FROM route_scans
WHERE station IN ('DLA7', 'DLA3')
GROUP BY station
ORDER BY savings_usd DESC;

-- all 3 scenarios
SELECT station,
       SUM(attempted) AS failed,
       ROUND(SUM(attempted) * 0.10 * 8, 2) AS savings_10pct,
       ROUND(SUM(attempted) * 0.20 * 8, 2) AS savings_20pct,
       ROUND(SUM(attempted) * 0.30 * 8, 2) AS savings_30pct
FROM route_scans
WHERE station IN ('DLA7', 'DLA3')
GROUP BY station
ORDER BY failed DESC;

-- same pilot size: 1000 packages at each station (20%, $8)
SELECT station,
       ROUND(SUM(attempted) * 1000.0 / SUM(delivered + attempted + rejected) * 0.20 * 8, 2) AS savings_per_1000_packages
FROM route_scans
WHERE station IN ('DLA7', 'DLA3')
GROUP BY station;
