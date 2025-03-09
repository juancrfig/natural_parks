-- 1. Function to sum the surface area of all areas within a specified park
DELIMITER //
CREATE FUNCTION GetParkTotalArea(parkId INT UNSIGNED)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total_area FLOAT;
    
    SELECT SUM(a.extent) INTO total_area
    FROM park_area pa
    JOIN area a ON pa.area_id = a.id
    WHERE pa.park_id = parkId;
    
    RETURN IFNULL(total_area, 0);
END //
DELIMITER ;

-- 2. Function to count the number of different species in an area
DELIMITER //
CREATE FUNCTION GetAreaSpeciesCount(areaId INT UNSIGNED)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE species_count INT UNSIGNED;
    
    SELECT COUNT(DISTINCT species_id) INTO species_count
    FROM area_species
    WHERE area_id = areaId;
    
    RETURN IFNULL(species_count, 0);
END //
DELIMITER ;

-- 3. Function to count the number of different species in a park
DELIMITER //
CREATE FUNCTION GetParkSpeciesCount(parkId INT UNSIGNED)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE species_count INT UNSIGNED;
    
    SELECT COUNT(DISTINCT aspec.species_id) INTO species_count
    FROM park_area pa
    JOIN area_species aspec ON pa.area_id = aspec.area_id
    WHERE pa.park_id = parkId;
    
    RETURN IFNULL(species_count, 0);
END //
DELIMITER ;

-- 4. Function to compute the average stay length for a lodging over a period
DELIMITER //
CREATE FUNCTION GetAvgStayLength(
    lodgingId INT UNSIGNED,
    startDate DATETIME,
    endDate DATETIME
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_length DECIMAL(10,2);
    
    SELECT AVG(TIMESTAMPDIFF(HOUR, check_in, check_out) / 24.0) INTO avg_length
    FROM visitor_stay
    WHERE lodging_id = lodgingId
    AND check_in >= startDate
    AND check_out <= endDate;
    
    RETURN IFNULL(avg_length, 0);
END //
DELIMITER ;

-- 5. Function to determine the duration of a project in days
DELIMITER //
CREATE FUNCTION GetProjectDuration(projectId INT UNSIGNED)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE duration INT UNSIGNED;
    
    SELECT DATEDIFF(end_date, start_date) INTO duration
    FROM project
    WHERE id = projectId;
    
    RETURN IFNULL(duration, 0);
END //
DELIMITER ;

-- 6. Function to count a visitor’s total visits to a specific park
DELIMITER //
CREATE FUNCTION GetVisitorParkVisits(
    visitorId INT UNSIGNED,
    parkId INT UNSIGNED
)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE visit_count INT UNSIGNED;
    
    SELECT COUNT(*) INTO visit_count
    FROM visitor_log vl
    JOIN entrance_shift es ON vl.entrance_shift_id = es.id
    JOIN entrance e ON es.entrance_id = e.id
    WHERE vl.visitor_id = visitorId
    AND e.park_id = parkId;
    
    RETURN IFNULL(visit_count, 0);
END //


-- 7. Compute the current occupancy percentage of a lodging

CREATE FUNCTION GetLodgingOccupancyPercentage(lodgingId INT UNSIGNED)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE current_occupancy INT;
    DECLARE total_capacity INT;
    DECLARE percentage DECIMAL(5,2);
    
    -- Get current occupancy from visitor_stay table
    SELECT COUNT(*) INTO current_occupancy
    FROM visitor_stay
    WHERE lodging_id = lodgingId
    AND check_in <= NOW()
    AND check_out >= NOW();
    
    -- Get total capacity (assuming a lodging table exists with id and capacity fields)
    SELECT capacity INTO total_capacity
    FROM lodging
    WHERE id = lodgingId;
    
    -- Calculate percentage
    IF total_capacity > 0 THEN
        SET percentage = (current_occupancy / total_capacity) * 100;
    ELSE
        SET percentage = 0;
    END IF;
    
    RETURN percentage;
END //


-- 8. Sum the total hours a staff member has worked in shifts

CREATE FUNCTION GetEmployeeTotalHours(employeeId INT UNSIGNED)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_hours DECIMAL(10,2);
    
    -- Sum the hours worked in all shifts
    SELECT SUM(TIMESTAMPDIFF(HOUR, begin, end)) INTO total_hours
    FROM entrance_shift
    WHERE employee_id = employeeId;
    
    -- Return 0 if no shifts are found
    RETURN IFNULL(total_hours, 0);
END //


-- 9. Calculate the percentage of a project's budget spent to date
CREATE FUNCTION GetProjectBudgetSpentPercentage(projectId INT UNSIGNED)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total_days INT;
    DECLARE elapsed_days INT;
    DECLARE percentage DECIMAL(5,2);
    
    -- Get total project duration in days
    SELECT DATEDIFF(end_date, start_date) INTO total_days
    FROM project
    WHERE id = projectId;
    
    -- Get elapsed days from start to now
    SELECT DATEDIFF(NOW(), start_date) INTO elapsed_days
    FROM project
    WHERE id = projectId;
    
    -- Calculate percentage
    IF total_days > 0 THEN
        SET percentage = (elapsed_days / total_days) * 100;
        -- Cap at 100%
        IF percentage > 100 THEN
            SET percentage = 100;
        END IF;
    ELSE
        SET percentage = 0;
    END IF;
    
    RETURN percentage;
END //


-- 10. Get the number of employees in a specific role

CREATE FUNCTION GetEmployeeCountByRole(roleType ENUM('Management', 'Vigilance', 'Conservation', 'Research'))
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE employee_count INT UNSIGNED;
    
    -- Count employees in the specified role
    SELECT COUNT(*) INTO employee_count
    FROM employee
    WHERE role_type = roleType;
    
    RETURN employee_count;
END //


-- 11. Get the total number of vehicles of a specific type
CREATE FUNCTION GetVehicleCountByType(vehicleType VARCHAR(30))
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE vehicle_count INT UNSIGNED;
    
    -- Count vehicles of the specified type
    SELECT COUNT(*) INTO vehicle_count
    FROM vehicle
    WHERE type = vehicleType;
    
    RETURN vehicle_count;
END //


-- 12. Get the Average Salary of Employees in a Specific Role

CREATE FUNCTION GetAverageSalaryByRole(roleType ENUM('Management', 'Vigilance', 'Conservation', 'Research'))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_salary DECIMAL(10,2);
    
    -- Calculate average salary for the role
    SELECT AVG(salary) INTO avg_salary
    FROM employee
    WHERE role_type = roleType;
    
    -- Return 0 if no employees are found
    RETURN IFNULL(avg_salary, 0);
END //


-- 13. Get the number of parks founded after a specific date

CREATE FUNCTION GetParksFoundedAfter(dateThreshold DATE)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE park_count INT UNSIGNED;
    
    -- Count parks founded after the specified date
    SELECT COUNT(*) INTO park_count
    FROM park
    WHERE foundation_date > dateThreshold;
    
    RETURN park_count;
END //


-- 14. Get the Total Number of Visitors Currently Staying in All Lodgings

CREATE FUNCTION GetTotalCurrentVisitors()
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE total_visitors INT UNSIGNED;
    
    -- Count visitors with active stays
    SELECT COUNT(*) INTO total_visitors
    FROM visitor_stay
    WHERE check_in <= NOW()
    AND check_out >= NOW();
    
    RETURN total_visitors;
END //


-- 15. Get the Most Common Job Among Visitors

CREATE FUNCTION GetMostCommonVisitorJob()
RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
    DECLARE common_job VARCHAR(60);
    
    -- Find the job with the highest count
    SELECT job INTO common_job
    FROM visitor
    GROUP BY job
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    
    RETURN common_job;
END //


-- 16. Get the Total Budget of All Ongoing Projects

CREATE FUNCTION GetTotalOngoingProjectBudget()
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total_budget DECIMAL(15,2);
    
    -- Sum budgets of ongoing projects
    SELECT SUM(budget) INTO total_budget
    FROM project
    WHERE start_date <= NOW()
    AND end_date >= NOW();
    
    -- Return 0 if no ongoing projects are found
    RETURN IFNULL(total_budget, 0);
END //


-- 17. Get the number of areas in a park

CREATE FUNCTION GetParkAreaCount(parkId INT UNSIGNED)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE area_count INT UNSIGNED;
    
    -- Count areas in the specified park
    SELECT COUNT(*) INTO area_count
    FROM park_area
    WHERE park_id = parkId;
    
    RETURN area_count;
END //


-- 18. Get the Total Population of a Species Across All Areas

CREATE FUNCTION GetTotalSpeciesPopulation(speciesId INT UNSIGNED)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE total_population INT UNSIGNED;
    
    -- Sum population of the species across all areas
    SELECT SUM(population) INTO total_population
    FROM area_species
    WHERE species_id = speciesId;
    
    -- Return 0 if no population data is found
    RETURN IFNULL(total_population, 0);
END //


-- 19. Get the Number of Visitors Who Have Visited a Park More Than Once

CREATE FUNCTION GetRepeatVisitorCount(parkId INT UNSIGNED)
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    DECLARE repeat_count INT UNSIGNED;
    
    -- Count distinct visitors with more than one visit
    SELECT COUNT(DISTINCT vl.visitor_id) INTO repeat_count
    FROM visitor_log vl
    JOIN entrance_shift es ON vl.entrance_shift_id = es.id
    JOIN entrance e ON es.entrance_id = e.id
    WHERE e.park_id = parkId
    GROUP BY vl.visitor_id
    HAVING COUNT(*) > 1;
    
    RETURN repeat_count;
END //


-- 20. Get the Average Number of Species per Area in a Park

CREATE FUNCTION GetAverageSpeciesPerArea(parkId INT UNSIGNED)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_species DECIMAL(10,2);
    
    -- Calculate average species count per area
    SELECT AVG(species_count) INTO avg_species
    FROM (
        SELECT COUNT(DISTINCT aspec.species_id) as species_count
        FROM park_area pa
        JOIN area_species aspec ON pa.area_id = aspec.area_id
        WHERE pa.park_id = parkId
        GROUP BY pa.area_id
    ) as area_species_counts;
    
    -- Return 0 if no areas or species are found
    RETURN IFNULL(avg_species, 0);
END //

DELIMITER ;