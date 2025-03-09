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
END //