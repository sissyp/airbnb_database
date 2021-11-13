/*1)Find some information about a neighbourhood such as street, city, state and zipcode
ordered by properties_neighbourhood.(because the outer join returns some null values we
do not include them in the final result)
Output:1840 rows*/
SELECT properties_neighbourhood,street, city, state, zipcode
FROM "Location"
FULL OUTER JOIN "Geolocation"
ON neighbourhood_cleansed=properties_neighbourhood
WHERE not (street is NULL) AND not (state is NULL) 
AND not (city is NULL) AND not (zipcode is NULL) AND not (properties_neighbourhood is NULL)
ORDER BY properties_neighbourhood;

/*2)For each house with price equal to $30.00 that includes more than 10 amenities 
find how many amenities are included and show them in a descending order.
Output:577 rows*/
SELECT "Connection".listing_id,COUNT(amenity_id)
FROM "Connection"
JOIN "Room"
ON "Connection".listing_id="Room".listing_id
WHERE "Room".price='$30.00'
GROUP BY "Connection".listing_id
HAVING COUNT(amenity_id)>10
ORDER BY count(amenity_id) DESC;

/*3)Find some information about the first 100 hosts with more than 3 listings 
Output:473 rows (without using limit)
Output:100(using limit)*/
SELECT id,COUNT(calculated_host_listings_count),COUNT(calculated_host_listings_count_entire_homes),
COUNT(calculated_host_listings_count_private_rooms),COUNT(calculated_host_listings_count_shared_rooms)
FROM "Host"
JOIN "Listing"
ON "Host".id="Listing".host_id
Group by "Host".id
HAVING COUNT(calculated_host_listings_count)>3
LIMIT 100;

/*4)Find how many guests can be included and how much should be paid for each one if the house is
available and show them in a descending order
Output:11541 rows*/
SELECT extra_people,guests_included,has_availability
FROM "Price"
JOIN "Listing"
ON "Price".listing_id="Listing".id
WHERE has_availability=TRUE
ORDER BY guests_included DESC;

/*5)For each house description that contains the word great find the picture url,
the street and the city(because the outer join returns some null values we
do not include them in the final result)
Output:1226 rows*/
SELECT "Listing".description,"Listing".picture_url,"Location".street,"Location".city
FROM "Listing"
LEFT OUTER JOIN "Location" 
ON "Listing".id = "Location".listing_id
WHERE not ("Location".street is NULL) AND not ("Location".city is NULL) 
AND description LIKE '%great%';
