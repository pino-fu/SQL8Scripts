--Carnival would also like to handle the case for when a car gets returned by a customer. When this occurs they must add the car back to the inventory and mark the original sales record as sale_returned = TRUE.

--Carnival staff are required to do an oil change on the returned car before putting it back on the sales floor. In our stored procedure, we must also log the oil change within the OilChangeLogs table.

--Build two stored procedures for Selling a car and Returning a car. Be ready to share with your class or instructor your result.

--Example SP...
--CREATE PROCEDURE insert_data(IN a varchar, INOUT b varchar)
--LANGUAGE plpgsql
--AS $$
--BEGIN
--
--INSERT INTO tbl(col) VALUES (a);
--INSERT INTO tbl(col) VALUES (b);
--
--END
--$$;

--set is_sold to TRUE
CREATE PROCEDURE sell_car(IN varVehicle_id integer)
LANGUAGE plpgsql
AS $$ 
BEGIN 
	UPDATE vehicles 
	SET is_sold = TRUE
	WHERE vehicle_id = varVehicle_id;
END
$$;

--set vehicle.is_sold to FALSE
--set sale.sale_returned to TRUE
--create oil change record 
CREATE PROCEDURE return_car(IN varVehicle_id integer)
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE vehicles 
		SET is_sold = FALSE
		WHERE vehicle_id = varVehicle_id;
	UPDATE sales 
		SET sale_returned = TRUE 
		WHERE vehicle_id = varVehicle_id;
	INSERT INTO (date_occured, vehicle_id, repair_type_id)
	VALUES(CURRENT_DATE, varVehicle_id, 2);
END
$$;



--TRIGGERS


--Create a trigger for when a new Sales record is added, set the purchase date to 3 days from the current date.
CREATE FUNCTION set_pickup_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  UPDATE sales
  SET pickup_date = NEW.purchase_date + integer '3'
  WHERE sales.sale_id = NEW.sale_id;
  
  RETURN NULL;
END;
$$

CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE set_pickup_date();

INSERT INTO sales (sales_type_id, vehicle_id, employee_id, customer_id,dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method, sale_returned)
VALUES (2, 69, 34, 44, 4, 23442, 3224, current_date, current_date , '2232323233', 'mastercard', false);

--Create a trigger for updates to the Sales table. If the pickup date is on or before the purchase date, set the pickup date to 7 days after the purchase date. If the pickup date is after the purchase date but less than 7 days out from the purchase date, add 4 additional days to the pickup date.
CREATE FUNCTION set_pickup_date_on_update()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
AS $$
BEGIN 	
	IF NEW.pickup_date <= NEW.purchase_date THEN 
	NEW.pickup_date := NEW.purchase_date
END


















