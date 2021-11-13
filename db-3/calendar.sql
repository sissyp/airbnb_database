UPDATE  "Calendar"
SET 
price = REPLACE(price,'$',''),
adjusted_price = REPLACE(adjusted_price,'$','');

UPDATE  "Calendar"
SET 
price = REPLACE(price,',',''),
adjusted_price = REPLACE(adjusted_price,',','');


ALTER TABLE "Calendar" 
alter column  price TYPE FLOAT using price::float,
alter column adjusted_price TYPE FLOAT using adjusted_price::float,
alter column available TYPE BOOLEAN ;