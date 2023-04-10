/* Populate database with sample data. */

insert into animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES
    (1, 'Agumon', '2020-02-03', 0, true, 10.23),
    (2, 'Gabumon', '2018-11-15', 2, true, 8.0),
    (3, 'Pikachu', '2021-01-07', 1, false, 15.04),
    (4, 'Devimon', '2017-05-12', 5, true, 11.0);

-- insert another records into animals table --

insert into animals(id, name, date_of_birth, escape_attempts, neutered, weight_kg)
values 
    (5, 'Charmander', '2020-02-08', 0, false, 11.0),
    (6, 'Plantmon', '2021-11-15', 2, true, 5.7),
    (7, 'Squirtle', '1993-04-02', 1, false, 12.13),
    (8, 'Angemon', '2005-06-12', 1, true, 45.0),
    (9, 'Boarmon', '2005-06-07', 7, true, 20.4),
    (10, 'Blossom', '1998-10-13', 3, true, 17.0),
    (11, 'Ditto', '2022-05-14', 4, true, 22.0)


-- insert some records into owners table --

insert into owners(full_name, age)
    values 
        ('Sam Smith', 34),
        ('Jennifer Orwell', 19),
        ('Bob', 45),
        ('Melody Pond', 77),
        ('Dean Winchester', 14),
        ('Jodie Whittaker', 38);

-- insert datas into species table --

insert into species(name)
    values
        ('Pokemon'),
        ('Digimon');

-- update species_id column of animals table --

update animals
set species_id = 3
where name like '%mon';

update animals
set species_id = 3
where name not like '%mon';

-- Update owner_id column of animals table

update animals
set owner_id = 1
where name = 'Agumon';

update animals
set owner_id = 2
where name in ('Gabumon', 'Pikachu');

update animals
set owner_id = 3
where name in ('Devimon', 'Plantmon');

update animals
set owner_id = 4
where name in ('Charmander', 'Squirtle', 'Blossom');

update animals
set owner_id = 5
where name in ('Angemon', 'Boarmon');


-- Add some data records into vets table --

insert into vets (name, age, date_of_graduation)
  values 
    ('William Tatcher', 45, '2000-04-23'),
    ('Maisy Smith', 26, '2019-01-17'),
    ('Stephanie Mendez', 64, '1981-05-04'),
    ('Jack Harkness', 38, '2008-06-08');

-- Add data records into specializations table -- 

insert into specializations(vet_id, specie_id)
values 
    (1, 3),
    (3, 3),
    (3, 4),
    (4, 4);

-- Add some data records for visits table --

insert into visits(vet_id, animal_id, date_of_visit)
VALUES
    (1, 1, '2020-05-24'),
    (3, 1, '2020-07-22'),
    (4, 2, '2021-02-02'),
    (2, 3, '2020-02-02'),
    (2, 3, '2020-05-08'),
    (2, 3, '2020-05-14'),
    (3, 4, '2021-05-04'),
    (4, 5, '2021-02-24'),
    (2, 6, '2019-12-21'),
    (1, 6, '2020-08-10'),
    (2, 6, '2021-04-07'),
    (3, 7, '2019-09-29'),
    (4, 1, '2020-10-03'),
    (4, 1, '2020-11-04'),
    (2, 9, '2019-01-24'),
    (2, 9, '2019-05-15'),
    (2, 9, '2020-02-27'),
    (2, 9, '2020-08-03'),
    (3, 10, '2020-05-24'),
    (1, 10, '2021-01-11');

-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';
