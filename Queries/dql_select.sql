-- 1. Find deparments with more parks than the average number of parks per department
SELECT d.name FROM department_park AS dp
JOIN department AS d ON d.id = dp.department_id
GROUP BY d.name
HAVING COUNT(dp.park_id) > (
    SELECT AVG(park_count) FROM (
        SELECT COUNT(park_id) AS park_count
        FROM department_park
        GROUP BY department_id
    ) AS avg_subquery
);