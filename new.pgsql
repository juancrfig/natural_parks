-- Ensures a clean initial state when running the database creation script
-- In PostgreSQL, you'd typically connect to a default database (like 'postgres') to run this
-- Or run it from a script that handles connections appropriately.

-- Terminate existing connections to allow dropping the database
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'natural_parks' AND pid <> pg_backend_pid();

DROP DATABASE IF EXISTS natural_parks;

-- Sets the character encoding to UTF-8 to support special characters and emojis
-- TEMPLATE template0 ensures a clean database without any objects copied from template1
CREATE DATABASE natural_parks
    ENCODING 'UTF8'
    LC_COLLATE = 'en_US.UTF-8' -- Or your preferred locale
    LC_CTYPE = 'en_US.UTF-8'   -- Or your preferred locale
    TEMPLATE template0;

-- After creating the database, you need to connect to it.
-- In psql, you would use: \c natural_parks
-- The following DDL assumes you are connected to the 'natural_parks' database.

-- Create ENUM types first
CREATE TYPE species_enum_type AS ENUM ('vegetable', 'animal', 'mineral');
CREATE TYPE employee_role_enum_type AS ENUM ('Management', 'Vigilance', 'Conservation', 'Research');
CREATE TYPE conservation_specialty_enum_type AS ENUM ('Cleaning', 'Maintenance of Roads');


CREATE TABLE area (
    id SERIAL PRIMARY KEY, -- SERIAL is an auto-incrementing integer
    name VARCHAR(50) NOT NULL CHECK(TRIM(name) != ''),
    extent REAL NOT NULL CHECK(extent > 0) -- REAL is single-precision float
);

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    type species_enum_type NOT NULL,
    common_name VARCHAR(50) UNIQUE NOT NULL CHECK(TRIM(common_name) != ''),
    scientific_name VARCHAR(189) UNIQUE NOT NULL CHECK(TRIM(scientific_name) != '')
);

CREATE TABLE area_species (
    area_id INTEGER NOT NULL,
    species_id INTEGER NOT NULL,
    population INTEGER NOT NULL CHECK (population >= 0), -- Replaces INT UNSIGNED
    PRIMARY KEY (area_id, species_id), -- Added primary key for clarity, assuming it's a composite PK
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE,
    FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE
);

CREATE TABLE project (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE CHECK(TRIM(name) != ''),
    budget DECIMAL(15,2) NOT NULL CHECK(budget > 0),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CHECK(end_date > start_date)
);

CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    cedula BIGINT NOT NULL UNIQUE CHECK(cedula > 0),
    name VARCHAR(80) NOT NULL CHECK(TRIM(name) != ''),
    address VARCHAR(150) NOT NULL CHECK(TRIM(address) != ''),
    -- mobile_phone INT UNSIGNED NOT NULL CHECK(mobile_phone >= 1000000000),
    -- PostgreSQL INTEGER max is ~2.1 billion. Phone numbers are often stored as VARCHAR
    -- or BIGINT if arithmetic is never needed but numeric checks are.
    -- Using BIGINT as original was INT UNSIGNED with a large value check.
    mobile_phone BIGINT NOT NULL CHECK(mobile_phone >= 1000000000 AND mobile_phone <= 9999999999), -- Example range
    salary DECIMAL(10,2) NOT NULL CHECK(salary > 0),
    role_type employee_role_enum_type NOT NULL
);

CREATE TABLE vigilance_staff (
    employee_id INTEGER PRIMARY KEY, -- No NOT NULL needed for PRIMARY KEY
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE management_staff (
    employee_id INTEGER PRIMARY KEY,
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE conservation_staff (
    employee_id INTEGER PRIMARY KEY,
    specialty conservation_specialty_enum_type NOT NULL,
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE research_staff (
    employee_id INTEGER PRIMARY KEY,
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE project_researcher (
    project_id INTEGER NOT NULL,
    researcher_id INTEGER NOT NULL,
    PRIMARY KEY(project_id, researcher_id),
    FOREIGN KEY(project_id) REFERENCES project(id) ON DELETE CASCADE,
    FOREIGN KEY(researcher_id) REFERENCES research_staff(employee_id) ON DELETE CASCADE
);

CREATE TABLE project_researcher_species (
    project_id INTEGER NOT NULL,
    researcher_id INTEGER NOT NULL,
    species_id INTEGER NOT NULL,
    PRIMARY KEY(project_id, researcher_id, species_id),
    FOREIGN KEY(project_id) REFERENCES project(id) ON DELETE CASCADE,
    FOREIGN KEY(researcher_id) REFERENCES research_staff(employee_id) ON DELETE CASCADE,
    FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE
);

CREATE TABLE park (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE CHECK(TRIM(name) != ''),
    foundation_date DATE NOT NULL
);

CREATE TABLE entrance (
    id SERIAL PRIMARY KEY,
    park_id INTEGER NOT NULL,
    entrance_number INTEGER NOT NULL CHECK (entrance_number >= 0),
    FOREIGN KEY(park_id) REFERENCES park(id) ON DELETE CASCADE
);

CREATE TABLE department (
    id SERIAL PRIMARY KEY,
    name VARCHAR(25) NOT NULL UNIQUE CHECK(TRIM(name) != '')
);

CREATE TABLE department_park (
    department_id INTEGER NOT NULL,
    park_id INTEGER NOT NULL,
    PRIMARY KEY (department_id, park_id),
    FOREIGN KEY (department_id) REFERENCES department(id) ON DELETE CASCADE, -- Added ON DELETE CASCADE for consistency
    FOREIGN KEY (park_id) REFERENCES park(id) ON DELETE CASCADE -- Added ON DELETE CASCADE for consistency
);

CREATE TABLE park_area (
    park_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL,
    PRIMARY KEY(park_id, area_id),
    FOREIGN KEY(park_id) REFERENCES park(id) ON DELETE CASCADE,
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE
);

CREATE TABLE vehicle (
    id SERIAL PRIMARY KEY,
    type VARCHAR(30) NOT NULL CHECK(TRIM(type) != ''),
    brand VARCHAR(20) NOT NULL CHECK(TRIM(brand) != '')
);

CREATE TABLE vigilance_area (
    vigilance_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL,
    vehicle_id INTEGER NOT NULL,
    PRIMARY KEY(vigilance_id, area_id),
    FOREIGN KEY(vigilance_id) REFERENCES vigilance_staff(employee_id) ON DELETE CASCADE,
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE,
    FOREIGN KEY(vehicle_id) REFERENCES vehicle(id) ON DELETE CASCADE -- Assuming vehicle can be deleted independently
);

CREATE TABLE conservation_area (
    conservation_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL,
    PRIMARY KEY(conservation_id, area_id),
    FOREIGN KEY(conservation_id) REFERENCES conservation_staff(employee_id) ON DELETE CASCADE,
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE
);

CREATE TABLE entrance_shift (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    entrance_id INTEGER NOT NULL,
    -- Renamed 'begin' and 'end' as they are SQL keywords
    begin_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    end_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CHECK (end_time > begin_time),
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE, -- Added ON DELETE CASCADE
    FOREIGN KEY(entrance_id) REFERENCES entrance(id) ON DELETE CASCADE -- Added ON DELETE CASCADE
);

CREATE TABLE visitor (
    id SERIAL PRIMARY KEY,
    cedula BIGINT NOT NULL UNIQUE CHECK(cedula > 0),
    name VARCHAR(80) NOT NULL CHECK(TRIM(name) != ''),
    address VARCHAR(150) NOT NULL CHECK(TRIM(address) != ''),
    job VARCHAR(60) NOT NULL CHECK(TRIM(job) != '')
);

CREATE TABLE lodging (
    id SERIAL PRIMARY KEY,
    park_id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL CHECK(TRIM(name) != ''),
    capacity INTEGER NOT NULL CHECK(capacity > 0),
    category VARCHAR(30) NOT NULL CHECK(TRIM(category) != ''),
    FOREIGN KEY(park_id) REFERENCES park(id) ON DELETE CASCADE
);

CREATE TABLE visitor_stay (
    id SERIAL PRIMARY KEY,
    visitor_id INTEGER NOT NULL,
    lodging_id INTEGER NOT NULL,
    check_in TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    check_out TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CHECK(check_out > check_in),
    FOREIGN KEY(visitor_id) REFERENCES visitor(id) ON DELETE CASCADE,
    FOREIGN KEY(lodging_id) REFERENCES lodging(id) ON DELETE CASCADE
);

CREATE TABLE visitor_log (
    id SERIAL PRIMARY KEY,
    entrance_shift_id INTEGER NOT NULL,
    visit_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    visitor_id INTEGER NOT NULL,
    FOREIGN KEY(entrance_shift_id) REFERENCES entrance_shift(id) ON DELETE CASCADE,
    FOREIGN KEY(visitor_id) REFERENCES visitor(id) ON DELETE CASCADE
);

CREATE TABLE responsible_entity (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL CHECK(TRIM(name) != '')
);

CREATE TABLE department_entity (
    department_id INTEGER NOT NULL,
    entity_id INTEGER NOT NULL,
    PRIMARY KEY(department_id, entity_id),
    FOREIGN KEY(department_id) REFERENCES department(id) ON DELETE CASCADE,
    FOREIGN KEY(entity_id) REFERENCES responsible_entity(id) ON DELETE CASCADE
);


-- Creation of tables used in triggers and events
CREATE TABLE salary_logs ( -- Renamed from salaryLogs for PostgreSQL naming convention
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    from_salary DECIMAL(10,2) NOT NULL CHECK(from_salary > 0),
    to_salary DECIMAL(10,2) NOT NULL CHECK(to_salary > 0),
    change_date DATE NOT NULL,
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE SET NULL -- Or ON DELETE CASCADE, depends on requirements
);

CREATE TABLE species_population_log (
    id SERIAL PRIMARY KEY,
    species_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL,
    population INTEGER NOT NULL CHECK (population >= 0),
    change_date DATE NOT NULL,
    FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE, -- Added ON DELETE
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE     -- Added ON DELETE
);

CREATE TABLE employee_role_changes (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    old_role employee_role_enum_type NOT NULL,
    new_role employee_role_enum_type NOT NULL,
    change_date DATE NOT NULL,
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE -- Added ON DELETE
);

CREATE TABLE species_alert (
    id SERIAL PRIMARY KEY,
    species_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL,
    population INTEGER NOT NULL CHECK (population >= 0),
    alert_date DATE NOT NULL,
    FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE, -- Added ON DELETE
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE     -- Added ON DELETE
);

CREATE TABLE department_entity_log (
    id SERIAL PRIMARY KEY,
    department_id INTEGER NOT NULL,
    entity_id INTEGER NOT NULL,
    action VARCHAR(15) NOT NULL CHECK(TRIM(action) != ''),
    log_date DATE NOT NULL,
    FOREIGN KEY(department_id) REFERENCES department(id) ON DELETE CASCADE, -- Added ON DELETE
    FOREIGN KEY(entity_id) REFERENCES responsible_entity(id) ON DELETE CASCADE -- Added ON DELETE
);

CREATE TABLE employee_hire_log (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    hire_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE employee_backup (
    backup_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    cedula BIGINT NOT NULL,
    name VARCHAR(80) NOT NULL,
    address VARCHAR(150) NOT NULL,
    mobile_phone BIGINT NOT NULL, -- Matched employee table type
    salary DECIMAL(10,2) NOT NULL,
    role_type employee_role_enum_type NOT NULL,
    backup_date DATE NOT NULL
    -- No FK here, as it's a backup. If employee is deleted, backup might still be needed.
);

CREATE TABLE visitor_monthly_summary (
    id SERIAL PRIMARY KEY,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    total_visitors INTEGER NOT NULL,
    summary_date DATE NOT NULL
);

CREATE TABLE department_report (
    id SERIAL PRIMARY KEY,
    department_id INTEGER NOT NULL,
    total_parks INTEGER NOT NULL,
    total_employees INTEGER NOT NULL,
    report_date DATE NOT NULL,
    FOREIGN KEY(department_id) REFERENCES department(id) ON DELETE SET NULL -- Or CASCADE
);

CREATE TABLE project_archive (
    id INTEGER PRIMARY KEY, -- Original didn't have AUTO_INCREMENT
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(15,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    archive_date DATE NOT NULL
);


-- Creation of specific roles (users in PostgreSQL)
-- Host restriction ('@'localhost') is handled by pg_hba.conf in PostgreSQL

DROP ROLE IF EXISTS admin_np; -- Renamed to avoid conflict with potential 'admin' superuser role
CREATE ROLE admin_np WITH LOGIN PASSWORD '*adPa123*';
DROP ROLE IF EXISTS park_manager_np;
CREATE ROLE park_manager_np WITH LOGIN PASSWORD '*maPa123*';
DROP ROLE IF EXISTS researcher_np;
CREATE ROLE researcher_np WITH LOGIN PASSWORD '*rePa123*';
DROP ROLE IF EXISTS auditor_np;
CREATE ROLE auditor_np WITH LOGIN PASSWORD '*auPa123*';
DROP ROLE IF EXISTS visitor_manager_np;
CREATE ROLE visitor_manager_np WITH LOGIN PASSWORD '*viPa123*';

-- Grant privileges to admin_np
-- Typically, an admin role might own the database or have broader privileges.
-- For simplicity, granting specific rights. Assumes tables are in the 'public' schema.
GRANT CONNECT ON DATABASE natural_parks TO admin_np;
GRANT USAGE ON SCHEMA public TO admin_np;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_np;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_np;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin_np; -- If any functions are created

-- To grant privileges on future tables for admin_np:
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO admin_np;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO admin_np;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO admin_np;


-- Grant privileges to park_manager_np
-- PostgreSQL does not have a direct table-level ALTER privilege that can be granted like MySQL.
-- ALTER TABLE permissions are typically for the table owner or superuser.
-- For a manager, they might own these tables, or specific ALTER actions need more complex setup.
-- Granting CRUD:
GRANT SELECT, INSERT, UPDATE, DELETE ON area TO park_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON area_species TO park_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON park TO park_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON park_area TO park_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON species TO park_manager_np;
-- If park_manager_np needs to use sequences (e.g. for IDs if not using SERIAL directly)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO park_manager_np; -- Or specific sequences

-- Grant privileges to researcher_np
GRANT SELECT ON area TO researcher_np;
GRANT SELECT ON park TO researcher_np;
GRANT SELECT ON species TO researcher_np;
GRANT SELECT ON area_species TO researcher_np;
GRANT SELECT ON department TO researcher_np;
GRANT SELECT ON department_park TO researcher_np;
GRANT SELECT ON park_area TO researcher_np;
GRANT SELECT ON project TO researcher_np;

-- Grant privileges to auditor_np
GRANT SELECT ON employee TO auditor_np;
GRANT SELECT ON project TO auditor_np;

-- Grant privileges to visitor_manager_np
GRANT SELECT, INSERT, UPDATE, DELETE ON lodging TO visitor_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON entrance TO visitor_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON entrance_shift TO visitor_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON visitor TO visitor_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON visitor_log TO visitor_manager_np;
GRANT SELECT, INSERT, UPDATE, DELETE ON visitor_stay TO visitor_manager_np;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO visitor_manager_np; -- For SERIAL PKs


-- Example of how to set table ownership if a role needs more control (like ALTER)
-- This should be done by a superuser after tables are created.
-- ALTER TABLE area OWNER TO park_manager_np;
-- ALTER TABLE area_species OWNER TO park_manager_np;
-- ... and so on for other tables managed by park_manager_np
