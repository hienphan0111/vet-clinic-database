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


-- Create a table named 'owners' --

create TABLE owners (
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name varchar(100) NOT NULL,
  age INT,
  primary key (id)
);

-- create table named 'species' ---

create TABLE species (
  species_id INT GENERATED ALWAYS AS IDENTITY,
  name varchar(100) NOT NULL
);

-- change id column in order to autoincremented PRIMARY KEY --

alter table animals
alter column id add GENERATED always as IDENTITY;

-- Remove species column in animals table --

alter table animals
drop column if exists species;

-- Add 2 more columns into animals table and set it to be foreign keys --

alter table species
    add primary key (species_id);

alter table animals
add column species_id int,
add constraint fk_species
        foreign key (species_id)
        REFERENCES species(species_id)
        on delete cascade,
add column owner_id int,
add constraint fk_owner
        foreign key (owner_id)
        REFERENCES owners(id)
        on delete cascade;

-- Create a table named vets

create table vets (
  id INT generated always as identity,
  name varchar(100) NOT NULL,
  age INT,
  date_of_graduation date,
  primary key (id)
);

-- Create a table named specializations --

create table specializations (
  vet_id INT,
  specie_id INT,
  primary key ( vet_id, specie_id),
  constraint pk_vet 
    foreign key (vet_id) 
    REFERENCES vets(id)
    on update cascade,
  constraint pl_specie 
    foreign key (specie_id) 
    REFERENCES species(species_id)
    on update cascade
);

-- Create a table named visits to handle relationship between animals and vets table --

create table visits (
  animal_id INT,
  vet_id INT,
  date_of_visit date,
  constraint pk_animal
    foreign key (animal_id) 
    REFERENCES animals(id)
    on update cascade,
  constraint pk_vet 
    foreign key (vet_id) 
    REFERENCES vets(id)
    on update cascade
);

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

-- Find a way to decrease the execution time of the first query

CREATE INDEX idx_animal_id ON visits (animal_id);

