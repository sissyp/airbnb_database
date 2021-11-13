--1)number of movies per year
ALTER TABLE movies_metadata
add column release_year text;
UPDATE movies_metadata SET release_year = SPLIT_PART(cast(movies_metadata.release_date as varchar), '-',1);

ALTER TABLE movies_metadata 
alter column release_year TYPE int using release_year::int;

SELECT COUNT(id), release_year
FROM movies_metadata
GROUP BY release_year
ORDER BY release_year;


--2)number of movies per genre
UPDATE movies_metadata
SET genres = REPLACE(REPLACE(genres,'[','{'),']','}');

create table new_genres as (select  unnest(genres::text[]) as genre_text,id as movie_id from movies_metadata);

create table final_genres_name as (select movie_id, genre_text from new_genres where genre_text like'%name%');

UPDATE final_genres_name SET genre_text = REPLACE(genre_text,E'\'','');
UPDATE final_genres_name SET genre_text = REPLACE(genre_text,'name:','');

SELECT genre_text, COUNT(movie_id)
FROM final_genres_name
GROUP BY genre_text;


--3)number of movies per year and genre
SELECT release_year, genre_text, COUNT(id)
FROM movies_metadata
JOIN final_genres_name
ON id = movie_id
GROUP BY release_year, genre_text
ORDER BY release_year;

--4)average rating per genre
ALTER TABLE ratings_small 
alter column  rating TYPE FLOAT using rating::float;

SELECT genre_text, AVG(rating)
FROM final_genres_name
JOIN ratings_small
ON movie_id = movieId
GROUP BY genre_text;

--5)number of ratings per user
SELECT userId, COUNT(rating)
FROM ratings_small
GROUP BY userId
ORDER BY userId;

--6)average rating per user
SELECT userId, AVG(rating)
FROM ratings_small
GROUP BY userId
ORDER BY userId;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
--create view_table
create table view_table as (SELECT userId, 
COUNT(rating) as number_of_ratings, 
AVG(rating) as average_rating 
FROM ratings_small
GROUP BY userId);

/*the insight we get from this relation is some statistics about
 each user, which means that we can directly be informed about the number of ratings per user and
 the average rating per user. We can use these statistics to create other
 queries that will use the information for each user combined with information from other tables.*/



