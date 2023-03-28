/* Database schema to keep the structure of entire database. */

create TABLE animals (
    id INT primary key,
    name varchar(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL
);

-- add a column species of type string to animals table --

alter table animals
add species varchar(100);
