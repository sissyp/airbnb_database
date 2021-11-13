--create_credits
create table Credits(
   movie_cast text,
   crew text,
   id int
);

--create_links
create table Links(
   movieId int,
   imdbId int,
   tmdbId int
);

--create_keywords
create table Keywords(
   id int,
   keywords text
);

--create_movies_metadata
create table Movies_Metadata(
   adult varchar(10),
   belongs_to_collection varchar(190),
   budget int,
   genres varchar(270),
   homepage varchar(250),
   id int,
   imdb_id varchar(10),
   original_language varchar(10),
   original_title varchar(110),
   overview varchar(1000),
   popularity varchar(10),
   poster_path varchar(40),
   production_companies varchar(1260),
   production_countries varchar(1040),
   release_date date,
   revenue bigint,
   runtime varchar(10),
   spoken_languages varchar(770),
   status varchar(20),
   tagline varchar(300),
   title varchar(110),
   video varchar(10),
   vote_average varchar(10),
   vote_count int
);

--create_ratings_small
create table Ratings_Small(
   userId int,
   movieId int,
   rating varchar(10),
   timestamp int
);

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--copy data from csv files to our tables

BEGIN;
	set client_encoding to 'utf8';
	\copy Credits FROM 'C:/Users/kater/Desktop/data/credits.csv' DELIMITER ',' CSV HEADER;
	\copy Links FROM 'C:/Users/kater/Desktop/data/links.csv' DELIMITER ',' CSV HEADER;
	\copy Keywords FROM 'C:/Users/kater/Desktop/data/keywords.csv' DELIMITER ',' CSV HEADER;
	\copy Movies_Metadata FROM 'C:/Users/kater/Desktop/data/movies_metadata.csv' DELIMITER ',' CSV HEADER;
	\copy Ratings_Small FROM 'C:/Users/kater/Desktop/data/ratings_small.csv' DELIMITER ',' CSV HEADER;
COMMIT;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--find duplicate rows in all tables

--for table credits
SELECT (credits.*)::text, count(*)
FROM credits
GROUP BY credits.*
HAVING count (*) > 1;

--for table links
SELECT (links.*)::text, count(*)
FROM links
GROUP BY links.*
HAVING count (*) > 1;

--for table keywords
SELECT (keywords.*)::text, count(*)
FROM keywords
GROUP BY keywords.*
HAVING count (*) > 1;

--for table movies_metadata
SELECT (movies_metadata.*)::text, count(*)
FROM movies_metadata
GROUP BY movies_metadata.*
HAVING count (*) > 1;


--delete duplicate rows from credits, keywords, movies_metadata
--the rest of the tables didn't have duplicates
--we are going to use an immediate table in oder to delete duplicates

--for table credits
CREATE TABLE credits_copy (LIKE credits);

INSERT INTO credits_copy(movie_cast,crew,id)
SELECT 
    DISTINCT ON (id) movie_cast,crew,id
FROM credits; 

drop table credits;

ALTER TABLE credits_copy 
RENAME TO credits;

--for table keywords
CREATE TABLE keywords_copy (LIKE keywords);

INSERT INTO keywords_copy(id,keywords)
SELECT 
    DISTINCT ON (id) id,keywords
FROM keywords;  

drop table keywords;

ALTER TABLE keywords_copy 
RENAME TO keywords;

--for table movies_metadata
CREATE TABLE movies_metadata_copy (LIKE movies_metadata);

INSERT INTO movies_metadata_copy(belongs_to_collection,budget,genres,homepage,id,imdb_id,original_language ,
   original_title,overview,popularity,poster_path,production_companies,
   production_countries,release_date,revenue,runtime,spoken_languages,status,
   tagline,title,video,vote_average,vote_count)
SELECT 
    DISTINCT ON (id) id, adult,
   belongs_to_collection,budget,genres,homepage,imdb_id,original_language ,
   original_title ,overview,popularity,poster_path,production_companies,
   production_countries,release_date,revenue,runtime,spoken_languages,status,
   tagline,title,video,vote_average,vote_count
FROM movies_metadata; 

drop table movies_metadata;

ALTER TABLE movies_metadata_copy 
RENAME TO movies_metadata;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--we were asked to delete all data for movies that where not included in the movies_metadata table

--In order to do that we created an immediate table by joining links with movies_metadata, such that movies that 
--where not included in the movies_metadata table will not also be included  
--in the new_links table. After that we renamed table new_links to links
create table new_links as (select movieId, imdbId, tmdbId from links join movies_metadata ON movies_metadata.id = links.movieId);
drop table links;
ALTER TABLE new_links
RENAME TO links;
---In order to do that we created an immediate table by joining ratings_small with movies_metadata, such that movies that 
--where not included in the movies_metadata table will not also be included  
--in the new_ratings_small table. After that we renamed table new_ratings_small to ratings_small
create table new_ratings_small as (select userId, movieId, rating, timestamp from ratings_small join movies_metadata ON movies_metadata.id = ratings_small.movieId);
drop table ratings_small;
ALTER TABLE new_ratings_small
RENAME TO ratings_small;
---In order to do that we created an immediate table by joining credits with movies_metadata, such that movies that 
--where not included in the movies_metadata table will not also be included  
--in the new_credits table. After that we renamed table new_credits to credits
create table new_credits as (select movie_cast, crew,  id from credits join movies_metadata ON movies_metadata.id = credits.id);
drop table credits;
ALTER TABLE new_credits
RENAME TO credits;
---In order to do that we created an immediate table by joining keywords with movies_metadata, such that movies that 
--where not included in the movies_metadata table will not also be included  
--in the new_keywords table. After that we renamed table new_keywords to keywords
create table new_keywords as (select keywords.id, keywords from keywords join movies_metadata ON movies_metadata.id = keywords.id);
drop table keywords;
ALTER TABLE new_keywords
RENAME TO keywords;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--add primary keys in all tables
ALTER TABLE credits
ADD PRIMARY KEY (id);

ALTER TABLE links
ADD PRIMARY KEY (movieId);

ALTER TABLE keywords
ADD PRIMARY KEY (id);

ALTER TABLE movies_metadata
ADD PRIMARY KEY (id);

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--add foreign keys in all tables
ALTER TABLE credits
ADD FOREIGN KEY (id) REFERENCES movies_metadata(id);

ALTER TABLE keywords
ADD FOREIGN KEY (id) REFERENCES movies_metadata(id);

ALTER TABLE links
ADD FOREIGN KEY (movieId) REFERENCES movies_metadata(id);

ALTER TABLE ratings_small
ADD FOREIGN KEY (movieId) REFERENCES movies_metadata(id);
