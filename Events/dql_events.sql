-- Ensure the event scheduler is enabled
SET GLOBAL event_scheduler = 'ON';

-- Use the natural_parks database
USE natural_parks;

DELIMITER //

-- Event 1: Daily Backup of Employee Data
-- Copies employee data to a backup table every month
CREATE EVENT daily_employee_backup
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO employee_backup (employee_id, cedula, name, address, mobile_phone, salary, role_type, backup_date)
    SELECT id, cedula, name, address, mobile_phone, salary, role_type, CURDATE()
    FROM employee;
END//

-- Event 2: Weekly Species Population Snapshot
-- Logs current species populations weekly into species_population_log
DELIMITER //
CREATE EVENT weekly_species_population_snapshot
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO species_population_log (species_id, area_id, population, change_date)
    SELECT species_id, area_id, population, CURDATE()
    FROM area_species;
END//
DELIMITER ;

-- Event 3: Monthly Visitor Summary
-- Calculates and logs the total visitors from the previous month
DELIMITER //
CREATE EVENT monthly_visitor_summary
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DECLARE last_month_year INT;
    DECLARE last_month_month INT;
    DECLARE total INT;

    SET last_month_year = YEAR(CURDATE() - INTERVAL 1 MONTH);
    SET last_month_month = MONTH(CURDATE() - INTERVAL 1 MONTH);

    SELECT COUNT(*) INTO total
    FROM visitor_log
    WHERE YEAR(visit_time) = last_month_year AND MONTH(visit_time) = last_month_month;

    INSERT INTO visitor_monthly_summary (year, month, total_visitors, summary_date)
    VALUES (last_month_year, last_month_month, total, CURDATE());
END//
DELIMITER ;

-- Event 4: Yearly Salary Increase
-- Increases all employee salaries by 5% annually
DELIMITER //
CREATE EVENT yearly_salary_increase
ON SCHEDULE EVERY 1 YEAR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE employee
    SET salary = salary * 1.05;
END//
DELIMITER ;

-- Event 5: Daily Low Population Alert
-- Checks for species populations below 100 and logs alerts daily
DELIMITER //
CREATE EVENT daily_low_population_alert
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO species_alert (species_id, area_id, population, alert_date)
    SELECT species_id, area_id, population, CURDATE()
    FROM area_species
    WHERE population < 100;
END//
DELIMITER ;

-- Event 6: Weekly Cleanup of Old Visitor Logs
-- Deletes visitor logs older than 1 year every week
DELIMITER //
CREATE EVENT weekly_cleanup_old_visitor_logs
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM visitor_log
    WHERE visit_time < CURDATE() - INTERVAL 1 YEAR;
END//
DELIMITER ;

-- Event 7: Monthly Department Report Generation
-- Logs the number of parks per department monthly
DELIMITER //
CREATE EVENT monthly_department_report
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO department_report (department_id, total_parks, total_employees, report_date)
    SELECT d.id, COUNT(dp.park_id), 0, CURDATE()
    FROM department d
    LEFT JOIN department_park dp ON d.id = dp.department_id
    GROUP BY d.id;
END//
DELIMITER ;

-- Event 8: Yearly Archiving of Old Projects
-- Archives projects ended over a year ago and removes them from project table
DELIMITER //
CREATE EVENT yearly_archive_old_projects
ON SCHEDULE EVERY 1 YEAR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO project_archive (id, name, budget, start_date, end_date, archive_date)
    SELECT id, name, budget, start_date, end_date, CURDATE()
    FROM project
    WHERE end_date < CURDATE() - INTERVAL 1 YEAR;

    DELETE FROM project
    WHERE end_date < CURDATE() - INTERVAL 1 YEAR;
END//
DELIMITER ;

-- Event 9: Monthly Cleanup of Old Entrance Shifts
-- Deletes entrance shifts ended over a year ago
DELIMITER //
CREATE EVENT monthly_cleanup_old_entrance_shifts
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM entrance_shift
    WHERE end < CURDATE() - INTERVAL 1 YEAR;
END//
DELIMITER ;

-- Event 10: Monthly Cleanup of Old Salary Logs
-- Deletes salary logs older than 5 years
DELIMITER //
CREATE EVENT monthly_cleanup_old_salary_logs
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM salaryLogs
    WHERE change_date < CURDATE() - INTERVAL 5 YEAR;
END//
DELIMITER ;

-- Event 11: Weekly Insert New Area
-- Adds a new area with dummy data weekly (for demonstration)
DELIMITER //
CREATE EVENT weekly_insert_new_area
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO area (name, extent)
    VALUES ('New Area', 100.0);
END//
DELIMITER ;

-- Event 12: Daily Increase of Species Populations
-- Increases all species populations by 10 daily (for demonstration)
DELIMITER //
CREATE EVENT daily_increase_species_populations
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE area_species
    SET population = population + 10;
END//
DELIMITER ;

-- Event 13: Weekly Delete Inactive Visitors
-- Deletes visitors with no activity in the last 5 years
DELIMITER //
CREATE EVENT weekly_delete_inactive_visitors
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM visitor
    WHERE id NOT IN (
        SELECT visitor_id
        FROM visitor_log
        WHERE visit_time >= CURDATE() - INTERVAL 5 YEAR
    ) AND id NOT IN (
        SELECT visitor_id
        FROM visitor_stay
        WHERE check_out >= CURDATE() - INTERVAL 5 YEAR
    );
END//
DELIMITER ;

-- Event 14: Monthly Budget Reduction
-- Reduces project budgets by 1000 monthly (if above 1000)
DELIMITER //
CREATE EVENT monthly_budget_reduction
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE project
    SET budget = budget - 1000
    WHERE budget > 1000;
END//
DELIMITER ;

-- Event 15: Weekly Increase Lodging Capacities
-- Increases lodging capacities by 10% weekly (for demonstration)
DELIMITER //
CREATE EVENT weekly_increase_lodging_capacities
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE lodging
    SET capacity = capacity * 1.10;
END//
DELIMITER ;

-- Event 16: Monthly Delete Old Species Alerts
-- Deletes species alerts older than 1 year
DELIMITER //
CREATE EVENT monthly_delete_old_species_alerts
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM species_alert
    WHERE alert_date < CURDATE() - INTERVAL 1 YEAR;
END//
DELIMITER ;

-- Event 17: Yearly Salary Increase for Senior Employees
-- Increases salaries by 10% for employees hired over 5 years ago
DELIMITER //
CREATE EVENT yearly_salary_increase_for_senior_employees
ON SCHEDULE EVERY 1 YEAR
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE employee e
    JOIN employee_hire_log h ON e.id = h.employee_id
    SET e.salary = e.salary * 1.10
    WHERE h.hire_date < CURDATE() - INTERVAL 5 YEAR;
END//
DELIMITER ;

-- Event 18: Daily Insert New Visitor
-- Adds a new visitor with dummy data daily (for demonstration)
DELIMITER //
CREATE EVENT daily_insert_new_visitor
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO visitor (cedula, name, address, job)
    VALUES (FLOOR(RAND() * 10000000000), 'New Visitor', 'Some Address', 'Some Job');
END//
DELIMITER ;

-- Event 19: Weekly Update of Park Names
-- Appends '_updated' to park names weekly (for demonstration)
DELIMITER //
CREATE EVENT weekly_update_park_names
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE park
    SET name = CONCAT(name, '_updated');
END//
DELIMITER ;

-- Event 20: Monthly Delete Old Visitor Stays
-- Deletes visitor stays that ended over 2 years ago
DELIMITER //
CREATE EVENT monthly_delete_old_visitor_stays
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM visitor_stay
    WHERE check_out < CURDATE() - INTERVAL 2 YEAR;
END//
DELIMITER ;