--Query 1
CREATE INDEX host_id_index_for_listing ON "Listing"(host_id);
DROP INDEX host_id_index_for_listing;

--Query 2
CREATE INDEX guests_included_and_price_index_for_price ON "Price"(guests_included,price);
DROP INDEX guests_included_and_price_index_for_price;

--Query 3
CREATE INDEX location_info_index ON "Location"(state, zipcode);
DROP INDEX location_info_index;

--Query 4
CREATE INDEX price_index ON "Room"(price);
DROP INDEX price_index;

--Query 5
CREATE INDEX calculated_host_listings_count_index ON "Host"(calculated_host_listings_count);
DROP INDEX calculated_host_listings_count_index;

--Query 6
CREATE INDEX has_availability_index ON "Listing"(has_availability);
DROP INDEX has_availability_index;

--Query 7
CREATE INDEX city_and_street_index ON "Location"(city,street);
CREATE INDEX description_index ON "Listing"(description);
DROP INDEX city_and_street_index;
DROP INDEX description_index;