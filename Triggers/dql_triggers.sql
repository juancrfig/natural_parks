DELIMITER //

-- 1. Log employee salary changes in a table for future audit

CREATE TRIGGER LogSalaryChanges
AFTER UPDATE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO salaryLogs(employee_id, from_salary, to_salary, change_date)
    VALUES
    (old.id, old.salary, new.salary, NOW());
END//


-- 2. Update species population log when inserting new data

CREATE TRIGGER LogPopulationChange
BEFORE INSERT ON area_species
FOR EACH ROW
BEGIN
    INSERT INTO species_population_log
    (area_id, species_id, population, change_date)
    VALUES
    (new.area_id, new.species_id, new.population, NOW());
END //


-- 3. Update species population log when updating date

CREATE TRIGGER LogPopulationChange
BEFORE UPDATE ON area_species
FOR EACH ROW
BEGIN
    INSERT INTO species_population_log
    (area_id, species_id, population, change_date)
    VALUES
    (new.area_id, new.species_id, new.population, NOW());
END //


-- 4. Ensure unique entrance numbers per park

CREATE TRIGGER checkEntranceUniqueness
BEFORE INSERT ON entrance
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM entrance
        WHERE park_id = new.park_id AND
        entrance_number = new.entrance_number
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'There is already an entrance with that number in this park';
    END IF;
END//


-- 5. Logs changes to an employee's role for HR tracking

CREATE TRIGGER trg_employee_role_change
AFTER UPDATE ON employee
FOR EACH ROW
BEGIN
    IF OLD.role_type != OLD.role_type THEN
        INSERT INTO employee_role_changes (employee_id, old_role, new_role, change_date)
        VALUES (OLD.employee_id, OLD.role_type, NEW.role_type, NOW());
    END IF;
END//


-- 6. Prevents updates to a project's budget if it exceeds a threshold

CREATE TRIGGER trg_project_budget_limit
BEFORE UPDATE ON project
FOR EACH ROW
BEGIN
    IF NEW.budget > 1000000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Budget cannot exceed 1,000,000';
    END IF;
END//


-- 7. Alerts when a species' population drops below a critical level

CREATE TRIGGER trg_species_population_alert
AFTER UPDATE ON area_species
FOR EACH ROW
BEGIN
    IF NEW.population < 10 THEN
        INSERT INTO species_alert (species_id, area_id, population, alert_date)
        VALUES (NEW.species_id, NEW.area_id, NEW.population, NOW());
    END IF;
END//


-- 8. Prevents lodging overbooking based on capacity

CREATE TRIGGER trg_prevent_overbooking
BEFORE INSERT ON visitor_stay
FOR EACH ROW
BEGIN
    DECLARE current_bookings INT;
    SELECT COUNT(*) INTO current_bookings
    FROM visitor_stay vs
    JOIN lodging l ON vs.lodging_id = l.lodging_id
    WHERE vs.lodging_id = NEW.lodging_id
    AND (NEW.check_in < vs.check_out AND NEW.check_out > vs.check_in);
    IF current_bookings >= (SELECT capacity FROM lodging WHERE lodging_id = NEW.lodging_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lodging is at full capacity for these dates';
    END IF;
END//


-- 9. Ensures employees aren't scheduled for overlapping shifts

CREATE TRIGGER trg_shift_overlap_prevention
BEFORE INSERT ON entrance_shift
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM entrance_shift
        WHERE employee_id = NEW.employee_id
        AND NEW.begin < end
        AND NEW.end > begin
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Shift overlaps with an existing shift for this employee';
    END IF;
END//


-- 10. Ensures park foundation dates aren't in the future

CREATE TRIGGER trg_park_foundation_date
BEFORE INSERT ON park
FOR EACH ROW
BEGIN
    IF NEW.foundation_date > CURDATE() THEN
        SET NEW.foundation_date = CURDATE();
    END IF;
END//


-- 11. Limits the number of vigilance staff assigned to a vehicle

CREATE TRIGGER trg_vehicle_assignment_limit
BEFORE INSERT ON vigilance_area
FOR EACH ROW
BEGIN
    DECLARE assignment_count INT;
    SELECT COUNT(*) INTO assignment_count
    FROM vigilance_area
    WHERE vehicle_id = NEW.vehicle_id;
    IF assignment_count >= 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle is already assigned to maximum staff';
    END IF;
END//


-- 12. Limits researches to three active projects

CREATE TRIGGER trg_researcher_project_limit
BEFORE INSERT ON project_researcher
FOR EACH ROW
BEGIN
    DECLARE project_count INT;
    SELECT COUNT(*) INTO project_count
    FROM project_researcher
    WHERE researcher_id = NEW.researcher_id;
    IF project_count >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Researcher is already assigned to 3 projects';
    END IF;
END//


-- 13. Prevents changes to a species' type

CREATE TRIGGER trg_species_type_restriction
BEFORE UPDATE ON species
FOR EACH ROW
BEGIN
    IF OLD.type != NEW.type THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Species type cannot be changed';
    END IF;
END//


-- 14. Inserts into project_researcher_species with a default researcher

CREATE TRIGGER trg_auto_researcher_assignment
AFTER INSERT ON species
FOR EACH ROW
BEGIN
    INSERT INTO project_researcher_species (project_id, researcher_id, species_id)
    VALUES (1, 1, NEW.species_id); -- Assuming project_id 1 and researcher_id 1 exist
END//


-- 15. Ensures shifts don't exceed 8 hours

CREATE TRIGGER trg_shift_duration_limit
BEFORE INSERT ON entrance_shift
FOR EACH ROW
BEGIN
    IF TIMESTAMPDIFF(HOUR, NEW.shift_begin, NEW.shift_end) > 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Shift duration cannot exceed 8 hours';
    END IF;
END//


-- 16. Logs changes in department-entity assignments

CREATE TRIGGER trg_department_entity_log
AFTER INSERT ON department_entity
FOR EACH ROW
BEGIN
    INSERT INTO department_entity_log (department_id, entity_id, action, log_date)
    VALUES (NEW.department_id, NEW.entity_id, 'INSERT', NOW());
END//


-- 17. Log new employee hires

CREATE TRIGGER trg_log_new_employee
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    INSERT INTO employee_hire_log (employee_id, hire_date)
    VALUES (NEW.id, NOW());
END//


-- 18. Prevent deletion of projects with assigned researchers

CREATE TRIGGER trg_prevent_project_deletion
BEFORE DELETE ON project
FOR EACH ROW
BEGIN
    DECLARE researcher_count INT;
    SELECT COUNT(*) INTO researcher_count
    FROM project_researcher
    WHERE project_id = OLD.id;
    IF researcher_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete project with assigned researchers';
    END IF;
END//


-- 19. Set default foundation date for new parks

CREATE TRIGGER trg_set_park_foundation_date
BEFORE INSERT ON park
FOR EACH ROW
BEGIN
    IF NEW.foundation_date IS NULL THEN
        SET NEW.foundation_date = CURDATE();
    END IF;
END//


-- 20. Log species population increases


CREATE TRIGGER trg_log_population_increase
AFTER UPDATE ON area_species
FOR EACH ROW
BEGIN
    IF NEW.population > OLD.population THEN
        INSERT INTO species_population_log (species_id, area_id, population, change_date)
        VALUES (NEW.species_id, NEW.area_id, NEW.population, CURDATE());
    END IF;
END//

DELIMITER ;