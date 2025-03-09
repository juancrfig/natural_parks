DELIMITER //


-- 1. Add a new park, validating uniqueness.

CREATE PROCEDURE AddNewPark (
    IN park_name VARCHAR(100),
    IN park_foundation_date DATE
)
BEGIN
    -- Declare variables and exit handler first
    DECLARE v_current_date DATE;
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Retrieve error details for the most recent error
        GET DIAGNOSTICS CONDITION 1 err_code = MYSQL_ERRNO, err_msg = MESSAGE_TEXT;
        -- Precompute the concatenated error message in a variable
        SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
        -- Signal the error with the prepared message
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Now you can execute statements
    SET v_current_date = CURRENT_DATE();
    
    -- Check if a park with the same name already exists
    IF EXISTS (
        SELECT 1 FROM park
        WHERE name = park_name
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Park already exists';
    -- Check if the foundation date is in the future
    ELSEIF park_foundation_date > current_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Foundation date cannot be in the future';
    ELSE 
        INSERT INTO park(name, foundation_date)
        VALUES (park_name, park_foundation_date);
    END IF;
END//


-- 2. Add a new visitor manually

CREATE PROCEDURE LogVisitor(
    IN v_vistor_cedula BIGINT,
    IN v_visitor_name TEXT,
    IN v_visitor_address TEXT,
    IN v_visitor_job TEXT
)
BEGIN 
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 err_code = MYSQL_ERRNO,
        err_msg = MESSAGE_TEXT;
        SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;

    IF EXISTS (
        SELECT 1 FROM visitor
        WHERE cedula = v_vistor_cedula 
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This cedula is already registered';
    ELSE
        INSERT INTO visitor(cedula, name, address, job)
        VALUES
        (v_vistor_cedula, v_visitor_name, v_visitor_address, v_visitor_job);
    END IF;
END//


-- 3. Update a project’s budget

CREATE PROCEDURE UpdateProjectBudget(
    IN v_project_id INT,
    IN v_new_budget DECIMAL(15, 2)
)
BEGIN
    DECLARE v_err_code INT;
    DECLARE v_err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
        v_err_code = MYSQL_ERRNO,
        v_err_msg = MESSAGE_TEXT;
        SET msg = CONCAT('Error code ', v_err_code, ': ', v_err_msg);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = msg;
    END; 

    IF NOT EXISTS (
        SELECT 1 FROM project
        WHERE id = v_project_id
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no project with such ID';
    ELSE
        UPDATE project SET budget = v_new_budget
        WHERE id = v_project_id;
    END IF;
END//


-- 4. Assign next turn available in an entrance for an employee

CREATE PROCEDURE AssignEntranceShift(
    IN v_employee_id INT,
    IN v_entrance_id INT
)
BEGIN
    DECLARE v_err_code INT;
    DECLARE v_err_msg TEXT;
    DECLARE msg TEXT;
    DECLARE datetime_last_shift DATETIME;
    DECLARE v_begin DATETIME;
    DECLARE v_end DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_err_code = MYSQL_ERRNO,
            v_err_msg = MESSAGE_TEXT;
        SET msg = CONCAT('Error code ', v_err_code, ': ', v_err_msg);
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM entrance 
        WHERE id = v_entrance_id
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no entrance with such ID';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM management_staff
        WHERE id = v_employee_id
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no employee in management staff with such ID';
    ELSE

        SELECT e.end INTO datetime_last_shift
        FROM entrance_shift AS e
        WHERE entrance_id = v_entrance_id
        ORDER BY e.end DESC LIMIT 1;

        SET v_begin = TIMESTAMP(DATE_ADD(DATE(datetime_last_shift), INTERVAL 1 DAY), '08:00:00');
        SET v_end = TIMESTAMP(DATE(v_begin), '16:00:00');
        
        INSERT INTO entrance_shift(employee_id, entrance_id, begin, end)
        VALUES
            (v_employee_id, v_entrance_id, v_begin, v_end);
    END IF;
END //


-- 5. Assign manually a shift for an employee, at a specific entrance in a specific date
CREATE PROCEDURE AssignSpecificEntranceShift(
    IN v_employee_id INT,
    IN v_entrance_id INT,
    IN v_begin_date DATE
)
BEGIN
    DECLARE v_err_code INT;
    DECLARE v_err_msg TEXT;
    DECLARE msg TEXT;
    DECLARE the_begin_datetime DATETIME;
    DECLARE v_end_date DATETIME;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
        v_err_code = MYSQL_ERRNO,
        v_err_msg = MESSAGE_TEXT;
        SET msg = CONCAT('Error code ', v_err_code, ' :', v_err_msg);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = msg;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM management_staff
        WHERE employee_id = v_employee_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no management employee with such ID';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM entrance
        WHERE id = v_entrance_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no entrance with such ID';
    ELSE
        SET the_begin_datetime = TIMESTAMP(v_begin_date, '08:00:00');
        SET v_end_date = TIMESTAMP(v_begin_date, '16:00:00');

        INSERT INTO entrance_shift(employee_id, entrance_id, begin, end)
        VALUES
        (v_employee_id, v_entrance_id, the_begin_datetime, v_end_date);
    END IF;
END//


-- 6. Log a visitor’s entry at an entrance

CREATE PROCEDURE RegisterVisitorAtEntrance(
    IN v_visitor_cedula INT,
    IN v_entrance_id INT
)
BEGIN
    DECLARE v_err_code INT;
    DECLARE v_err_msg TEXT;
    DECLARE msg TEXT;
    DECLARE v_entrance_shift_id INT;
    DECLARE v_current_time DATETIME;
    DECLARE v_visitor_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_err_code = MYSQL_ERRNO,
            v_err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', v_err_code, ': ', v_err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;

    IF NOT EXISTS (
        SELECT 1 FROM visitor
        WHERE cedula = v_visitor_cedula
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no visitor with such cedula';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM entrance
        WHERE id = v_entrance_id
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no entrance with such ID';
    ELSE 
        SET v_current_time = NOW();
        SELECT id INTO v_entrance_shift_id 
        FROM entrance_shift
        WHERE entrance_id = v_entrance_id AND
        v_current_time BETWEEN begin AND end
        LIMIT 1;

        IF (
            v_entrance_shift_id IS NULL
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'There is no active shift at this time for this entrance. Please, register a shift or try later';
        END IF;

        SELECT id INTO v_visitor_id 
        FROM visitor
        WHERE cedula = v_visitor_cedula; 

        INSERT INTO visitor_log(entrance_shift_id, visit_time, visitor_id) VALUES
        (v_entrance_shift_id, v_current_time, v_visitor_id);
    END IF;
END//


-- 7. Add a new area

CREATE PROCEDURE addNewArea(
    IN area_name TEXT,
    IN area_extent FLOAT
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    IF EXISTS (
        SELECT 1 FROM area
        WHERE name = area_name
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An area with tha name already exists';
    ELSE 
        INSERT INTO area(name, extent)
        VALUES
        (area_name, area_extent);
    END IF;
END//


-- 8. Add a new vehicle

CREATE PROCEDURE addNewVehicle(
    IN vehicle_type VARCHAR(30),
    IN vehicle_brand VARCHAR(20)
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Input validation
    IF TRIM(vehicle_type) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle type cannot be empty';
    ELSEIF TRIM(vehicle_brand) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle brand cannot be empty';
    ELSE 
        INSERT INTO vehicle(type, brand)
        VALUES
        (vehicle_type, vehicle_brand);
    END IF;
END//


-- 9. Add a new species

CREATE PROCEDURE addNewSpecies(
    IN species_type ENUM('vegetable', 'animal', 'mineral'),
    IN species_common_name VARCHAR(50),
    IN species_scientific_name VARCHAR(189)
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Input validation
    IF TRIM(species_common_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Common name cannot be empty';
    ELSEIF TRIM(species_scientific_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Scientific name cannot be empty';
    ELSEIF species_type NOT IN ('vegetable', 'animal', 'mineral') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Type must be one of: vegetable, animal, mineral';
    ELSEIF EXISTS (
        SELECT 1 FROM species
        WHERE common_name = species_common_name
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A species with that common name already exists';
    ELSEIF EXISTS (
        SELECT 1 FROM species
        WHERE scientific_name = species_scientific_name
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A species with that scientific name already exists';
    ELSE 
        INSERT INTO species(type, common_name, scientific_name)
        VALUES
        (species_type, species_common_name, species_scientific_name);
    END IF;
END//


-- 10. Add a new project


CREATE PROCEDURE addNewProject(
    IN project_name VARCHAR(100),
    IN project_budget DECIMAL(15,2),
    IN project_start_date DATE,
    IN project_end_date DATE
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Input validation
    IF TRIM(project_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Project name cannot be empty';
    ELSEIF project_budget <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Project budget must be greater than zero';
    ELSEIF project_end_date <= project_start_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'End date must be after start date';
    ELSEIF EXISTS (
        SELECT 1 FROM project
        WHERE name = project_name
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A project with that name already exists';
    ELSE 
        INSERT INTO project(name, budget, start_date, end_date)
        VALUES
        (project_name, project_budget, project_start_date, project_end_date);
    END IF;
END//


-- 11. Add a new employee

CREATE PROCEDURE addNewEmployee(
    IN employee_cedula BIGINT,
    IN employee_name VARCHAR(80),
    IN employee_address VARCHAR(150),
    IN employee_mobile_phone INT UNSIGNED,
    IN employee_salary DECIMAL(10,2),
    IN employee_role_type ENUM('Management', 'Vigilance', 'Conservation', 'Research')
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Input validation
    IF employee_cedula <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cedula must be greater than zero';
    ELSEIF TRIM(employee_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee name cannot be empty';
    ELSEIF TRIM(employee_address) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee address cannot be empty';
    ELSEIF employee_mobile_phone < 1000000000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mobile phone number must be at least 10 digits';
    ELSEIF employee_salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    ELSEIF employee_role_type NOT IN ('Management', 'Vigilance', 'Conservation', 'Research') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Role type must be one of: Management, Vigilance, Conservation, Research';
    ELSEIF EXISTS (
        SELECT 1 FROM employee
        WHERE cedula = employee_cedula
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An employee with that cedula already exists';
    ELSE 
        INSERT INTO employee(cedula, name, address, mobile_phone, salary, role_type)
        VALUES
        (employee_cedula, employee_name, employee_address, employee_mobile_phone, employee_salary, employee_role_type);
    END IF;
END//


-- 12. Add a new lodging

CREATE PROCEDURE addNewLodging(
    IN lodging_park_id INT UNSIGNED,
    IN lodging_name VARCHAR(50),
    IN lodging_capacity INT,
    IN lodging_category VARCHAR(30)
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Input validation
    IF NOT EXISTS (
        SELECT 1 FROM park
        WHERE id = lodging_park_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Referenced park does not exist';
    ELSEIF TRIM(lodging_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lodging name cannot be empty';
    ELSEIF lodging_capacity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Capacity must be greater than zero';
    ELSEIF TRIM(lodging_category) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Category cannot be empty';
    ELSEIF EXISTS (
        SELECT 1 FROM lodging
        WHERE park_id = lodging_park_id AND name = lodging_name
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A lodging with that name already exists in this park';
    ELSE 
        INSERT INTO lodging(park_id, name, capacity, category)
        VALUES
        (lodging_park_id, lodging_name, lodging_capacity, lodging_category);
    END IF;
END//


-- 13. Mark a species as extint, add it to a log table and delete it from the main table

CREATE PROCEDURE markSpeciesAsExtinct(
    IN species_id INT UNSIGNED
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;
    DECLARE species_type_val ENUM('vegetable', 'animal', 'mineral');
    DECLARE common_name_val VARCHAR(50);
    DECLARE scientific_name_val VARCHAR(189);
    DECLARE extinct_date DATE;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Create extinct_species table if it doesn't exist
    CREATE TABLE IF NOT EXISTS extinct_species (
        id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        original_id INT UNSIGNED,
        type ENUM('vegetable', 'animal', 'mineral') NOT NULL,
        common_name VARCHAR(50) NOT NULL,
        scientific_name VARCHAR(189) NOT NULL,
        extinction_date DATE NOT NULL
    );
    
    -- Check if the species exists
    IF NOT EXISTS (
        SELECT 1 FROM species
        WHERE id = species_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified species does not exist';
    ELSE
        -- Get species information
        SELECT type, common_name, scientific_name 
        INTO species_type_val, common_name_val, scientific_name_val
        FROM species
        WHERE id = species_id;
        
        SET extinct_date = CURRENT_DATE();
        
        -- Insert into extinct_species table
        INSERT INTO extinct_species(original_id, type, common_name, scientific_name, extinction_date)
        VALUES(species_id, species_type_val, common_name_val, scientific_name_val, extinct_date);
        
        -- Delete from species table
        DELETE FROM species
        WHERE id = species_id;
        
        SELECT CONCAT('Species "', common_name_val, '" (', scientific_name_val, ') marked as extinct and moved to extinct_species table') AS result;
    END IF;
END//


-- 14. Tracks employee when leaving, add it to a log table and delete it from the main table

CREATE PROCEDURE markEmployeeAsFormer(
    IN employee_id INT UNSIGNED,
    IN departure_reason VARCHAR(100)
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;
    DECLARE employee_cedula_val BIGINT;
    DECLARE employee_name_val VARCHAR(80);
    DECLARE employee_address_val VARCHAR(150);
    DECLARE employee_mobile_phone_val INT UNSIGNED;
    DECLARE employee_salary_val DECIMAL(10,2);
    DECLARE employee_role_type_val ENUM('Management', 'Vigilance', 'Conservation', 'Research');
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Create former_employee table if it doesn't exist
    CREATE TABLE IF NOT EXISTS former_employee (
        id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        original_id INT UNSIGNED,
        cedula BIGINT NOT NULL,
        name VARCHAR(80) NOT NULL,
        address VARCHAR(150) NOT NULL,
        mobile_phone INT UNSIGNED NOT NULL,
        salary DECIMAL(10,2) NOT NULL,
        role_type ENUM('Management', 'Vigilance', 'Conservation', 'Research') NOT NULL,
        departure_date DATE NOT NULL,
        departure_reason VARCHAR(100) NOT NULL
    );
    
    -- Input validation
    IF TRIM(departure_reason) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Departure reason cannot be empty';
    END IF;
    
    -- Check if the employee exists
    IF NOT EXISTS (
        SELECT 1 FROM employee
        WHERE id = employee_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified employee does not exist';
    ELSE
        -- Get employee information
        SELECT cedula, name, address, mobile_phone, salary, role_type
        INTO employee_cedula_val, employee_name_val, employee_address_val, 
             employee_mobile_phone_val, employee_salary_val, employee_role_type_val
        FROM employee
        WHERE id = employee_id;
        
        -- Insert into former_employee table
        INSERT INTO former_employee(
            original_id, cedula, name, address, mobile_phone, 
            salary, role_type, departure_date, departure_reason
        )
        VALUES(
            employee_id, employee_cedula_val, employee_name_val, 
            employee_address_val, employee_mobile_phone_val, 
            employee_salary_val, employee_role_type_val, 
            CURRENT_DATE(), departure_reason
        );
        
        -- Delete from employee table
        DELETE FROM employee
        WHERE id = employee_id;
        
        SELECT CONCAT('Employee "', employee_name_val, '" (ID: ', employee_id, ') marked as former employee and moved to former_employee table') AS result;
    END IF;
END//


-- 15. Create a log table for project and track cancelled and completed ones

CREATE PROCEDURE markProjectAsFinished(
    IN project_id INT UNSIGNED,
    IN status_reason VARCHAR(200),
    IN is_completed BOOLEAN
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;
    DECLARE project_name_val VARCHAR(100);
    DECLARE project_budget_val DECIMAL(15,2);
    DECLARE project_start_date_val DATE;
    DECLARE project_end_date_val DATE;
    DECLARE deliver_date_val DATE;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Create finished_project table if it doesn't exist
    CREATE TABLE IF NOT EXISTS finished_project (
        id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        original_id INT UNSIGNED,
        name VARCHAR(100) NOT NULL,
        budget DECIMAL(15,2) NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        deliver_date DATE,
        status ENUM('completed', 'canceled') NOT NULL,
        status_reason VARCHAR(200) NOT NULL,
        finish_date DATE NOT NULL
    );
    
    -- Input validation
    IF TRIM(status_reason) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status reason cannot be empty';
    END IF;
    
    -- Check if the project exists
    IF NOT EXISTS (
        SELECT 1 FROM project
        WHERE id = project_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified project does not exist';
    ELSE
        -- Get project information
        SELECT name, budget, start_date, end_date
        INTO project_name_val, project_budget_val, project_start_date_val, project_end_date_val
        FROM project
        WHERE id = project_id;
        
        -- Set deliver_date based on completion status
        IF is_completed = TRUE THEN
            SET deliver_date_val = CURRENT_DATE();
        ELSE
            SET deliver_date_val = NULL;
        END IF;
        
        -- Insert into finished_project table
        INSERT INTO finished_project(
            original_id, name, budget, start_date, end_date, 
            deliver_date, status, status_reason, finish_date
        )
        VALUES(
            project_id, project_name_val, project_budget_val, 
            project_start_date_val, project_end_date_val, 
            deliver_date_val, 
            CASE WHEN is_completed = TRUE THEN 'completed' ELSE 'canceled' END,
            status_reason, CURRENT_DATE()
        );
        
        -- Delete from project table
        DELETE FROM project
        WHERE id = project_id;
        
        SELECT CONCAT(
            'Project "', project_name_val, '" (ID: ', project_id, ') marked as ', 
            CASE WHEN is_completed = TRUE THEN 'completed' ELSE 'canceled' END,
            ' and moved to finished_project table'
        ) AS result;
    END IF;
END//


-- 16. Add species to area

CREATE PROCEDURE addSpeciesToArea(
    IN p_area_id INT UNSIGNED,
    IN p_species_id INT UNSIGNED,
    IN p_population INT UNSIGNED
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Input validation
    IF NOT EXISTS (
        SELECT 1 FROM area
        WHERE id = p_area_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified area does not exist';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM species
        WHERE id = p_species_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified species does not exist';
    ELSEIF p_population < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Population must be a non-negative number';
    ELSEIF EXISTS (
        SELECT 1 FROM area_species
        WHERE area_id = p_area_id AND species_id = p_species_id
    ) THEN
        -- Update existing population instead of inserting a duplicate
        UPDATE area_species
        SET population = p_population
        WHERE area_id = p_area_id AND species_id = p_species_id;
        
        SELECT 'Species population in this area has been updated' AS result;
    ELSE 
        -- Insert new area-species relationship
        INSERT INTO area_species(area_id, species_id, population)
        VALUES(p_area_id, p_species_id, p_population);
        
        SELECT 'Species has been added to the area' AS result;
    END IF;
END//


-- 17. Assign park to department

CREATE PROCEDURE assignParkToDepartment(
    IN p_department_id INT UNSIGNED,
    IN p_park_id INT UNSIGNED
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Input validation
    IF NOT EXISTS (
        SELECT 1 FROM department
        WHERE id = p_department_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified department does not exist';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM park
        WHERE id = p_park_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified park does not exist';
    ELSEIF EXISTS (
        SELECT 1 FROM department_park
        WHERE department_id = p_department_id AND park_id = p_park_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This park is already assigned to this department';
    ELSE 
        -- Insert new department-park relationship
        INSERT INTO department_park(department_id, park_id)
        VALUES(p_department_id, p_park_id);
        
        SELECT 'Park has been assigned to the department' AS result;
    END IF;
END//


-- 18. Assign area to park


CREATE PROCEDURE assignAreaToPark(
    IN p_park_id INT UNSIGNED,
    IN p_area_id INT UNSIGNED
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Input validation
    IF NOT EXISTS (
        SELECT 1 FROM park
        WHERE id = p_park_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified park does not exist';
    ELSEIF NOT EXISTS (
        SELECT 1 FROM area
        WHERE id = p_area_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified area does not exist';
    ELSEIF EXISTS (
        SELECT 1 FROM park_area
        WHERE park_id = p_park_id AND area_id = p_area_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This area is already assigned to this park';
    ELSE 
        -- Insert new park-area relationship
        INSERT INTO park_area(park_id, area_id)
        VALUES(p_park_id, p_area_id);
        
        SELECT 'Area has been assigned to the park' AS result;
    END IF;
END//


-- 19. Current visitors report procedure

CREATE PROCEDURE generateCurrentVisitorsReport(
    IN p_lodging_id INT UNSIGNED
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Check if lodging exists
    IF p_lodging_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM lodging
        WHERE id = p_lodging_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified lodging does not exist';
    END IF;
    
    -- Generate report for specific lodging if provided, otherwise for all lodgings
    IF p_lodging_id IS NOT NULL THEN
        SELECT 
            l.id AS lodging_id,
            l.name AS lodging_name,
            l.capacity AS total_capacity,
            COUNT(vs.id) AS current_visitors,
            l.capacity - COUNT(vs.id) AS available_capacity,
            ROUND((COUNT(vs.id) / l.capacity) * 100, 2) AS occupancy_percentage
        FROM 
            lodging l
        LEFT JOIN 
            visitor_stay vs ON l.id = vs.lodging_id
            AND vs.check_in <= NOW() 
            AND vs.check_out > NOW()
        WHERE 
            l.id = p_lodging_id
        GROUP BY 
            l.id, l.name, l.capacity;
    ELSE
        SELECT 
            l.id AS lodging_id,
            l.name AS lodging_name,
            l.capacity AS total_capacity,
            COUNT(vs.id) AS current_visitors,
            l.capacity - COUNT(vs.id) AS available_capacity,
            ROUND((COUNT(vs.id) / l.capacity) * 100, 2) AS occupancy_percentage
        FROM 
            lodging l
        LEFT JOIN 
            visitor_stay vs ON l.id = vs.lodging_id
            AND vs.check_in <= NOW() 
            AND vs.check_out > NOW()
        GROUP BY 
            l.id, l.name, l.capacity
        ORDER BY 
            occupancy_percentage DESC;
    END IF;
END//


-- 20. Change project deadline procedure

CREATE PROCEDURE changeProjectDeadline(
    IN p_project_id INT UNSIGNED,
    IN p_new_end_date DATE,
    IN p_reason VARCHAR(200)
)
BEGIN
    DECLARE err_code INT;
    DECLARE err_msg TEXT;
    DECLARE msg TEXT;
    DECLARE current_start_date DATE;
    DECLARE current_end_date DATE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            err_code = MYSQL_ERRNO,
            err_msg = MESSAGE_TEXT;
            SET msg = CONCAT('Error code ', err_code, ': ', err_msg);
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = msg;
    END;
    
    -- Create project_deadline_change table if it doesn't exist
    CREATE TABLE IF NOT EXISTS project_deadline_change (
        id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
        project_id INT UNSIGNED NOT NULL,
        old_end_date DATE NOT NULL,
        new_end_date DATE NOT NULL,
        change_date DATETIME NOT NULL,
        reason VARCHAR(200) NOT NULL,
        FOREIGN KEY(project_id) REFERENCES project(id) ON DELETE CASCADE
    );
    
    -- Input validation
    IF NOT EXISTS (
        SELECT 1 FROM project
        WHERE id = p_project_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The specified project does not exist';
    ELSEIF p_new_end_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'New end date cannot be NULL';
    ELSEIF TRIM(p_reason) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reason for deadline change cannot be empty';
    ELSE
        -- Get current project dates
        SELECT start_date, end_date 
        INTO current_start_date, current_end_date
        FROM project
        WHERE id = p_project_id;
        
        -- Validate new end date is after start date
        IF p_new_end_date <= current_start_date THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'New end date must be after the project start date';
        ELSE
            -- Log the change
            INSERT INTO project_deadline_change(
                project_id, old_end_date, new_end_date, change_date, reason
            )
            VALUES(
                p_project_id, current_end_date, p_new_end_date, NOW(), p_reason
            );
            
            -- Update the project end date
            UPDATE project
            SET end_date = p_new_end_date
            WHERE id = p_project_id;
            
            SELECT CONCAT(
                'Project deadline changed from ', 
                DATE_FORMAT(current_end_date, '%Y-%m-%d'), 
                ' to ', 
                DATE_FORMAT(p_new_end_date, '%Y-%m-%d')
            ) AS result;
        END IF;
    END IF;
END//

DELIMITER ;