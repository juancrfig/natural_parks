-- 1. Find deparments with more parks than the average number of parks per department.

-- 2. Calculate the total surface area of parks, order from largest to smallest
SELECT p.name, SUM(a.extent) AS total_park_surface_area FROM park_area AS pa
JOIN park AS p ON p.id = pa.park_id
JOIN area AS a ON a.id = pa.area_id
GROUP BY park_id
ORDER BY total_park_surface_area DESC;

-- 3. Find the total number of unique species per park
SELECT 