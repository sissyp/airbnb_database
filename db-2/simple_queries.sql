set client_encoding to 'utf8';

/*1)Find all houses'names , which had been rented on 18/3/2020 by a host, whose id is equal to
37177
Output: 6 rows*/
SELECT name, host_id
FROM "Listings"
JOIN "Calendar"
ON "Listings".id="Calendar".listing_id
WHERE host_id=37177
	AND date='2020-03-18';

/*2)Find the maximum number of minimum nights and the minimum number of maximum nights
for each person who is named Emmanouil and had a house rented at the neighbourhood Γκύζη
Output:1 row*/
SELECT max(minimum_nights),min(maximum_nights)
FROM "Listings"
JOIN "Neighbourhoods"
ON "Listings".neighbourhood_cleansed="Neighbourhoods".neighbourhood
WHERE host_name='Emmanouil'
	AND "Neighbourhoods".neighbourhood='ΓΚΥΖΗ';
	
/*3)Find all the different pairs of reviewers' name, which contain the string "ali"
and reviews' date, whose number of reviews is greater than 3.
Output:3407 rows */  	
SELECT DISTINCT reviewer_name,date
FROM "Reviews"
JOIN "Listings"
ON "Listings".id="Reviews".listing_id
WHERE reviewer_name LIKE '%ali%' 
	AND number_of_reviews>3;


/*4)For each host's name find the total number of beds and bedrooms and show them in a
descending order of bedrooms.
Output:2678 rows */
SELECT COUNT(beds),COUNT(bedrooms),host_name
FROM "Listings"
GROUP BY host_name
ORDER BY COUNT(bedrooms) DESC;

/*5)Find the first 10 neighbourhoods with geometry_coordinates_0_0_0_0 greater than 23.742509
and show their type, geometry type and their name ordered by geometry_coordinates_0_0_0_0
Output:10 rows (using LIMIT)
Output:19 rows (without using LIMIT) */
SELECT type, geometry_type,properties_neighbourhood,CAST(geometry_coordinates_0_0_0_0 AS FLOAT
FROM "Geolocation"
WHERE CAST(geometry_coordinates_0_0_0_0 AS FLOAT)>23.742509
ORDER BY CAST(geometry_coordinates_0_0_0_0 AS FLOAT)
LIMIT 10;

/*6)Find all reviewers' names with reviews written in the year 2020 and after with score rating 
between 80 and 90 and show their names, their comments, the date that the review was written
and the rate of their review ordered by date
Output:1508 rows */
SELECT reviewer_name,comments,date,CAST(review_scores_rating AS INT)
FROM "Reviews"
JOIN "Listings"
ON "Listings".id="Reviews".listing_id
WHERE "Reviews".date>'2020-01-01'
	AND CAST(review_scores_rating AS INT) BETWEEN 80 AND 90
ORDER BY date;

/*7)Find the average number of houses that are available 30,60,90 and 365 days ,which are
available now and their price is equal to $20.00
output:1 row*/ 
SELECT AVG(availability_30),AVG(availability_60),AVG(availability_90),AVG(availability_365) 
FROM "Listings"
JOIN "Calendar"
ON "Listings".id="Calendar".listing_id
WHERE "Calendar".price='$20.00'
	AND has_availability=TRUE;
	
/*8)Join Calendar and Listings tables and show the first 50 prices, streets, cities and name of 
a house for all houses with price equal to $30.00(because the outer join returns some null values we
do not include them in the final result)
Output:50 rows (using LIMIT)
Output:199785 rows (without using LIMIT) */
SELECT "Calendar".price,"Listings".name,"Listings".street,"Listings".city
FROM "Calendar"
LEFT OUTER JOIN "Listings" 
ON "Listings".id = "Calendar".listing_id
WHERE not ("Calendar".price is NULL) AND not ("Listings".street is NULL) 
AND not ("Listings".city is NULL) AND "Calendar".price='$30.00'
LIMIT 50;

/*9)Find all available houses with 3 beds , where guests can be included and show 
the number of beds and guests included 
Output:438475 rows */
SELECT guests_included, beds
FROM "Listings"
JOIN "Calendar"
ON "Listings".id="Calendar".listing_id
WHERE available=TRUE 
AND beds=3;

/*10)Find different all pictures and descriptions of the houses for all reviewers' comments that contain 
the string great 
Output:7046 rows */
SELECT DISTINCT picture_url, description
FROM "Listings"
JOIN "Reviews"
ON "Listings".id="Reviews".listing_id
WHERE comments LIKE '%great%'; 

/*11)Find some information(host_name,host_since,host_location, host_about about hosts)
 and show these information for 
every host who had a house rented at neighbourhood Αμπελόκηποι
Output:309 rows */
SELECT DISTINCT host_name,host_since,host_location, host_about
FROM "Listings"
JOIN "Neighbourhoods"
ON "Listings".neighbourhood_cleansed="Neighbourhoods".neighbourhood
WHERE "Neighbourhoods".neighbourhood='ΑΜΠΕΛΟΚΗΠΟΙ';

/*12)Find some information about reviewers , whose review's accuracy is equal to 10, which 
means that their reviews are accurate. Show the results(reviewer_id,reviewer_name,first_review, 
last_review,review_scores_accuracy) ordered by the reviewer's name
(because the outer join returns some null values we do not include them in the final result)
Output: 349980 rows */
SELECT DISTINCT reviewer_id,reviewer_name,first_review ,last_review,review_scores_accuracy  
FROM "Listings"
FULL OUTER JOIN "Reviews"
ON "Listings".id="Reviews".listing_id
WHERE not(reviewer_id is NULL) AND not(reviewer_name is NULL) AND not (first_review is NULL)
AND not (last_review is NULL) AND not(review_scores_accuracy is NULL) 
AND review_scores_accuracy='10'
ORDER BY reviewer_id;


