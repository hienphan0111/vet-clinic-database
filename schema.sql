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
