-- summary for each station
-- fail rate = attempted / all packages (delivered + attempted + rejected)

SELECT station,
       COUNT(*) AS routes,
       SUM(delivered + attempted + rejected) AS packages,
       SUM(attempted) AS failed,
       ROUND(SUM(attempted) * 100.0 / SUM(delivered + attempted + rejected), 2) AS fail_rate_pct
FROM route_scans
GROUP BY station
ORDER BY failed DESC;
