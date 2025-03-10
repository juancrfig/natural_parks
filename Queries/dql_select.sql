-- Query 1: Total employees per role type with their average salary where salary exceeds the average for Management
SELECT e.role_type, COUNT(e.id) as total_employees, AVG(e.salary) as avg_salary
FROM employee e
JOIN (SELECT AVG(salary) as avg_mgmt_salary FROM employee WHERE role_type = 'Management') m
WHERE e.salary > m.avg_mgmt_salary
GROUP BY e.role_type;

-- Query 2: Number of species per area with population greater than the average population in that area
SELECT a.name, COUNT(as_.species_id) as species_count, SUM(as_.population) as total_population
FROM area a
JOIN area_species as_ ON a.id = as_.area_id
WHERE as_.population > (SELECT AVG(population) FROM area_species WHERE area_id = a.id)
GROUP BY a.name;

-- Query 3: Total budget of projects per park where budget exceeds the average project budget
SELECT p.name, COUNT(pr.id) as project_count, SUM(pr.budget) as total_budget
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN area a ON pa.area_id = a.id
JOIN area_species asp ON a.id = asp.area_id
JOIN project pr ON pr.id IN (SELECT project_id FROM project_researcher_species WHERE species_id = asp.species_id)
WHERE pr.budget > (SELECT AVG(budget) FROM project)
GROUP BY p.name;

-- Query 4: Average salary of conservation staff per specialty with more than 5 employees
SELECT cs.specialty, AVG(e.salary) as avg_salary, COUNT(cs.employee_id) as staff_count
FROM conservation_staff cs
JOIN employee e ON cs.employee_id = e.id
WHERE cs.employee_id IN (SELECT employee_id FROM conservation_area GROUP BY employee_id HAVING COUNT(area_id) > 1)
GROUP BY cs.specialty
HAVING staff_count > 5;

-- Query 5: Total visitors per park where visitor count exceeds the park's average
SELECT p.name, COUNT(vl.id) as total_visitors, MAX(vl.visit_time) as latest_visit
FROM park p
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE vl.visitor_id IN (SELECT visitor_id FROM visitor_stay WHERE check_out > check_in)
GROUP BY p.name
HAVING total_visitors > (SELECT AVG(COUNT(id)) FROM visitor_log GROUP BY entrance_shift_id);

-- Query 6: Number of vehicles per vigilance staff with above-average area assignments
SELECT vs.employee_id, COUNT(va.vehicle_id) as vehicle_count, AVG(e.salary) as avg_salary
FROM vigilance_staff vs
JOIN vigilance_area va ON vs.employee_id = va.vigilance_id
JOIN employee e ON vs.employee_id = e.id
WHERE va.area_id IN (SELECT area_id FROM area WHERE extent > (SELECT AVG(extent) FROM area))
GROUP BY vs.employee_id;

-- Query 7: Total budget of projects per researcher where researcher works on multiple species
SELECT rs.employee_id, COUNT(pr.id) as project_count, SUM(pr.budget) as total_budget
FROM research_staff rs
JOIN project_researcher prs ON rs.employee_id = prs.researcher_id
JOIN project pr ON prs.project_id = pr.id
WHERE rs.employee_id IN (SELECT researcher_id FROM project_researcher_species GROUP BY researcher_id HAVING COUNT(species_id) > 1)
GROUP BY rs.employee_id;

-- Query 8: Average population of species per type where population exceeds park average
SELECT s.type, AVG(asp.population) as avg_population, COUNT(s.id) as species_count
FROM species s
JOIN area_species asp ON s.id = asp.species_id
JOIN park_area pa ON asp.area_id = pa.area_id
WHERE asp.population > (SELECT AVG(population) FROM area_species WHERE area_id IN (SELECT area_id FROM park_area WHERE park_id = pa.park_id))
GROUP BY s.type;

-- Query 9: Total salary of employees per department with more than 10 parks
SELECT d.name, SUM(e.salary) as total_salary, COUNT(e.id) as employee_count
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN employee e ON e.id IN (SELECT employee_id FROM entrance_shift WHERE entrance_id IN (SELECT id FROM entrance WHERE park_id = p.id))
GROUP BY d.name
HAVING COUNT(p.id) > 10;

-- Query 10: Number of visitors per lodging category with capacity above average
SELECT l.category, COUNT(vs.id) as visitor_count, AVG(l.capacity) as avg_capacity
FROM lodging l
JOIN visitor_stay vs ON l.id = vs.lodging_id
WHERE l.capacity > (SELECT AVG(capacity) FROM lodging)
GROUP BY l.category;

-- Query 11: Total species per park with areas larger than the average extent
SELECT p.name, COUNT(DISTINCT asp.species_id) as species_count, MAX(a.extent) as max_extent
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN area a ON pa.area_id = a.id
JOIN area_species asp ON a.id = asp.area_id
WHERE a.extent > (SELECT AVG(extent) FROM area)
GROUP BY p.name;

-- Query 12: Average salary of management staff per park with more than 5 entrances
SELECT p.name, AVG(e.salary) as avg_salary, COUNT(ms.employee_id) as staff_count
FROM park p
JOIN entrance en ON p.id = en.park_id
JOIN entrance_shift es ON en.id = es.entrance_id
JOIN management_staff ms ON ms.employee_id = es.employee_id
JOIN employee e ON ms.employee_id = e.id
WHERE p.id IN (SELECT park_id FROM entrance GROUP BY park_id HAVING COUNT(id) > 5)
GROUP BY p.name;

-- Query 13: Total budget of projects researching species with population below average
SELECT pr.name, SUM(pr.budget) as total_budget, COUNT(prs.researcher_id) as researcher_count
FROM project pr
JOIN project_researcher prs ON pr.id = prs.project_id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
WHERE prsp.species_id IN (SELECT species_id FROM area_species WHERE population < (SELECT AVG(population) FROM area_species))
GROUP BY pr.name;

-- Query 14: Number of conservation staff per area with above-average population
SELECT a.name, COUNT(ca.conservation_id) as staff_count, AVG(e.salary) as avg_salary
FROM area a
JOIN conservation_area ca ON a.id = ca.area_id
JOIN employee e ON ca.conservation_id = e.id
WHERE a.id IN (SELECT area_id FROM area_species WHERE population > (SELECT AVG(population) FROM area_species))
GROUP BY a.name;

-- Query 15: Total visitors per department with parks founded before 2000
SELECT d.name, COUNT(vl.id) as visitor_count, MAX(vl.visit_time) as latest_visit
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE p.foundation_date < '2000-01-01'
GROUP BY d.name;

-- Query 16: Average budget of projects per species type with more than 3 researchers
SELECT s.type, AVG(pr.budget) as avg_budget, COUNT(DISTINCT prs.researcher_id) as researcher_count
FROM species s
JOIN project_researcher_species prsp ON s.id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
JOIN project_researcher prs ON pr.id = prs.project_id
WHERE pr.id IN (SELECT project_id FROM project_researcher GROUP BY project_id HAVING COUNT(researcher_id) > 3)
GROUP BY s.type;

-- Query 17: Total vehicles per brand used by vigilance staff with above-average salary
SELECT v.brand, COUNT(v.id) as vehicle_count, AVG(e.salary) as avg_salary
FROM vehicle v
JOIN vigilance_area va ON v.id = va.vehicle_id
JOIN vigilance_staff vs ON va.vigilance_id = vs.employee_id
JOIN employee e ON vs.employee_id = e.id
WHERE e.salary > (SELECT AVG(salary) FROM employee WHERE role_type = 'Vigilance')
GROUP BY v.brand;

-- Query 18: Number of employees per role with salary changes in the last year
SELECT e.role_type, COUNT(e.id) as employee_count, SUM(sl.to_salary) as total_new_salary
FROM employee e
JOIN salaryLogs sl ON e.id = sl.employee_id
WHERE sl.change_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
GROUP BY e.role_type;

-- Query 19: Average population change per species with alerts in the last month
SELECT s.common_name, AVG(spl.population) as avg_population, COUNT(sa.id) as alert_count
FROM species s
JOIN species_population_log spl ON s.id = spl.species_id
JOIN species_alert sa ON s.id = sa.species_id
WHERE sa.alert_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
GROUP BY s.common_name;

-- Query 20: Total budget of projects per department with more than 5 parks
SELECT d.name, SUM(pr.budget) as total_budget, COUNT(DISTINCT pr.id) as project_count
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN park_area pa ON p.id = pa.park_id
JOIN project_researcher_species prsp ON pa.area_id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
WHERE d.id IN (SELECT department_id FROM department_park GROUP BY department_id HAVING COUNT(park_id) > 5)
GROUP BY d.name;

-- Query 21: Number of visitors per entrance with shifts longer than average
SELECT e.entrance_number, COUNT(vl.id) as visitor_count, AVG(TIMESTAMPDIFF(HOUR, es.begin, es.end)) as avg_shift_hours
FROM entrance e
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE TIMESTAMPDIFF(HOUR, es.begin, es.end) > (SELECT AVG(TIMESTAMPDIFF(HOUR, begin, end)) FROM entrance_shift)
GROUP BY e.entrance_number;

-- Query 22: Total salary of researchers per project with budget above average
SELECT pr.name, SUM(e.salary) as total_salary, COUNT(prs.researcher_id) as researcher_count
FROM project pr
JOIN project_researcher prs ON pr.id = prs.project_id
JOIN research_staff rs ON prs.researcher_id = rs.employee_id
JOIN employee e ON rs.employee_id = e.id
WHERE pr.budget > (SELECT AVG(budget) FROM project)
GROUP BY pr.name;

-- Query 23: Average extent of areas per park with more than 10 species
SELECT p.name, AVG(a.extent) as avg_extent, COUNT(asp.species_id) as species_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN area a ON pa.area_id = a.id
JOIN area_species asp ON a.id = asp.area_id
WHERE a.id IN (SELECT area_id FROM area_species GROUP BY area_id HAVING COUNT(species_id) > 10)
GROUP BY p.name;

-- Query 24: Total visitors per lodging with capacity above park average
SELECT l.name, COUNT(vs.id) as visitor_count, MAX(l.capacity) as capacity
FROM lodging l
JOIN visitor_stay vs ON l.id = vs.lodging_id
WHERE l.capacity > (SELECT AVG(capacity) FROM lodging WHERE park_id = l.park_id)
GROUP BY l.name;

-- Query 25: Number of species per researcher with projects longer than average duration
SELECT rs.employee_id, COUNT(DISTINCT prsp.species_id) as species_count, AVG(DATEDIFF(pr.end_date, pr.start_date)) as avg_duration
FROM research_staff rs
JOIN project_researcher prs ON rs.employee_id = prs.researcher_id
JOIN project pr ON prs.project_id = pr.id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
WHERE DATEDIFF(pr.end_date, pr.start_date) > (SELECT AVG(DATEDIFF(end_date, start_date)) FROM project)
GROUP BY rs.employee_id;

-- Query 26: Total budget of projects per park with more than 3 entrances
SELECT p.name, SUM(pr.budget) as total_budget, COUNT(e.id) as entrance_count
FROM park p
JOIN entrance e ON p.id = e.park_id
JOIN park_area pa ON p.id = pa.park_id
JOIN project_researcher_species prsp ON pa.area_id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
WHERE p.id IN (SELECT park_id FROM entrance GROUP BY park_id HAVING COUNT(id) > 3)
GROUP BY p.name;

-- Query 27: Average salary of vigilance staff per area with extent above average
SELECT a.name, AVG(e.salary) as avg_salary, COUNT(va.vigilance_id) as staff_count
FROM area a
JOIN vigilance_area va ON a.id = va.area_id
JOIN vigilance_staff vs ON va.vigilance_id = vs.employee_id
JOIN employee e ON vs.employee_id = e.id
WHERE a.extent > (SELECT AVG(extent) FROM area)
GROUP BY a.name;

-- Query 28: Total visitors per department with entities responsible for more than 2 departments
SELECT d.name, COUNT(vl.id) as visitor_count, MAX(vl.visit_time) as latest_visit
FROM department d
JOIN department_entity de ON d.id = de.department_id
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE de.entity_id IN (SELECT entity_id FROM department_entity GROUP BY entity_id HAVING COUNT(department_id) > 2)
GROUP BY d.name;

-- Query 29: Number of projects per species with population changes in the last year
SELECT s.common_name, COUNT(pr.id) as project_count, SUM(pr.budget) as total_budget
FROM species s
JOIN project_researcher_species prsp ON s.id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
WHERE s.id IN (SELECT species_id FROM species_population_log WHERE change_date > DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
GROUP BY s.common_name;

-- Query 30: Average salary of employees per role with hires in the last 6 months
SELECT e.role_type, AVG(e.salary) as avg_salary, COUNT(ehl.id) as hire_count
FROM employee e
JOIN employee_hire_log ehl ON e.id = ehl.employee_id
WHERE ehl.hire_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 6 MONTH))
GROUP BY e.role_type;

-- Query 31: Total budget of projects per researcher with species alerts
SELECT rs.employee_id, SUM(pr.budget) as total_budget, COUNT(pr.id) as project_count
FROM research_staff rs
JOIN project_researcher prs ON rs.employee_id = prs.researcher_id
JOIN project pr ON prs.project_id = pr.id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
WHERE prsp.species_id IN (SELECT species_id FROM species_alert)
GROUP BY rs.employee_id;

-- Query 32: Number of visitors per park with lodging capacity above average
SELECT p.name, COUNT(vl.id) as visitor_count, AVG(l.capacity) as avg_capacity
FROM park p
JOIN lodging l ON p.id = l.park_id
JOIN visitor_stay vs ON l.id = vs.lodging_id
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE l.capacity > (SELECT AVG(capacity) FROM lodging WHERE park_id = p.id)
GROUP BY p.name;

-- Query 33: Average extent of areas per department with more than 5 species
SELECT d.name, AVG(a.extent) as avg_extent, COUNT(asp.species_id) as species_count
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN park_area pa ON p.id = pa.park_id
JOIN area a ON pa.area_id = a.id
JOIN area_species asp ON a.id = asp.area_id
WHERE a.id IN (SELECT area_id FROM area_species GROUP BY area_id HAVING COUNT(species_id) > 5)
GROUP BY d.name;

-- Query 34: Total salary of conservation staff per specialty with areas above average extent
SELECT cs.specialty, SUM(e.salary) as total_salary, COUNT(ca.area_id) as area_count
FROM conservation_staff cs
JOIN employee e ON cs.employee_id = e.id
JOIN conservation_area ca ON cs.employee_id = ca.conservation_id
WHERE ca.area_id IN (SELECT id FROM area WHERE extent > (SELECT AVG(extent) FROM area))
GROUP BY cs.specialty;

-- Query 35: Number of vehicles per type used in areas with above-average population
SELECT v.type, COUNT(v.id) as vehicle_count, AVG(asp.population) as avg_population
FROM vehicle v
JOIN vigilance_area va ON v.id = va.vehicle_id
JOIN area a ON va.area_id = a.id
JOIN area_species asp ON a.id = asp.area_id
WHERE asp.population > (SELECT AVG(population) FROM area_species)
GROUP BY v.type;

-- Query 36: Total budget of projects per park with more than 2 researchers
SELECT p.name, SUM(pr.budget) as total_budget, COUNT(DISTINCT prs.researcher_id) as researcher_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN project_researcher_species prsp ON pa.area_id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
JOIN project_researcher prs ON pr.id = prs.project_id
WHERE pr.id IN (SELECT project_id FROM project_researcher GROUP BY project_id HAVING COUNT(researcher_id) > 2)
GROUP BY p.name;

-- Query 37: Average salary of employees per role with role changes in the last year
SELECT e.role_type, AVG(e.salary) as avg_salary, COUNT(erc.id) as change_count
FROM employee e
JOIN employee_role_changes erc ON e.id = erc.employee_id
WHERE erc.change_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
GROUP BY e.role_type;

-- Query 38: Total visitors per entrance shift with duration above average
SELECT es.id, COUNT(vl.id) as visitor_count, TIMESTAMPDIFF(HOUR, es.begin, es.end) as shift_duration
FROM entrance_shift es
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE TIMESTAMPDIFF(HOUR, es.begin, es.end) > (SELECT AVG(TIMESTAMPDIFF(HOUR, begin, end)) FROM entrance_shift)
GROUP BY es.id;

-- Query 39: Number of species per area with population alerts in the last month
SELECT a.name, COUNT(asp.species_id) as species_count, SUM(asp.population) as total_population
FROM area a
JOIN area_species asp ON a.id = asp.area_id
JOIN species_alert sa ON asp.species_id = sa.species_id AND asp.area_id = sa.area_id
WHERE sa.alert_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
GROUP BY a.name;

-- Query 40: Total salary of management staff per park with more than 5 employees
SELECT p.name, SUM(e.salary) as total_salary, COUNT(ms.employee_id) as staff_count
FROM park p
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN management_staff ms ON es.employee_id = ms.employee_id
JOIN employee e ON ms.employee_id = e.id
WHERE p.id IN (SELECT park_id FROM entrance GROUP BY park_id HAVING COUNT(id) > 5)
GROUP BY p.name;

-- Query 41: Average budget of projects per species type with more than 2 areas
SELECT s.type, AVG(pr.budget) as avg_budget, COUNT(DISTINCT asp.area_id) as area_count
FROM species s
JOIN area_species asp ON s.id = asp.species_id
JOIN project_researcher_species prsp ON s.id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
WHERE s.id IN (SELECT species_id FROM area_species GROUP BY species_id HAVING COUNT(area_id) > 2)
GROUP BY s.type;

-- Query 42: Total visitors per lodging category with stays longer than average
SELECT l.category, COUNT(vs.id) as visitor_count, AVG(TIMESTAMPDIFF(DAY, vs.check_in, vs.check_out)) as avg_stay
FROM lodging l
JOIN visitor_stay vs ON l.id = vs.lodging_id
WHERE TIMESTAMPDIFF(DAY, vs.check_in, vs.check_out) > (SELECT AVG(TIMESTAMPDIFF(DAY, check_in, check_out)) FROM visitor_stay)
GROUP BY l.category;

-- Query 43: Number of employees per department with salary above average
SELECT d.name, COUNT(e.id) as employee_count, AVG(e.salary) as avg_salary
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN employee e ON es.employee_id = e.id
WHERE e.salary > (SELECT AVG(salary) FROM employee)
GROUP BY d.name;

-- Query 44: Total budget of projects per researcher with more than 3 species
SELECT rs.employee_id, SUM(pr.budget) as total_budget, COUNT(DISTINCT prsp.species_id) as species_count
FROM research_staff rs
JOIN project_researcher prs ON rs.employee_id = prs.researcher_id
JOIN project pr ON prs.project_id = pr.id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
WHERE rs.employee_id IN (SELECT researcher_id FROM project_researcher_species GROUP BY researcher_id HAVING COUNT(species_id) > 3)
GROUP BY rs.employee_id;

-- Query 45: Average population of species per park with more than 5 areas
SELECT p.name, AVG(asp.population) as avg_population, COUNT(pa.area_id) as area_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN area_species asp ON pa.area_id = asp.area_id
WHERE p.id IN (SELECT park_id FROM park_area GROUP BY park_id HAVING COUNT(area_id) > 5)
GROUP BY p.name;

-- Query 46: Total salary of vigilance staff per vehicle brand with above-average extent
SELECT v.brand, SUM(e.salary) as total_salary, COUNT(va.vigilance_id) as staff_count
FROM vehicle v
JOIN vigilance_area va ON v.id = va.vehicle_id
JOIN vigilance_staff vs ON va.vigilance_id = vs.employee_id
JOIN employee e ON vs.employee_id = e.id
WHERE va.area_id IN (SELECT id FROM area WHERE extent > (SELECT AVG(extent) FROM area))
GROUP BY v.brand;

-- Query 47: Number of visitors per park with foundation date before average
SELECT p.name, COUNT(vl.id) as visitor_count, MAX(p.foundation_date) as foundation_date
FROM park p
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE p.foundation_date < (SELECT AVG(foundation_date) FROM park)
GROUP BY p.name;

-- Query 48: Average salary of conservation staff per area with more than 2 species
SELECT a.name, AVG(e.salary) as avg_salary, COUNT(ca.conservation_id) as staff_count
FROM area a
JOIN conservation_area ca ON a.id = ca.area_id
JOIN conservation_staff cs ON ca.conservation_id = cs.employee_id
JOIN employee e ON cs.employee_id = e.id
WHERE a.id IN (SELECT area_id FROM area_species GROUP BY area_id HAVING COUNT(species_id) > 2)
GROUP BY a.name;

-- Query 49: Total budget of projects per department with more than 3 entities
SELECT d.name, SUM(pr.budget) as total_budget, COUNT(de.entity_id) as entity_count
FROM department d
JOIN department_entity de ON d.id = de.department_id
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN park_area pa ON p.id = pa.park_id
JOIN project_researcher_species prsp ON pa.area_id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
WHERE d.id IN (SELECT department_id FROM department_entity GROUP BY department_id HAVING COUNT(entity_id) > 3)
GROUP BY d.name;

-- Query 50: Number of species per researcher with projects ending after average end date
SELECT rs.employee_id, COUNT(DISTINCT prsp.species_id) as species_count, MAX(pr.end_date) as latest_end_date
FROM research_staff rs
JOIN project_researcher prs ON rs.employee_id = prs.researcher_id
JOIN project pr ON prs.project_id = pr.id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
WHERE pr.end_date > (SELECT AVG(end_date) FROM project)
GROUP BY rs.employee_id;

-- Query 51: Total visitors per lodging with check-in times after park average
SELECT l.name, COUNT(vs.id) as visitor_count, AVG(l.capacity) as avg_capacity
FROM lodging l
JOIN visitor_stay vs ON l.id = vs.lodging_id
WHERE vs.check_in > (SELECT AVG(check_in) FROM visitor_stay WHERE lodging_id IN (SELECT id FROM lodging WHERE park_id = l.park_id))
GROUP BY l.name;

-- Query 52: Average salary of employees per role with backups in the last month
SELECT e.role_type, AVG(e.salary) as avg_salary, COUNT(eb.backup_id) as backup_count
FROM employee e
JOIN employee_backup eb ON e.id = eb.employee_id
WHERE eb.backup_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
GROUP BY e.role_type;

-- Query 53: Total budget of projects per park with more than 4 species alerts
SELECT p.name, SUM(pr.budget) as total_budget, COUNT(sa.id) as alert_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN species_alert sa ON pa.area_id = sa.area_id
JOIN project_researcher_species prsp ON sa.species_id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
WHERE p.id IN (SELECT park_id FROM park_area WHERE area_id IN (SELECT area_id FROM species_alert GROUP BY area_id HAVING COUNT(id) > 4))
GROUP BY p.name;

-- Query 54: Number of visitors per entrance with shifts starting after average
SELECT e.entrance_number, COUNT(vl.id) as visitor_count, MIN(es.begin) as earliest_shift
FROM entrance e
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE es.begin > (SELECT AVG(begin) FROM entrance_shift)
GROUP BY e.entrance_number;

-- Query 55: Average population of species per area with more than 3 vigilance staff
SELECT a.name, AVG(asp.population) as avg_population, COUNT(va.vigilance_id) as staff_count
FROM area a
JOIN area_species asp ON a.id = asp.area_id
JOIN vigilance_area va ON a.id = va.area_id
WHERE a.id IN (SELECT area_id FROM vigilance_area GROUP BY area_id HAVING COUNT(vigilance_id) > 3)
GROUP BY a.name;

-- Query 56: Total salary of researchers per project with more than 2 areas
SELECT pr.name, SUM(e.salary) as total_salary, COUNT(DISTINCT prsp.species_id) as species_count
FROM project pr
JOIN project_researcher prs ON pr.id = prs.project_id
JOIN research_staff rs ON prs.researcher_id = rs.employee_id
JOIN employee e ON rs.employee_id = e.id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
WHERE pr.id IN (SELECT project_id FROM project_researcher_species WHERE species_id IN (SELECT species_id FROM area_species GROUP BY species_id HAVING COUNT(area_id) > 2))
GROUP BY pr.name;

-- Query 57: Number of vehicles per brand with vigilance in areas above average population
SELECT v.brand, COUNT(v.id) as vehicle_count, AVG(asp.population) as avg_population
FROM vehicle v
JOIN vigilance_area va ON v.id = va.vehicle_id
JOIN area a ON va.area_id = a.id
JOIN area_species asp ON a.id = asp.area_id
WHERE asp.population > (SELECT AVG(population) FROM area_species)
GROUP BY v.brand;

-- Query 58: Total visitors per department with parks having more than 3 lodgings
SELECT d.name, COUNT(vl.id) as visitor_count, COUNT(l.id) as lodging_count
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN lodging l ON p.id = l.park_id
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE p.id IN (SELECT park_id FROM lodging GROUP BY park_id HAVING COUNT(id) > 3)
GROUP BY d.name;

-- Query 59: Average salary of management staff per park with above-average visitor count
SELECT p.name, AVG(e.salary) as avg_salary, COUNT(vl.id) as visitor_count
FROM park p
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN management_staff ms ON es.employee_id = ms.employee_id
JOIN employee e ON ms.employee_id = e.id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE p.id IN (SELECT park_id FROM entrance WHERE id IN (SELECT entrance_id FROM visitor_log GROUP BY entrance_id HAVING COUNT(id) > (SELECT AVG(COUNT(id)) FROM visitor_log GROUP BY entrance_shift_id)))
GROUP BY p.name;

-- Query 60: Total budget of projects per species with more than 2 researchers
SELECT s.common_name, SUM(pr.budget) as total_budget, COUNT(DISTINCT prs.researcher_id) as researcher_count
FROM species s
JOIN project_researcher_species prsp ON s.id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
JOIN project_researcher prs ON pr.id = prs.project_id
WHERE s.id IN (SELECT species_id FROM project_researcher_species GROUP BY species_id HAVING COUNT(researcher_id) > 2)
GROUP BY s.common_name;

-- Query 61: Number of visitors per lodging with stays longer than park average
SELECT l.name, COUNT(vs.id) as visitor_count, AVG(TIMESTAMPDIFF(DAY, vs.check_in, vs.check_out)) as avg_stay
FROM lodging l
JOIN visitor_stay vs ON l.id = vs.lodging_id
WHERE TIMESTAMPDIFF(DAY, vs.check_in, vs.check_out) > (SELECT AVG(TIMESTAMPDIFF(DAY, check_in, check_out)) FROM visitor_stay WHERE lodging_id IN (SELECT id FROM lodging WHERE park_id = l.park_id))
GROUP BY l.name;

-- Query 62: Average extent of areas per park with more than 5 vigilance staff
SELECT p.name, AVG(a.extent) as avg_extent, COUNT(va.vigilance_id) as staff_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN area a ON pa.area_id = a.id
JOIN vigilance_area va ON a.id = va.area_id
WHERE p.id IN (SELECT park_id FROM park_area WHERE area_id IN (SELECT area_id FROM vigilance_area GROUP BY area_id HAVING COUNT(vigilance_id) > 5))
GROUP BY p.name;

-- Query 63: Total salary of employees per role with department reports in the last month
SELECT e.role_type, SUM(e.salary) as total_salary, COUNT(dr.id) as report_count
FROM employee e
JOIN entrance_shift es ON e.id = es.employee_id
JOIN entrance en ON es.entrance_id = en.id
JOIN park p ON en.park_id = p.id
JOIN department_park dp ON p.id = dp.park_id
JOIN department_report dr ON dp.department_id = dr.department_id
WHERE dr.report_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
GROUP BY e.role_type;

-- Query 64: Number of species per area with population logs in the last year
SELECT a.name, COUNT(asp.species_id) as species_count, SUM(spl.population) as total_logged_population
FROM area a
JOIN area_species asp ON a.id = asp.area_id
JOIN species_population_log spl ON asp.species_id = spl.species_id AND asp.area_id = spl.area_id
WHERE spl.change_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
GROUP BY a.name;

-- Query 65: Total budget of projects per park with archived projects
SELECT p.name, SUM(pr.budget) as total_budget, COUNT(pa_.id) as archived_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN project_researcher_species prsp ON pa.area_id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
JOIN project_archive pa_ ON pr.id = pa_.id
WHERE p.id IN (SELECT park_id FROM park_area WHERE area_id IN (SELECT species_id FROM project_researcher_species WHERE project_id IN (SELECT id FROM project_archive)))
GROUP BY p.name;

-- Query 66: Average salary of researchers per species type with more than 3 projects
SELECT s.type, AVG(e.salary) as avg_salary, COUNT(DISTINCT pr.id) as project_count
FROM species s
JOIN project_researcher_species prsp ON s.id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
JOIN project_researcher prs ON pr.id = prs.project_id
JOIN research_staff rs ON prs.researcher_id = rs.employee_id
JOIN employee e ON rs.employee_id = e.id
WHERE s.id IN (SELECT species_id FROM project_researcher_species GROUP BY species_id HAVING COUNT(project_id) > 3)
GROUP BY s.type;

-- Query 67: Total visitors per entrance shift with employees hired in the last year
SELECT es.id, COUNT(vl.id) as visitor_count, MAX(es.end) as shift_end
FROM entrance_shift es
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
JOIN employee_hire_log ehl ON es.employee_id = ehl.employee_id
WHERE ehl.hire_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
GROUP BY es.id;

-- Query 68: Number of vehicles per type used by vigilance staff with above-average salary
SELECT v.type, COUNT(v.id) as vehicle_count, AVG(e.salary) as avg_salary
FROM vehicle v
JOIN vigilance_area va ON v.id = va.vehicle_id
JOIN vigilance_staff vs ON va.vigilance_id = vs.employee_id
JOIN employee e ON vs.employee_id = e.id
WHERE e.salary > (SELECT AVG(salary) FROM employee WHERE role_type = 'Vigilance')
GROUP BY v.type;

-- Query 69: Total salary of conservation staff per park with more than 4 areas
SELECT p.name, SUM(e.salary) as total_salary, COUNT(pa.area_id) as area_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN conservation_area ca ON pa.area_id = ca.area_id
JOIN conservation_staff cs ON ca.conservation_id = cs.employee_id
JOIN employee e ON cs.employee_id = e.id
WHERE p.id IN (SELECT park_id FROM park_area GROUP BY park_id HAVING COUNT(area_id) > 4)
GROUP BY p.name;

-- Query 70: Average population of species per department with more than 3 parks
SELECT d.name, AVG(asp.population) as avg_population, COUNT(dp.park_id) as park_count
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN park_area pa ON p.id = pa.park_id
JOIN area_species asp ON pa.area_id = asp.area_id
WHERE d.id IN (SELECT department_id FROM department_park GROUP BY department_id HAVING COUNT(park_id) > 3)
GROUP BY d.name;

-- Query 71: Total budget of projects per researcher with species in multiple areas
SELECT rs.employee_id, SUM(pr.budget) as total_budget, COUNT(DISTINCT asp.area_id) as area_count
FROM research_staff rs
JOIN project_researcher prs ON rs.employee_id = prs.researcher_id
JOIN project pr ON prs.project_id = pr.id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
JOIN area_species asp ON prsp.species_id = asp.species_id
WHERE prsp.species_id IN (SELECT species_id FROM area_species GROUP BY species_id HAVING COUNT(area_id) > 1)
GROUP BY rs.employee_id;

-- Query 72: Number of visitors per park with monthly summaries above average
SELECT p.name, COUNT(vl.id) as visitor_count, MAX(vms.total_visitors) as max_monthly_visitors
FROM park p
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
JOIN department_park dp ON p.id = dp.park_id
JOIN visitor_monthly_summary vms ON YEAR(vl.visit_time) = vms.year AND MONTH(vl.visit_time) = vms.month
WHERE vms.total_visitors > (SELECT AVG(total_visitors) FROM visitor_monthly_summary)
GROUP BY p.name;

-- Query 73: Average salary of employees per role with visitor logs in the last month
SELECT e.role_type, AVG(e.salary) as avg_salary, COUNT(vl.id) as visitor_log_count
FROM employee e
JOIN entrance_shift es ON e.id = es.employee_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE vl.visit_time > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
GROUP BY e.role_type;

-- Query 74: Total budget of projects per species with alerts in multiple areas
SELECT s.common_name, SUM(pr.budget) as total_budget, COUNT(DISTINCT sa.area_id) as alert_area_count
FROM species s
JOIN project_researcher_species prsp ON s.id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
JOIN species_alert sa ON s.id = sa.species_id
WHERE s.id IN (SELECT species_id FROM species_alert GROUP BY species_id HAVING COUNT(area_id) > 1)
GROUP BY s.common_name;

-- Query 75: Number of vehicles per brand used in parks with more than 5 entrances
SELECT v.brand, COUNT(v.id) as vehicle_count, COUNT(DISTINCT p.id) as park_count
FROM vehicle v
JOIN vigilance_area va ON v.id = va.vehicle_id
JOIN park_area pa ON va.area_id = pa.area_id
JOIN park p ON pa.park_id = p.id
WHERE p.id IN (SELECT park_id FROM entrance GROUP BY park_id HAVING COUNT(id) > 5)
GROUP BY v.brand;

-- Query 76: Total salary of management staff per department with more than 2 entities
SELECT d.name, SUM(e.salary) as total_salary, COUNT(de.entity_id) as entity_count
FROM department d
JOIN department_entity de ON d.id = de.department_id
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN management_staff ms ON es.employee_id = ms.employee_id
JOIN employee e ON ms.employee_id = e.id
WHERE d.id IN (SELECT department_id FROM department_entity GROUP BY department_id HAVING COUNT(entity_id) > 2)
GROUP BY d.name;

-- Query 77: Average population of species per park with more than 3 lodgings
SELECT p.name, AVG(asp.population) as avg_population, COUNT(l.id) as lodging_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN area_species asp ON pa.area_id = asp.area_id
JOIN lodging l ON p.id = l.park_id
WHERE p.id IN (SELECT park_id FROM lodging GROUP BY park_id HAVING COUNT(id) > 3)
GROUP BY p.name;

-- Query 78: Total budget of projects per researcher with hires in the last year
SELECT rs.employee_id, SUM(pr.budget) as total_budget, COUNT(ehl.id) as hire_count
FROM research_staff rs
JOIN project_researcher prs ON rs.employee_id = prs.researcher_id
JOIN project pr ON prs.project_id = pr.id
JOIN employee_hire_log ehl ON rs.employee_id = ehl.employee_id
WHERE ehl.hire_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
GROUP BY rs.employee_id;

-- Query 79: Number of visitors per entrance with shifts ending after average
SELECT e.entrance_number, COUNT(vl.id) as visitor_count, MAX(es.end) as latest_shift_end
FROM entrance e
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
WHERE es.end > (SELECT AVG(end) FROM entrance_shift)
GROUP BY e.entrance_number;

-- Query 80: Average salary of vigilance staff per park with more than 4 species
SELECT p.name, AVG(e.salary) as avg_salary, COUNT(DISTINCT asp.species_id) as species_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN vigilance_area va ON pa.area_id = va.area_id
JOIN vigilance_staff vs ON va.vigilance_id = vs.employee_id
JOIN employee e ON vs.employee_id = e.id
JOIN area_species asp ON pa.area_id = asp.area_id
WHERE p.id IN (SELECT park_id FROM park_area WHERE area_id IN (SELECT area_id FROM area_species GROUP BY area_id HAVING COUNT(species_id) > 4))
GROUP BY p.name;

-- Query 81: Total budget of projects per species type with more than 2 parks
SELECT s.type, SUM(pr.budget) as total_budget, COUNT(DISTINCT pa.park_id) as park_count
FROM species s
JOIN area_species asp ON s.id = asp.species_id
JOIN park_area pa ON asp.area_id = pa.area_id
JOIN project_researcher_species prsp ON s.id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
WHERE s.id IN (SELECT species_id FROM area_species WHERE area_id IN (SELECT area_id FROM park_area GROUP BY area_id HAVING COUNT(park_id) > 2))
GROUP BY s.type;

-- Query 82: Number of visitors per lodging category with capacity above department average
SELECT l.category, COUNT(vs.id) as visitor_count, AVG(l.capacity) as avg_capacity
FROM lodging l
JOIN visitor_stay vs ON l.id = vs.lodging_id
JOIN park p ON l.park_id = p.id
JOIN department_park dp ON p.id = dp.park_id
WHERE l.capacity > (SELECT AVG(capacity) FROM lodging WHERE park_id IN (SELECT park_id FROM department_park WHERE department_id = dp.department_id))
GROUP BY l.category;

-- Query 83: Average extent of areas per department with more than 5 employees
SELECT d.name, AVG(a.extent) as avg_extent, COUNT(e.id) as employee_count
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN park_area pa ON p.id = pa.park_id
JOIN area a ON pa.area_id = a.id
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN employee e ON es.employee_id = e.id
WHERE d.id IN (SELECT department_id FROM department_park WHERE park_id IN (SELECT park_id FROM entrance WHERE id IN (SELECT entrance_id FROM entrance_shift GROUP BY entrance_id HAVING COUNT(employee_id) > 5)))
GROUP BY d.name;

-- Query 84: Total salary of researchers per project with species in above-average population areas
SELECT pr.name, SUM(e.salary) as total_salary, COUNT(DISTINCT prsp.species_id) as species_count
FROM project pr
JOIN project_researcher prs ON pr.id = prs.project_id
JOIN research_staff rs ON prs.researcher_id = rs.employee_id
JOIN employee e ON rs.employee_id = e.id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
WHERE prsp.species_id IN (SELECT species_id FROM area_species WHERE population > (SELECT AVG(population) FROM area_species))
GROUP BY pr.name;

-- Query 85: Number of vehicles per type used in parks with more than 3 departments
SELECT v.type, COUNT(v.id) as vehicle_count, COUNT(DISTINCT dp.department_id) as department_count
FROM vehicle v
JOIN vigilance_area va ON v.id = va.vehicle_id
JOIN park_area pa ON va.area_id = pa.area_id
JOIN park p ON pa.park_id = p.id
JOIN department_park dp ON p.id = dp.park_id
WHERE p.id IN (SELECT park_id FROM department_park GROUP BY park_id HAVING COUNT(department_id) > 3)
GROUP BY v.type;

-- Query 86: Total visitors per park with visitor summaries in the last year
SELECT p.name, COUNT(vl.id) as visitor_count, SUM(vms.total_visitors) as yearly_visitors
FROM park p
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN visitor_log vl ON es.id = vl.entrance_shift_id
JOIN visitor_monthly_summary vms ON YEAR(vl.visit_time) = vms.year AND MONTH(vl.visit_time) = vms.month
WHERE vms.summary_date > (SELECT DATE_SUB(CURDATE(), INTERVAL 1 YEAR))
GROUP BY p.name;

-- Query 87: Average salary of conservation staff per specialty with more than 3 areas
SELECT cs.specialty, AVG(e.salary) as avg_salary, COUNT(ca.area_id) as area_count
FROM conservation_staff cs
JOIN employee e ON cs.employee_id = e.id
JOIN conservation_area ca ON cs.employee_id = ca.conservation_id
WHERE cs.employee_id IN (SELECT conservation_id FROM conservation_area GROUP BY conservation_id HAVING COUNT(area_id) > 3)
GROUP BY cs.specialty;

-- Query 88: Total budget of projects per department with archived projects
SELECT d.name, SUM(pr.budget) as total_budget, COUNT(pa_.id) as archived_count
FROM department d
JOIN department_park dp ON d.id = dp.department_id
JOIN park p ON dp.park_id = p.id
JOIN park_area pa ON p.id = pa.park_id
JOIN project_researcher_species prsp ON pa.area_id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
JOIN project_archive pa_ ON pr.id = pa_.id
WHERE d.id IN (SELECT department_id FROM department_park WHERE park_id IN (SELECT park_id FROM park_area WHERE area_id IN (SELECT species_id FROM project_researcher_species WHERE project_id IN (SELECT id FROM project_archive))))
GROUP BY d.name;

-- Query 89: Number of species per researcher with projects starting after average
SELECT rs.employee_id, COUNT(DISTINCT prsp.species_id) as species_count, MIN(pr.start_date) as earliest_start
FROM research_staff rs
JOIN project_researcher prs ON rs.employee_id = prs.researcher_id
JOIN project pr ON prs.project_id = pr.id
JOIN project_researcher_species prsp ON pr.id = prsp.project_id
WHERE pr.start_date > (SELECT AVG(start_date) FROM project)
GROUP BY rs.employee_id;

-- Query 90: Total salary of vigilance staff per area with more than 2 vehicles
SELECT a.name, SUM(e.salary) as total_salary, COUNT(va.vehicle_id) as vehicle_count
FROM area a
JOIN vigilance_area va ON a.id = va.area_id
JOIN vigilance_staff vs ON va.vigilance_id = vs.employee_id
JOIN employee e ON vs.employee_id = e.id
WHERE a.id IN (SELECT area_id FROM vigilance_area GROUP BY area_id HAVING COUNT(vehicle_id) > 2)
GROUP BY a.name;

-- Query 91: Average population of species per park with more than 5 researchers
SELECT p.name, AVG(asp.population) as avg_population, COUNT(DISTINCT prs.researcher_id) as researcher_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN area_species asp ON pa.area_id = asp.area_id
JOIN project_researcher_species prsp ON asp.species_id = prsp.species_id
JOIN project_researcher prs ON prsp.project_id = prs.project_id
WHERE p.id IN (SELECT park_id FROM park_area WHERE area_id IN (SELECT species_id FROM project_researcher_species GROUP BY project_id HAVING COUNT(researcher_id) > 5))
GROUP BY p.name;

-- Query 92: Total visitors per lodging with check-out times after park average
SELECT l.name, COUNT(vs.id) as visitor_count, MAX(vs.check_out) as latest_check_out
FROM lodging l
JOIN visitor_stay vs ON l.id = vs.lodging_id
WHERE vs.check_out > (SELECT AVG(check_out) FROM visitor_stay WHERE lodging_id IN (SELECT id FROM lodging WHERE park_id = l.park_id))
GROUP BY l.name;

-- Query 93: Number of vehicles per brand used by vigilance staff in parks with above-average extent
SELECT v.brand, COUNT(v.id) as vehicle_count, AVG(a.extent) as avg_extent
FROM vehicle v
JOIN vigilance_area va ON v.id = va.vehicle_id
JOIN area a ON va.area_id = a.id
JOIN park_area pa ON a.id = pa.area_id
JOIN park p ON pa.park_id = p.id
WHERE a.extent > (SELECT AVG(extent) FROM area)
GROUP BY v.brand;

-- Query 94: Total salary of management staff per park with more than 3 departments
SELECT p.name, SUM(e.salary) as total_salary, COUNT(dp.department_id) as department_count
FROM park p
JOIN department_park dp ON p.id = dp.park_id
JOIN entrance e ON p.id = e.park_id
JOIN entrance_shift es ON e.id = es.entrance_id
JOIN management_staff ms ON es.employee_id = ms.employee_id
JOIN employee e ON ms.employee_id = e.id
WHERE p.id IN (SELECT park_id FROM department_park GROUP BY park_id HAVING COUNT(department_id) > 3)
GROUP BY p.name;

-- Query 95: Average budget of projects per species with population logs in multiple areas
SELECT s.common_name, AVG(pr.budget) as avg_budget, COUNT(DISTINCT spl.area_id) as area_count
FROM species s
JOIN project_researcher_species prsp ON s.id = prsp.species_id
JOIN project pr ON prsp.project_id = pr.id
JOIN species_population_log spl ON s.id = spl.species_id
WHERE s.id IN (SELECT species_id FROM species_population_log GROUP BY species_id HAVING COUNT(area_id) > 1)
GROUP BY s.common_name;

-- 96. Find deparments with more parks than the average number of parks per department
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


-- 97. Calculate the total surface area of parks, order from largest to smallest
SELECT p.name, SUM(a.extent) AS total_park_surface_area FROM park_area AS pa
JOIN park AS p ON p.id = pa.park_id
JOIN area AS a ON a.id = pa.area_id
GROUP BY park_id
ORDER BY total_park_surface_area DESC;


-- 98. Find the total number of unique species per park
SELECT p.name, COUNT(DISTINCT ar_es.species_id) AS number_of_species
FROM park AS p
LEFT JOIN park_area AS pa ON pa.park_id = p.id
LEFT JOIN area_species AS ar_es ON ar_es.area_id = pa.area_id
GROUP BY p.name ORDER BY number_of_species DESC;


-- 99. Parks older than the average

SELECT name, TIMESTAMPDIFF(YEAR, foundation_date, YEAR(NOW())) AS years_old 
FROM park
WHERE years_old > (
    SELECT AVG(count_years) FROM (
        SELECT TIMESTAMPDIFF(YEAR, foundation_date, YEAR(NOW()))
        FROM park
        GROUP BY name
    ) AS avg_query
);


-- Query 100: Total salary of conservation staff per park with more than 3 species above average population
SELECT p.name, SUM(e.salary) as total_salary, COUNT(DISTINCT asp.species_id) as species_count
FROM park p
JOIN park_area pa ON p.id = pa.park_id
JOIN area a ON pa.area_id = a.id
JOIN area_species asp ON a.id = asp.area_id
JOIN conservation_area ca ON a.id = ca.area_id
JOIN conservation_staff cs ON ca.conservation_id = cs.employee_id
JOIN employee e ON cs.employee_id = e.id
WHERE asp.species_id IN (
    SELECT species_id 
    FROM area_species 
    WHERE population > (SELECT AVG(population) FROM area_species)
)
GROUP BY p.name
HAVING species_count > 3;