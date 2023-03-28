/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon" --
SELECT * FROM animals
WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019. --

SELECT name FROM animals
WHERE EXTRACT (YEAR FROM date_of_birth) BETWEEN 2016 AND 2019;

-- List the name of all animals that are neutered and have less than 3 escape attempts.

SELECT name FROM animals
wHERE neutered AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu". --

SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg

SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

-- Find all animals that are neutered. --

SELECT * FROM animals
WHERE neutered;

-- Find all animals not named Gabumon. --

SELECT * FROM animals
WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg) --

SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- update, rollback and commit a transaction --

begin;
    
    update animals
    set species = 'unspecified';
    
    ROLLBACK ;
    
    update animals
    set species = 'digimon'
    where name like '%mon';
    
    update animals
    set species = 'pokemon'
    where species is null;
    
commit;

select * from animals;

-- delete records of table by using transaction --

begin;
    
    DELETE FROM animals
    WHERE date_of_birth > '2022-01-01'::date;

    SAVEPOINT save_1;
    
    update animals
    set weight_kg = weight_kg * -1;
    
    ROLLBACK to SAVEPOINT save_1;
    
    update animals
    set weight_kg = weight_kg * -1;

commit;

    SELECT * from animals;

/* Write queries to anwers the following questions */

-- How many animals are there?

select 
    count(*)
from animals;

-- How many animals have never tried to escape? --

select 
    count(*)
from animals
where escape_attempts = 0;

-- What is the average weight of animals? --

select 
    avg(weight_kg)
from animals;

-- Who escapes the most, neutered or not neutered animals? --

select 
    neutered, max(escape_attempts)
from animals
group by neutered;

-- What is the minimum and maximum weight of each type of animal?

select 
    species, min(abs(weight_kg)), max(abs(weight_kg))
from animals
group by species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?

select 
    species, avg(escape_attempts)
from animals
where 
    extract (year from date_of_birth) between 1990 and 2000
group by species;
