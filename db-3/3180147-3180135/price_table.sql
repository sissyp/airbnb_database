create table "Price"
AS (SELECT id as listing_id, cleaning_fee,
guests_included, extra_people, minimum_nights, maximum_nights,
minimum_minimum_nights, maximum_minimum_nights, minimum_maximum_nights,
maximum_maximum_nights, minimum_nights_avg_ntm, maximum_nights_avg_ntm ,
price, weekly_price, monthly_price, security_deposit FROM "Listings" JOIN "Room" 
ON "Room".listing_id="Listings".id);

UPDATE  "Price"
SET 
price = REPLACE(price,'$',''),
weekly_price = REPLACE(weekly_price,'$',''),
monthly_price = REPLACE(monthly_price,'$',''),
security_deposit = REPLACE(security_deposit,'$',''),
cleaning_fee = REPLACE(cleaning_fee,'$',''),
extra_people=REPLACE(extra_people,'$','');

UPDATE  "Price"
SET 
price = REPLACE(price,',',''),
weekly_price = REPLACE(weekly_price,',',''),
monthly_price = REPLACE(monthly_price,',',''),
security_deposit = REPLACE(security_deposit,',',''),
cleaning_fee = REPLACE(cleaning_fee,',',''),
extra_people=REPLACE(extra_people,',','');

ALTER TABLE "Price" 
alter column price TYPE MONEY using price::money,
alter column weekly_price TYPE MONEY using weekly_price::money,
alter column monthly_price TYPE MONEY using monthly_price::money,
alter column security_deposit TYPE MONEY using security_deposit::money,
alter column cleaning_fee TYPE MONEY using cleaning_fee::money,
alter column extra_people TYPE MONEY using extra_people::money,
alter column minimum_nights_avg_ntm TYPE FLOAT using minimum_nights_avg_ntm::float,
alter column maximum_nights_avg_ntm TYPE FLOAT using maximum_nights_avg_ntm::float;

ALTER TABLE "Price" 
ADD FOREIGN  KEY (listing_id) REFERENCES "Listings"(id);

ALTER TABLE "Listings" 
    DROP COLUMN cleaning_fee,
	DROP COLUMN guests_included, 
	DROP COLUMN extra_people,
	DROP COLUMN	minimum_nights,
	DROP COLUMN	maximum_nights,
	DROP COLUMN minimum_minimum_nights, 
	DROP COLUMN maximum_minimum_nights, 
	DROP COLUMN minimum_maximum_nights,
	DROP COLUMN maximum_maximum_nights,
    DROP COLUMN	minimum_nights_avg_ntm,
    DROP COLUMN	maximum_nights_avg_ntm;