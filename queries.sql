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

/* Write queries (using JOIN) to answer the following questions */

-- What animals belong to Melody Pond? --

select owners.owner_id, owners.full_name, animals.name, animals.owner_id
from owners
inner join animals
    on owners.owner_id = animals.owner_id
where owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon). --

select species.species_id, species.name, animals.name, animals.species_id
from species
inner join animals
    on species.species_id = animals.species_id
where species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal. --

select owners.owner_id, owners.full_name, animals.name, animals.owner_id
from owners
left join animals
    on owners.owner_id = animals.owner_id;

-- How many animals are there per species? --

select count(animals.id), species.name
from species
left join animals
    on species.species_id = animals.species_id
Group by species.name;

-- List all Digimon owned by Jennifer Orwell.

select owners.full_name, species.name, animals.name
from owners
inner join animals
    on owners.owner_id = animals.owner_id
inner join species
    on animals.species_id = species.species_id
where owners.full_name = 'Jennifer Orwell' and species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape. --

select owners.full_name, animals.name, animals.escape_attempts
from owners
left join animals
    on owners.owner_id = animals.owner_id
where owners.full_name = 'Dean Winchester' and animals.escape_attempts = 0;

-- Who owns the most animals? --

select full_name, my_count
from (
    select owners.full_name as full_name, count(animals.name) as my_count
    from owners
    left join animals
        on owners.owner_id = animals.owner_id
    group by owners.full_name
) as animals_owners
where my_count = ( select max(my_count) from (
        select owners.full_name as full_name, count(animals.name) as my_count
        from owners
        left join animals
            on owners.owner_id = animals.owner_id
        group by owners.full_name
    ) as animals_owners
);

-- Who was the last animal seen by William Tatcher? --

select vet_name, animal_name, date_of_visit
from (
    select vets.name as vet_name, animals.name as animal_name, visits.date_of_visit
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
    where vets.name = 'William Tatcher'
) as vets_animals_visits
where date_of_visit = ( 
    select max(visits.date_of_visit)
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
    where vets.name = 'William Tatcher'
) ;

-- How many different animals did Stephanie Mendez see? --

select count(animal_name)
from (
    select animals.name as animal_name
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
    where vets.name = 'Stephanie Mendez'
) as vets_animals_visits;

-- List all vets and their specialties, including vets with no specialties.

select vets.name, species.name 
from vets
left join specializations
    on vets.id = specializations.vet_id
left join species
    on species.species_id = specializations.specie_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.

select vet_name, animal_name, date_of_visit
from (
    select vets.name as vet_name, animals.name as animal_name, visits.date_of_visit
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
    where vets.name = 'Stephanie Mendez'
) as vets_animals_visits
where date_of_visit > '2020-04-01' and date_of_visit < '2020-08-30';

-- What animal has the most visits to vets?

select animal_name, count
from (
    select count(animals.name) as count, animals.name as animal_name
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
    group by animals.name
) as vets_animals_visits
where count = (
    select max(count) 
    from (
        select count(animals.name) as count
        from visits
        inner join vets on vets.id = visits.vet_id
        inner join animals on animals.id = visits.animal_id
        group by animals.name
    ) as vets_animals_visits
);

-- Who was Maisy Smith's first visit?

select vet_name, animal_name, date_of_visit
from (
    select vets.name as vet_name, animals.name as animal_name, visits.date_of_visit
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
    where vets.name = 'Maisy Smith'
) as vets_animals_visits
where date_of_visit = ( 
    select min(visits.date_of_visit)
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
    where vets.name = 'Maisy Smith'
) ;

-- Details for most recent visit: animal information, vet information, and date of visit.

select vet_name, animal_name, date_of_visit
from (
    select vets.name as vet_name, animals.name as animal_name, visits.date_of_visit
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
) as vets_animals_visits
where date_of_visit = ( 
    select min(visits.date_of_visit)
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
) ;

-- How many visits were with a vet that did not specialize in that animal's species?

SELECT COUNT(*)
FROM visits v
INNER JOIN animals a ON v.animal_id = a.id
LEFT JOIN specializations s ON v.vet_id = s.vet_id AND a.species_id = s.specie_id
WHERE s.vet_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.

select species_name, count (*) as num_of_visits
from (
    select vets.name as vet_name, animals.name as animal_name, species.name as species_name, visits.date_of_visit
    from visits
    inner join vets on vets.id = visits.vet_id
    inner join animals on animals.id = visits.animal_id
    inner join species on animals.species_id = species.species_id
    where vets.name = 'Maisy Smith'
) as vets_animals_visits
group by species_name;
