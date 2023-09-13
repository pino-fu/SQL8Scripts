-- Who are the top 5 employees for generating sales income?
-- needs work 
SELECT 
	e.first_name ||' '|| e.last_name "Employee",
	sum(s.price) AS cheetos
FROM sales s
LEFT JOIN employees e
ON s.employee_id = e.employee_id 
GROUP BY "Employee"
ORDER BY cheetos DESC
LIMIT 5;

-- Timary below 
SELECT
	e.first_name ||' '|| e.last_name "Employee",
	'$' || TO_CHAR(SUM(s.price), 'FM999,999.00') AS "Total Revenue",
	sum(s.price)
FROM sales s
LEFT JOIN employees e 
	ON s.employee_id = e.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY "Total Revenue" DESC
LIMIT 5;

-- Who are the top 5 dealership for generating sales income?
SELECT 
	d.business_name,
	sum(s.price) AS total_sales
FROM sales s
LEFT JOIN dealerships d
ON s.dealership_id = d.dealership_id
GROUP BY d.business_name 
ORDER BY total_sales DESC
LIMIT 5;

-- Which vehicle model generated the most sales income?
SELECT DISTINCT 
	vt.make,
	vt.model, 
	sum(s.price) over(PARTITION BY s.vehicle_id)
FROM vehicles v
JOIN vehicletypes vt 
ON vt.vehicle_type_id = v.vehicle_type_id 
JOIN sales s 
ON s.vehicle_id = v.vehicle_id
AND s.sales_type_id = 1
GROUP BY vt.make, vt.model, s.price, s.vehicle_id 
ORDER BY sum(s.price) over(PARTITION BY s.vehicle_id) DESC;

-- Which employees generate the most income per dealership?
WITH employee_sales AS (
	SELECT 
		e.employee_id,
		e.first_name || ' ' || e.last_name AS employee_name,
		s.dealership_id,
		sum(s.price) AS total_sales
	FROM employees e
	JOIN sales s
	ON s.employee_id = e.employee_id 
	GROUP BY s.dealership_id , e.employee_id, e.first_name, e.last_name
), top_employee_sales AS (
	SELECT 
		dealership_id, 
		max(total_sales) AS max_sales
	FROM employee_sales
	GROUP BY dealership_id
)
SELECT 
	d.business_name,
	es.employee_name,
	tes.max_sales AS employee_sales
FROM top_employee_sales tes
JOIN employee_sales es
ON es.dealership_id = tes.dealership_id
AND es.total_sales = tes.max_sales
JOIN dealerships d 
ON d.dealership_id = tes.dealership_id;

-- In our Vehicle inventory, show the count of each Model that is in stock.
SELECT 
	vt.make, 
	vt.model,
	count(vt.vehicle_type_id = v.vehicle_type_id AND v.is_sold = FALSE)
FROM vehicles v
JOIN vehicletypes vt
ON vt.vehicle_type_id = v.vehicle_type_id
GROUP BY vt.make, vt.model;

-- In our Vehicle inventory, show the count of each Make that is in stock.
SELECT 
    vt.make,
    COUNT(v.vehicle_type_id) AS in_stock_count
FROM vehicletypes vt
JOIN vehicles v
ON vt.vehicle_type_id = v.vehicle_type_id
WHERE v.is_sold = False
GROUP BY vt.make;

-- In our Vehicle inventory, show the count of each BodyType that is in stock.
SELECT 
    vt.body_type,
    COUNT(v.vehicle_type_id) AS in_stock_count
FROM vehicletypes vt
JOIN vehicles v
ON vt.vehicle_type_id = v.vehicle_type_id
WHERE v.is_sold = False
GROUP BY vt.body_type;

-- Which US state's customers have the highest average purchase price for a vehicle?
SELECT DISTINCT 
	c.state,
	avg(s.price) OVER (PARTITION BY c.state)
FROM customers c 
JOIN sales s
ON s.customer_id = c.customer_id 
AND s.sales_type_id = 1
GROUP BY c.state, s.price, c.state 
ORDER BY avg(s.price) OVER (PARTITION BY c.state) DESC
LIMIT 1;

-- Now using the data determined above, which 5 states have the customers with the highest average purchase price for a vehicle?
SELECT DISTINCT 
	c.state,
	avg(s.price) OVER (PARTITION BY c.state)
FROM customers c 
JOIN sales s
ON s.customer_id = c.customer_id 
AND s.sales_type_id = 1
GROUP BY c.state, s.price, c.state 
ORDER BY avg(s.price) OVER (PARTITION BY c.state) DESC
LIMIT 5;


ALTER TABLE sales 
ADD CONSTRAINT fk_sales_employee_id
	FOREIGN KEY (employee_id)
	REFERENCES employees (employee_id)
	ON DELETE NO ACTION;

