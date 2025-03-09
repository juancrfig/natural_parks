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
        SELECT 1 FROM employee
        WHERE id = v_employee_id
    ) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is no employee with such ID';
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


-- 5. Log a visitor’s entry at an entrance

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




DELIMITER ;