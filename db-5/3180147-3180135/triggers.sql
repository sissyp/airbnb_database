CREATE FUNCTION update_listings_count()
  RETURNS trigger AS
$$ BEGIN
IF (TG_OP = 'DELETE') THEN
 UPDATE "Host"
 SET listings_count = listings_count - 1
 WHERE id = OLD.host_id;
 RETURN OLD;
ELSIF (TG_OP = 'INSERT') THEN
 UPDATE "Host"
 SET listings_count = listings_count + 1
 WHERE id = NEW.host_id;
 RETURN NEW;
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER listings_count_changes 
AFTER DELETE OR INSERT 
ON "Listing"
FOR EACH ROW
EXECUTE PROCEDURE update_listings_count();

/*when a row in table review is deleted, table listing is updated by decreasing the number of
reviews. Also, when a row in table review is inserted, table listing is updated by increasing the
number of reviews. In both cases column number of reviews is being altered.*/

CREATE FUNCTION update_review_number()
  RETURNS trigger AS
$$ BEGIN
IF (TG_OP = 'DELETE') THEN
 UPDATE "Listing"
 SET number_of_reviews = number_of_reviews - 1
 WHERE id = OLD.listing_id;
 RETURN OLD;
ELSIF (TG_OP = 'INSERT') THEN
 UPDATE "Listing"
 SET number_of_reviews = number_of_reviews + 1
 WHERE id = NEW.listing_id;
 RETURN NEW;
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER review_number_changes 
AFTER DELETE OR INSERT 
ON "Review"
FOR EACH ROW
EXECUTE PROCEDURE update_review_number();
