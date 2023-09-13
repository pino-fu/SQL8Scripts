/*
Creating Carnival Reports
As Carnival grows, we have been asked to help solve two issues:
​
It has become more and more difficult for the accounting department to keep track of the all the records in the sales table and how much money came in from each sale.
​
HR currently has an overflowing filing cabinet with files on each employee. There's additional files for each dealership. Sorting through all these files when new employees join Carnival and current employees leave is a process that needs to be streamlined. All employees that start at Carnival are required to work shifts at at least two dealerships.
​
Goals
Using CREATE to add new tables
Using triggers
Using stored procedures
Using transactions
Practice
*/
​
​
/*Provide a way for the accounting team to track all financial transactions by creating a new table called Accounts Receivable. The table should have the following columns: credit_amount, debit_amount, date_received as well as a PK and a FK to associate a sale with each transaction.*/
​
CREATE TABLE accounts_receivable (
    ar_id SERIAL PRIMARY KEY,
    credit_amount NUMERIC(15,2),
    debit_amount NUMERIC(15,2),
    date_received DATE DEFAULT CURRENT_DATE,
    sale_id INT,
	FOREIGN KEY(sale_id) REFERENCES sales(sale_id)
);
​
/*Set up a trigger on the Sales table. When a new row is added, add a new record to the Accounts Receivable table with the deposit as credit_amount, the timestamp as date_received and the appropriate sale_id.*/
​
CREATE OR REPLACE FUNCTION new_sale()
RETURNS TRIGGER
LANGUAGE plpgsql AS
$$
BEGIN	
	INSERT
	INTO
	accounts_receivable (credit_amount, sale_id)
VALUES (NEW.deposit, NEW.sale_id);
RETURN NEW;
END
$$;
​
CREATE OR REPLACE TRIGGER new_sale_update_ar
AFTER INSERT
ON sales
FOR EACH ROW
EXECUTE PROCEDURE new_sale()
; 
​
-- Testing --
​
INSERT INTO sales (sales_type_id, 
				   vehicle_id, 
				   employee_id, 
				   customer_id,
				   dealership_id, 
				   price, 
				   deposit, 
				   purchase_date, 
				   pickup_date, 
				   invoice_number, 
				   payment_method, 
				   sale_returned)
VALUES (
	2, 69, 34, 44, 4, 23442, 3224, current_date, current_date , '2232323233', 'mastercard', false);
​
SELECT * FROM accounts_receivable;
​
/*Set up a trigger on the Sales table for when the sale_returned flag is updated. Add a new row to the Accounts Receivable table with the deposit as debit_amount, the timestamp as date_received, etc.*/
​
CREATE OR REPLACE FUNCTION sale_return()
RETURNS TRIGGER
LANGUAGE plpgsql AS
$$
BEGIN
	 UPDATE accounts_receivable
	 SET debit_amount = sales.deposit
	 FROM sales
	 WHERE accounts_receivable.sale_id = sales.sale_id;
	 RETURN NEW;
END
$$;
​
CREATE OR REPLACE TRIGGER returning_sale
AFTER UPDATE
ON sales
FOR EACH ROW
EXECUTE PROCEDURE sale_return()
;
​
SELECT * FROM sales ORDER BY sale_id DESC
​
SELECT * FROM accounts_receivable;
​
/*Create a stored procedure with a transaction to handle hiring a new employee. Add a new record for the employee in the Employees table and add a record to the Dealershipemployees table for the two dealerships the new employee will start at.*/
CREATE OR REPLACE PROCEDURE add_employee_to_dealership()
LANGUAGE PLPGSQL
AS $$
DECLARE 
	NewEmployeeId integer; 

BEGIN 
	INSERT INTO employees (first_name, last_name, email_address, phone, employee_type_id)
	VALUES ('John', 'Doe', 'jon@doe.com', '234-343-3433', 1)
		RETURNING employee_id INTO NewEmployeeId;
COMMIT;
	INSERT INTO dealershipemployees (dealership_id, employee_id)
	VALUES (2, NewEmployeeId), (2, NewEmployeeId);
COMMIT;
END
$$;

CALL add_employee_to_dealership();

SELECT * FROM dealershipemployees d ORDER BY dealership_employee_id DESC;
SELECT * FROM employees e ORDER BY e.employee_id DESC;

/*Create a stored procedure with a transaction to handle an employee leaving. The employee record is removed and all records associating the employee with dealerships must also be removed.*/

CREATE OR REPLACE PROCEDURE remove_employee(IN EmployeeId INT)
LANGUAGE plpgsql
AS $$
  
BEGIN
    DELETE FROM dealershipemployees de WHERE de.employee_id = EmployeeId;
   
    DELETE FROM accounts_receivable WHERE sale_id IN (SELECT sale_id FROM sales WHERE employee_id = EmployeeId);

    DELETE FROM sales s WHERE s.employee_id = EmployeeId;
    
    DELETE FROM employees e WHERE e.employee_id = EmployeeId;
    
COMMIT;

END;
$$;


CALL remove_employee(1001);

SELECT * FROM dealershipemployees d ORDER BY dealership_employee_id DESC;
SELECT * FROM employees e ORDER BY e.employee_id DESC;
SELECT * FROM sales s ORDER BY s.sale_id DESC;







