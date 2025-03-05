-- Ensures a clean initial state when running the database creation script
DROP DATABASE IF EXISTS natural_parks;
-- Sets the character encoding to UTF-8 to support special characters and emojis
CREATE DATABASE natural_parks  CHARACTER SET utf8mb4;

USE natural_parks; 


CREATE TABLE park (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL UNIQUE,
    foundation_date DATE NOT NULL
);

CREATE TABLE department (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL UNIQUE,
    entity VARCHAR(100) NOT NULL,
);

CREATE TABLE department_park (
    department_id INT,
    park_id INT,
    PRIMARY KEY (department_id, park_id),
    FOREIGN KEY (department_id) REFERENCES department.id,
    FOREIGN KEY (park_id) REFERENCES park.id
);

CREATE TABLE park_area (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    extent FLOAT NOT NULL
);

