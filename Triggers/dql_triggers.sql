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