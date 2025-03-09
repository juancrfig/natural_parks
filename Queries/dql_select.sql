-- 1. Find deparments with more parks than the average number of parks per department
SELECT d.name, COUNT(dp.park_id) AS number_parks
FROM department_park AS dp
JOIN department AS d ON d.id = dp.department_id
GROUP BY d.name
HAVING COUNT(dp.park_id) > (
    SELECT AVG(park_count) FROM (
        SELECT COUNT(DISTINCT park_id) AS park_count
        FROM department_park 
        GROUP BY department_id
    ) AS avg_query
);


-- 2. Calculate the total surface area of parks, order from largest to smallest
SELECT p.name, SUM(a.extent) AS total_park_surface_area FROM park_area AS pa
JOIN park AS p ON p.id = pa.park_id
JOIN area AS a ON a.id = pa.area_id
GROUP BY park_id
ORDER BY total_park_surface_area DESC;


-- 3. Find the total number of unique species per park
SELECT p.name, COUNT(DISTINCT ar_es.species_id) AS number_of_species
FROM park AS p
LEFT JOIN park_area AS pa ON pa.park_id = p.id
LEFT JOIN area_species AS ar_es ON ar_es.area_id = pa.area_id
GROUP BY p.name ORDER BY number_of_species DESC;

