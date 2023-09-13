--Kristopher Blumfield an employee of Carnival has asked to be transferred to a different dealership location. She is currently at dealership 9. She would like to work at dealership 20. Update her record to reflect her transfer.
UPDATE dealershipemployees de
SET dealership_id = 20
FROM employees e
WHERE e.first_name = 'Kristopher' 
AND e.last_name = 'Blumfield' 
AND de.employee_id = e.employee_id;

--A Sales associate needs to update a sales record because her customer want to pay with a Mastercard instead of JCB. Update Customer, Ernestus Abeau Sales record which has an invoice number of 9086714242.
UPDATE sales
SET payment_method = 'Mastercard'
WHERE invoice_number = '9086714242';

--A sales employee at carnival creates a new sales record for a sale they are trying to close. The customer, last minute decided not to purchase the vehicle. Help delete the Sales record with an invoice number of '2436217483'.
DELETE FROM sales 
WHERE invoice_number = '2436217483';

--An employee was recently fired so we must delete them from our database. Delete the employee with employee_id of 35. What problems might you run into when deleting? How would you recommend fixing it?
ALTER TABLE sales 
DROP CONSTRAINT fk_sales_employee_id;


ALTER TABLE sales 
ADD CONSTRAINT fk_sales_employee_id
	FOREIGN KEY (employee_id)
	REFERENCES employees (employee_id)
	ON DELETE NO ACTION;

ALTER TABLE dealershipemployees 
DROP CONSTRAINT dealershipemployees_employee_id_fkey;

ALTER TABLE dealershipemployees 
ADD CONSTRAINT dealershipemployees_employee_id_fkey
	FOREIGN KEY (employee_id)
	REFERENCES employees (employee_id)
	ON DELETE CASCADE; 

ALTER TABLE sales 
DROP CONSTRAINT sales_employee_id_fkey;

ALTER TABLE sales 
DROP CONSTRAINT fk_sales_employee_id;

DELETE FROM employees 
WHERE employee_id = 35;

