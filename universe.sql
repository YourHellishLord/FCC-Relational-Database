-- Create the database
CREATE DATABASE universe;

-- Connect to the database
\c universe

-- Create the tables

CREATE TABLE planet_types (
  planet_types_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT
); -- at least 3 rows

CREATE TABLE galaxy_types (
  galaxy_types_id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT
); -- at least 3 rows

CREATE TABLE galaxy (
  galaxy_id SERIAL PRIMARY KEY,
  
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  age_in_millions_of_years INTEGER NOT NULL,
  distance_from_earth NUMERIC(10, 2) NOT NULL,

  galaxy_types_id INTEGER NOT NULL,
    FOREIGN KEY (galaxy_types_id) REFERENCES galaxy_types(galaxy_types_id)
); -- at least six rows

CREATE TABLE star (
  star_id SERIAL PRIMARY KEY,
  
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  age_in_millions_of_years INTEGER NOT NULL,

  galaxy_id INTEGER NOT NULL,
    FOREIGN KEY (galaxy_id) REFERENCES galaxy(galaxy_id)
); -- at least six rows

CREATE TABLE planet (
  planet_id SERIAL PRIMARY KEY,

  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  has_life BOOLEAN NOT NULL DEFAULT FALSE,
  is_spherical BOOLEAN NOT NULL DEFAULT TRUE,
  
  planet_types_id INTEGER NOT NULL,
    FOREIGN KEY (planet_types_id) REFERENCES planet_types(planet_types_id),
  star_id INTEGER NOT NULL,
    FOREIGN KEY (star_id) REFERENCES star(star_id)
); -- at least 12 rows

CREATE TABLE moon (
  moon_id SERIAL PRIMARY KEY,
  
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  distance_from_planet NUMERIC(10, 2) NOT NULL,

  planet_id INTEGER NOT NULL,
    FOREIGN KEY (planet_id) REFERENCES planet(planet_id)
); -- at least 20 rows



-- DATA INSERTION

INSERT INTO galaxy_types (name, description)
VALUES 
('Spiral', 'A spiral galaxy is a type of galaxy that has a spiral structure.'),
('Elliptical', 'An elliptical galaxy is a type of galaxy that has an elliptical shape.'),
('Irregular', 'An irregular galaxy is a type of galaxy that does not have a regular shape.');

INSERT INTO planet_types (name, description)
VALUES 
('Terrestrial', 'A terrestrial planet is a type of planet that is composed primarily of rock and metal.'),
('Gas Giant', 'A gas giant is a type of planet that is composed primarily of hydrogen and helium gases.'),
('Ice Giant', 'An ice giant is a type of planet that is composed primarily of water, ammonia, and methane ices.');

INSERT INTO galaxy (name, description, age_in_millions_of_years, distance_from_earth, galaxy_types_id)
VALUES 
('Andromeda', 'The Andromeda Galaxy is a spiral galaxy located approximately 2.5 million light-years away from Earth.', 10000, 2.50, 1),
('Milky Way', 'The Milky Way is a spiral galaxy that contains our solar system.', 13000, 0.00, 1),
('Triangulum', 'The Triangulum Galaxy is a spiral galaxy located approximately 3 million light-years away from Earth.', 8000, 3.00, 1),
('Sombrero', 'The Sombrero Galaxy is an unbarred spiral galaxy located approximately 31 million light-years away from Earth.', 13000, 31.00, 1),
('Pinwheel', 'The Pinwheel Galaxy is a face-on spiral galaxy located approximately 21 million light-years away from Earth.', 10000, 21.00, 1),
('Whirlpool', 'The Whirlpool Galaxy is an interacting spiral galaxy located approximately 31 million light-years away from Earth.', 8000, 31.00, 1);

INSERT INTO star (name, description, age_in_millions_of_years, galaxy_id)
VALUES 
('Sun', 'The Sun is the star at the center of our solar system.', 4600, 2),
('Sirius', 'Sirius is the brightest star in the night sky.', 250, 2),
('Betelgeuse', 'Betelgeuse is a red supergiant star located in the constellation Orion.', 800, 2),
('Rigel', 'Rigel is a blue-white supergiant star located in the constellation Orion.', 1000, 2),
('Deneb', 'Deneb is a blue-white supergiant star located in the constellation Cygnus.', 2000, 2),
('Vega', 'Vega is a white main-sequence star located in the constellation Lyra.', 500, 2),
('Altair', 'Altair is a white main-sequence star located in the constellation Aquila.', 1000, 2),
('Procyon', 'Procyon is a white-yellow main-sequence star located in the constellation Canis Minor.', 2000, 2),
('Capella', 'Capella is a yellow-orange giant star located in the constellation Auriga.', 500, 2),
('Arcturus', 'Arcturus is an orange giant star located in the constellation Boötes.', 7000, 2),
('Aldebaran', 'Aldebaran is an orange giant star located in the constellation Taurus.', 1000, 2),
('Spica', 'Spica is a blue-white subgiant star located in the constellation Virgo.', 200, 2);


INSERT INTO planet (name, description, has_life, is_spherical, planet_types_id, star_id)
VALUES 
('Mercury', 'Mercury is the smallest planet in our solar system.', FALSE, TRUE, 1, 1),
('Venus', 'Venus is the second planet from the Sun in our solar system.', FALSE, TRUE, 1, 1),
('Earth', 'Earth is the third planet from the Sun in our solar system.', TRUE, TRUE, 1, 1),
('Mars', 'Mars is the fourth planet from the Sun in our solar system.', FALSE, TRUE, 1, 1),
('Jupiter', 'Jupiter is the largest planet in our solar system.', FALSE, TRUE, 2, 1),
('Saturn', 'Saturn is a gas giant planet in our solar system.', FALSE, TRUE, 2, 1),
('Uranus', 'Uranus is an ice giant planet in our solar system.', FALSE, TRUE, 3, 1),
('Neptune', 'Neptune is an ice giant planet in our solar system.', FALSE, TRUE, 3, 1),
('Proxima b', 'Proxima b is a terrestrial exoplanet orbiting Proxima Centauri.', FALSE, TRUE, 1, 7),
('TRAPPIST-1e', 'TRAPPIST-1e is a terrestrial exoplanet orbiting TRAPPIST-1.', FALSE, TRUE, 1, 8),
('Kepler-452b', 'Kepler-452b is a terrestrial exoplanet orbiting Kepler-452.', FALSE, TRUE, 1, 9),
('55 Cancri e', '55 Cancri e is a super-Earth exoplanet orbiting 55 Cancri.', FALSE, TRUE, 1, 10),
('HD 189733b', 'HD 189733b is a gas giant exoplanet orbiting HD 189733.', FALSE, TRUE, 2, 11),
('WASP-12b', 'WASP-12b is a hot Jupiter exoplanet orbiting WASP-12.', FALSE, TRUE, 2, 12);

INSERT INTO moon (name, description, distance_from_planet, planet_id)
VALUES 
('Moon', 'The Moon is the natural satellite of Earth.', 0.38, 3),
('Phobos', 'Phobos is a moon of Mars.', 0.06, 4),
('Deimos', 'Deimos is a moon of Mars.', 0.20, 4),
('Io', 'Io is a moon of Jupiter.', 0.43, 5),
('Europa', 'Europa is a moon of Jupiter.', 0.67, 5),
('Ganymede', 'Ganymede is a moon of Jupiter.', 1.07, 5),
('Callisto', 'Callisto is a moon of Jupiter.', 1.88, 5),
('Mimas', 'Mimas is a moon of Saturn.', 0.18, 6),
('Enceladus', 'Enceladus is a moon of Saturn.', 0.24, 6),
('Tethys', 'Tethys is a moon of Saturn.', 0.29, 6),
('Dione', 'Dione is a moon of Saturn.', 0.38, 6),
('Rhea', 'Rhea is a moon of Saturn.', 0.52, 6),
('Titan', 'Titan is a moon of Saturn.', 1.20, 6),
('Oberon', 'Oberon is a moon of Uranus.', 0.58, 7),
('Titania', 'Titania is a moon of Uranus.', 0.88, 7),
('Umbriel', 'Umbriel is a moon of Uranus.', 0.97, 7),
('Ariel', 'Ariel is a moon of Uranus.', 1.19, 7),
('Miranda', 'Miranda is a moon of Uranus.', 1.29, 7),
('Triton', 'Triton is a moon of Neptune.', 0.35, 8),
('Nereid', 'Nereid is a moon of Neptune.', 0.55, 8);