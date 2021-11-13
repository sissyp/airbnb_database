create table "Amenity" as (select distinct unnest(amenities::text[]) as amenity_name from "Room");

UPDATE "Amenity"
SET 
amenity_name = REPLACE(REPLACE(REPLACE(REPLACE(amenity_name,'{',''),'}',''),'"',''),',','');

ALTER TABLE "Amenity"
ADD COLUMN amenity_id SERIAL PRIMARY KEY;

ALTER TABLE "Amenity"
alter column amenity_name TYPE varchar using amenity_name::varchar

CREATE TABLE "Connection" AS
(SELECT DISTINCT current.listing_id , "Amenity".amenity_id as amenity_id from "Amenity",
   (SELECT "Room".listing_id as listing_id, unnest(amenities::text[]) as amenity_name from "Room" ) AS current
  where current.amenity_name = "Amenity".amenity_name);

ALTER TABLE "Connection"
ADD PRIMARY KEY(listing_id, amenity_id);

ALTER TABLE "Room"
ADD PRIMARY KEY (listing_id);

ALTER TABLE "Connection"
add foreign key(listing_id) REFERENCES "Room"(listing_id),
add foreign key(amenity_id) REFERENCES "Amenity"(amenity_id);

ALTER TABLE "Room"
DROP COLUMN amenities;