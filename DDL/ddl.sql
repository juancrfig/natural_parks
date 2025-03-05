-- Ensures a clean initial state when running the database creation script
DROP DATABASE IF EXISTS natural_parks;
-- Sets the character encoding to UTF-8 to support special characters and emojis
CREATE DATABASE natural_parks  CHARACTER SET utf8mb4;

USE natural_parks; 


CREATE TABLE natural_park (
    in INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL UNIQUE,
    foundation_date DATE NOT NULL
);

CREATE TABLE park_area (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    extent FLOAT NOT NULL
);

CREATE TABLE department (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL UNIQUE,
    entity VARCHAR(100) NOT NULL,
    natural_park INT,
    FOREIGN KEY(natural_park) REFERENCES natural_park.id
);
