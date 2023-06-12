## 1
CREATE TABLE songs (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  length FLOAT NOT NULL,
  album_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (album_id) REFERENCES albums(id)
);

## 2
SELECT bands.name AS 'Band Name'
FROM bands;

## 3
SELECT * FROM albums
WHERE release_year IS NOT NULL
ORDER BY release_year
LIMIT 1;

## 4
/* This assummes all bands have a unique name */
SELECT DISTINCT bands.name AS 'Band Name'
FROM bands
JOIN albums ON bands.id = albums.band_id;

/* If bands do not have a unique name then use this query */
SELECT bands.name AS 'Band Name'
FROM bands
JOIN albums ON bands.id = albums.band_id
GROUP BY albums.band_id
HAVING COUNT(albums.id) > 0;

## 5
SELECT bands.name AS 'Band Name'
FROM bands
LEFT JOIN albums ON bands.id = albums.band_id
GROUP BY albums.band_id
HAVING COUNT(albums.id) = 0;

## 6
SELECT
  albums.name as Name,
  albums.release_year as 'Release Year',
  SUM(songs.length) as 'Duration'
FROM albums
JOIN songs on albums.id = songs.album_id
GROUP BY songs.album_id
ORDER BY Duration DESC
LIMIT 1;

## 7
/* This is the query used to get the id */
  SELECT * FROM albums where release_year IS NULL;

UPDATE albums
SET release_year = 1986
WHERE id = 4;

## 8
INSERT INTO bands (name)
VALUES ('Favorite Band Name');

/* This is the query used to get the band id of the band just added */
  SELECT id FROM bands
  ORDER BY id DESC LIMIT 1;

INSERT INTO albums (name, release_year, band_id)
VALUES ('Favorite Album Name', 2000, 8);

## 9
/* This is the query used to get the album id of the album added in #8 */
  SELECT id FROM albums
  ORDER BY id DESC LIMIT 1;

DELETE FROM albums
WHERE id = 19;

/* This is the query used to get the band id of the band added in #8 */
  SELECT id FROM bands
  ORDER BY id DESC LIMIT 1;

DELETE FROM bands
WHERE id = 8;

## 10
SELECT AVG(length) as 'Average Song Duration'
FROM songs;

## 11
SELECT
  albums.name AS 'Album',
  albums.release_year AS 'Release Year',
  MAX(songs.length) AS 'Duration'
FROM albums
JOIN songs ON albums.id = songs.album_id
GROUP BY songs.album_id;

## 12
SELECT
  bands.name AS 'Band',
  COUNT(songs.id) AS 'Number of Songs'
FROM bands
JOIN albums ON bands.id = albums.band_id
JOIN songs ON albums.id = songs.album_id
GROUP BY albums.band_id;
