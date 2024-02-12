DROP TABLE IF EXISTS moon;
DROP TABLE IF EXISTS planet;
DROP TABLE IF EXISTS star;
DROP TABLE IF EXISTS galaxy;
DROP TABLE IF EXISTS galaxy_class;

CREATE TABLE galaxy_class(
	galaxy_class_id SERIAL PRIMARY KEY,
	name VARCHAR(256) NOT null UNIQUE
);

CREATE TABLE galaxy(
	galaxy_id SERIAL PRIMARY KEY,
	name VARCHAR(256) unique,
	galaxy_class_id INT,
	is_discovered BOOL not null,
	rating INT,
	
	CONSTRAINT fk_galaxy_class
		FOREIGN KEY(galaxy_class_id)
			REFERENCES galaxy_class(galaxy_class_id)
);

CREATE TABLE star(
	star_id SERIAL PRIMARY KEY,
	name VARCHAR(256) NOT NULL UNIQUE,
	galaxy_id INT,
	temperature_in_celsius INT,
	weight NUMERIC(4, 2),
	
	CONSTRAINT fk_galaxy
		FOREIGN KEY(galaxy_id)
			REFERENCES galaxy(galaxy_id)
);

CREATE TABLE planet(
	planet_id SERIAL PRIMARY KEY,
	name VARCHAR(256) NOT null UNIQUE,
	star_id INT,
	descr VARCHAR(256),
	num INT,
	
	CONSTRAINT fk_star
		FOREIGN KEY(star_id)
			REFERENCES star(star_id)
);

CREATE TABLE moon(
	moon_id SERIAL PRIMARY KEY,
	name VARCHAR(256) NOT null UNIQUE,
	planet_id INT,
	descr VARCHAR(256),
	num INT,
	
	CONSTRAINT fk_planet
		FOREIGN KEY(planet_id)
			REFERENCES planet(planet_id)
);

--INSERTS
insert into galaxy_class("name") values
('small'),
('average'),
('giant');

insert into galaxy("name", galaxy_class_id, is_discovered, rating)  values
('galaxy#1', 1, true, 10),
('galaxy#2', 1, false, 1),
('galaxy#3', 2, true, 10),
('galaxy#4', 2, true, 10),
('galaxy#5', 3, true, 10),
('galaxy#6', 3, true, NULL);

insert into star("name", galaxy_id, temperature_in_celsius, weight) values
('star#1', 1, 1000, 99.99),
('star#2', 2, 1000, 99.99),
('star#3', 3, 1000, 99.99),
('star#4', 4, 1000, 99.99),
('star#5', 5, 1000, 99.99),
('star#6', 5, 1000, 99.99);

insert into planet("name", star_id) values
('planet#1', 1),
('planet#2', 1),
('planet#3', 2),
('planet#4', 2),
('planet#5', 3),
('planet#6', 3),
('planet#7', 4),
('planet#8', 4),
('planet#9', 5),
('planet#10', 5),
('planet#11', 6),
('planet#12', 6);

insert into moon("name", planet_id) values
('moon#1', 1),
('moon#2', 1),
('moon#3', 2),
('moon#4', 2),
('moon#5', 3),
('moon#6', 3),
('moon#7', 4),
('moon#8', 4),
('moon#9', 5),
('moon#10', 5),
('moon#11', 6),
('moon#12', 6),
('moon#13', 7),
('moon#14', 7),
('moon#15', 8),
('moon#16', 8),
('moon#17', 9),
('moon#18', 10),
('moon#19', 10),
('moon#20', 10);

select
	g.galaxy_id as "Galaxy Name",
	g."name",
	g.is_discovered as "Discovered",
	gc."name" as "Class",
	s.star_id,
	s."name" as "Star Name",
	p.planet_id,
	p."name" as "Planet Name",
	count(m.moon_id) over (partition by m.planet_id) as "total # of moons"
from
	galaxy g
full join galaxy_class gc on
	g.galaxy_class_id  = gc.galaxy_class_id
full join star s on
	g.galaxy_id = s.galaxy_id
full join planet p on
	p.star_id = s.star_id
full join moon m on
	m.planet_id = p.planet_id 
order by p.planet_id;

--select * from star s;
--select * from planet p;