
/* Write a query that returns the business name, city, state, and website for each dealership. Use an alias for the Dealerships table. */
SELECT 
	d.business_name, 
	d.city,
	d.state, 
	d.website
FROM public.dealerships d 

/*Write a query that returns the first name, last name, and email address of every customer. Use an alias for the Customers table.*/
SELECT 
	c.first_name, 
	c.last_name, 
	c.email
FROM customers c 

/*1. Get a list of sales records where the sale was a lease.*/
SELECT 
	price, 
	purchase_date, 
	invoice_number
FROM 
	public.sales
WHERE 
	sales_type_id = 1;
	
/*2. Get a list of sales where the purchase date is within the last five years.*/
SELECT 
	invoice_number,
	purchase_date 
FROM 
	public.sales s
WHERE 
	purchase_date > '2018-08-08';

/*3. Get a list of sales where the deposit was above 5000 or the customer payed with American Express.*/
SELECT 
	invoice_number,
	payment_method,
	price
FROM 
	public.sales 
WHERE 
	deposit > '5000'
OR 
	payment_method = 'americanexpress';

/*4. Get a list of employees whose first names start with "M" or ends with "d".*/
SELECT 
	first_name
FROM 
	public.employees
WHERE 
	first_name LIKE 'M%' 
OR 
	first_name LIKE '%d';

/*5. Get a list of employees whose phone numbers have the 604 area code.*/
SELECT 
	first_name,
	phone 
FROM 
	public.employees
WHERE 
	phone LIKE '604%';

/*Get a list of the sales that were made for each sales type.*/
SELECT 
	s.invoice_number, 
	st.sales_type_name
FROM 
	sales s
LEFT JOIN 
	salestypes st 
ON s.sales_type_id = st.sales_type_id;

/*Get a list of sales with the VIN of the vehicle, the first name and last name of the customer, 
 first name and last name of the employee who made the sale and the name, city and state of the dealership.*/
SELECT 
	s.invoice_number, 
	c.first_name,
	c.last_name, 
	e.first_name,
	e.last_name, 
	d.city,
	d.state
FROM 	
	sales s
INNER JOIN 	
	customers c ON s.customer_id = c.customer_id 
INNER JOIN 	
	employees e ON s.employee_id = e.employee_id 
INNER JOIN 	
	dealerships d ON s.dealership_id = d.dealership_id;

/*Get a list of all the dealerships and the employees, if any, working at each one.*/
SELECT 
	d.business_name,
	d.state,
	e.first_name,
	e.last_name 
FROM
	dealerships d 
LEFT JOIN
	dealershipemployees de ON d.dealership_id = de.dealership_id 
LEFT JOIN 
	employees e ON de.employee_id = e.employee_id;

/*Get a list of vehicles with the names of the body type, make, model and color.*/
SELECT 
	v.exterior_color, 
	vt.make,
	vt.model,
	vt.body_type
FROM 	
	vehicles v
LEFT JOIN 
	vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id;


