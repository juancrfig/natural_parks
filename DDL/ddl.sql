-- Ensures a clean initial state when running the database creation script
DROP DATABASE IF EXISTS natural_parks;
-- Sets the character encoding to UTF-8 to support special characters and emojis
CREATE DATABASE natural_parks  CHARACTER SET utf8mb4;

USE natural_parks; 


CREATE TABLE area (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL CHECK(TRIM(name) != ''),
    extent FLOAT NOT NULL CHECK(extent > 0)
);

CREATE TABLE species (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    type ENUM('vegetable', 'animal', 'mineral') NOT NULL,
    common_name VARCHAR(50) NOT NULL CHECK(TRIM(common_name) != '') UNIQUE,
    -- I chose 189 chars because this is the maximum length for a scientific name registered ever
    scientific_name VARCHAR(189) NOT NULL CHECK(TRIM(scientific_name) != '') UNIQUE
);

CREATE TABLE area_species (
    area_id INT UNSIGNED NOT NULL,
    species_id INT UNSIGNED NOT NULL,
    population INT UNSIGNED NOT NULL,
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE,
    FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE
);

CREATE TABLE project (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE CHECK(TRIM(name) != ''),
    budget DECIMAL(15,2) NOT NULL CHECK(budget > 0),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL, 
    CHECK(end_date > start_date)
);

CREATE TABLE employee (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    -- La primer cédula tuvo asignado el número 1
    cedula BIGINT NOT NULL UNIQUE CHECK(cedula > 0),
    -- Accordingly to Gemini AI, the longest name registered in Colombia is around 76 characters
    name VARCHAR(80) NOT NULL CHECK(TRIM(name) != ''),
    address VARCHAR(150) NOT NULL CHECK(TRIM(address) != ''),
    mobile_phone INT UNSIGNED NOT NULL CHECK(mobile_phone >= 1000000000),
    salary DECIMAL(10,2) NOT NULL CHECK(salary > 0),
    role_type ENUM('Management', 'Vigilance', 'Conservation', 'Research') NOT NULL
);

CREATE TABLE vigilance_staff (
    employee_id INT UNSIGNED PRIMARY KEY NOT NULL,
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE    
);

CREATE TABLE management_staff (
    employee_id INT UNSIGNED PRIMARY KEY NOT NULL,
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE    
);

CREATE TABLE conservation_staff (
    employee_id INT UNSIGNED PRIMARY KEY NOT NULL,
    specialty VARCHAR(200) NOT NULL CHECK(TRIM(specialty) != ''),
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE    
);

CREATE TABLE research_staff (
    employee_id INT UNSIGNED PRIMARY KEY NOT NULL,
    FOREIGN KEY(employee_id) REFERENCES employee(id) ON DELETE CASCADE
);

CREATE TABLE project_researcher (
    project_id INT UNSIGNED NOT NULL,
    researcher_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(project_id, researcher_id),
    FOREIGN KEY(project_id) REFERENCES project(id) ON DELETE CASCADE,
    FOREIGN KEY(researcher_id) REFERENCES research_staff(employee_id) ON DELETE CASCADE
);

CREATE TABLE project_researcher_species (
    project_id INT UNSIGNED NOT NULL,
    researcher_id INT UNSIGNED NOT NULL,
    species_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(project_id, researcher_id, species_id),
    FOREIGN KEY(project_id) REFERENCES project(id) ON DELETE CASCADE,
    FOREIGN KEY(researcher_id) REFERENCES research_staff(employee_id) ON DELETE CASCADE,
    FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE
);

CREATE TABLE park (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE CHECK(TRIM(name) != ''),
    foundation_date DATE NOT NULL
);

CREATE TABLE entrance (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    park_id INT UNSIGNED NOT NULL,
    entrance_number INT UNSIGNED NOT NULL,
    FOREIGN KEY(park_id) REFERENCES park(id) ON DELETE CASCADE
);

CREATE TABLE department (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    -- Currently the longest department name in Colombia has 21 chars.
    -- I am adding four more characters just in case.
    name VARCHAR(25) NOT NULL UNIQUE CHECK(TRIM(name) != '')
);

CREATE TABLE department_park (
    department_id INT UNSIGNED NOT NULL,
    park_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (department_id, park_id),
    FOREIGN KEY (department_id) REFERENCES department(id),
    FOREIGN KEY (park_id) REFERENCES park(id)
);

CREATE TABLE park_area (
    park_id INT UNSIGNED NOT NULL,
    area_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(park_id, area_id),
    FOREIGN KEY(park_id) REFERENCES park(id) ON DELETE CASCADE,
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE
);

CREATE TABLE vehicle (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(30) NOT NULL CHECK(TRIM(type) != ''),
    brand VARCHAR(20) NOT NULL CHECK(TRIM(brand) != '')
);

CREATE TABLE vigilance_area (
    vigilance_id INT UNSIGNED NOT NULL,
    area_id INT UNSIGNED NOT NULL,
    vehicle_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(vigilance_id, area_id),
    FOREIGN KEY(vigilance_id) REFERENCES vigilance_staff(employee_id) ON DELETE CASCADE,
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE,
    FOREIGN KEY(vigilance_id) REFERENCES vehicle(id) ON DELETE CASCADE
);

CREATE TABLE conservation_area (
    conservation_id INT UNSIGNED NOT NULL,
    area_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(conservation_id, area_id),
    FOREIGN KEY(conservation_id) REFERENCES conservation_staff(employee_id) ON DELETE CASCADE,
    FOREIGN KEY(area_id) REFERENCES area(id) ON DELETE CASCADE
);

CREATE TABLE entrance_shift (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    employee_id INT UNSIGNED NOT NULL,
    entrance_id INT UNSIGNED NOT NULL,
    begin DATETIME NOT NULL,
    end DATETIME NOT NULL,
    CHECK (end > begin),
    FOREIGN KEY(employee_id) REFERENCES employee(id),
    FOREIGN KEY(entrance_id) REFERENCES entrance(id)
);

CREATE TABLE visitor (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    -- La primer cédula tuvo asignado el número 1
    cedula BIGINT NOT NULL UNIQUE CHECK(cedula > 0),
    -- Accordingly to Gemini AI, the longest name registered in Colombia is around 76 characters
    name VARCHAR(80) NOT NULL CHECK(TRIM(name) != ''),
    address VARCHAR(150) NOT NULL CHECK(TRIM(address) != ''),
    job VARCHAR(60) NOT NULL CHECK(TRIM(job) != '')
);

CREATE TABLE lodging (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    park_id INT UNSIGNED NOT NULL,
    name VARCHAR(50) NOT NULL CHECK(TRIM(name) != ''),
    capacity INT NOT NULL CHECK(capacity > 0),
    category VARCHAR(30) NOT NULL CHECK(TRIM(category) != ''),
    FOREIGN KEY(park_id) REFERENCES park(id) ON DELETE CASCADE
);

CREATE TABLE visitor_stay (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    visitor_id INT UNSIGNED NOT NULL,
    lodging_id INT UNSIGNED NOT NULL,
    check_in DATETIME NOT NULL,
    check_out DATETIME NOT NULL,
    CHECK(check_out > check_in),
    FOREIGN KEY(visitor_id) REFERENCES visitor(id) ON DELETE CASCADE,
    FOREIGN KEY(lodging_id) REFERENCES lodging(id) ON DELETE CASCADE 
);

CREATE TABLE visitor_log (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    entrance_shift_id INT UNSIGNED NOT NULL,
    visit_time DATETIME NOT NULL,
    visitor_id INT UNSIGNED NOT NULL,
    FOREIGN KEY(entrance_shift_id) REFERENCES entrance_shift(id) ON DELETE CASCADE,
    FOREIGN KEY(visitor_id) REFERENCES visitor(id) ON DELETE CASCADE
);

CREATE TABLE responsible_entity (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL CHECK(TRIM(name) != '')
);

CREATE TABLE department_entity (
    department_id INT UNSIGNED NOT NULL,
    entity_id INT UNSIGNED NOT NULL,
    PRIMARY KEY(department_id, entity_id),
    FOREIGN KEY(department_id) REFERENCES department(id) ON DELETE CASCADE,
    FOREIGN KEY(entity_id) REFERENCES responsible_entity(id) ON DELETE CASCADE
);
