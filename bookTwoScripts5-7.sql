/*Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.*/
SELECT
	d.business_name AS dealership,
	count(s.sales_type_id)
										FILTER (
WHERE
	s.sales_type_id = 1) AS Lease,
						count(s.sales_type_id)
										FILTER (
WHERE
	s.sales_type_id = 2) AS Purchase
FROM
	dealerships d
LEFT JOIN sales s 
ON
	s.dealership_id = d.dealership_id
GROUP BY
	d.business_name
ORDER BY 
	d.business_name;

/*Produce a report that determines the most popular vehicle model that is leased.*/
SELECT 
    vt.model, count(v.vehicle_type_id) 
AS 
	sales_count
FROM 
	sales s
LEFT JOIN 
	vehicles v 
ON 
	v.vehicle_id = s.vehicle_id
LEFT JOIN 
	vehicletypes vt 
ON 
	vt.vehicle_type_id = v.vehicle_type_id
WHERE 
	s.sales_type_id = 2
GROUP BY 
	vt.model
ORDER BY 
	sales_count 
DESC 
LIMIT 
	1;
	
-- What is the most popular vehicle make in terms of number of sales?
SELECT 
    vt.model, count(v.vehicle_type_id) 
AS 
	sales_count
FROM 
	sales s
LEFT JOIN 
	vehicles v 
ON 
	v.vehicle_id = s.vehicle_id
LEFT JOIN 
	vehicletypes vt 
ON 
	vt.vehicle_type_id = v.vehicle_type_id
WHERE 
	s.sales_type_id = 1
GROUP BY 
	vt.model
ORDER BY 
	sales_count 
DESC 
LIMIT 
	1;

-- Which employee type sold the most of that make?
SELECT 
	et.employee_type_name
FROM 
	employees e
LEFT JOIN
	employeetypes et 
ON 
	et.employee_type_id = e.employee_type_id 
LEFT JOIN 
	sales s  
ON 
	s.employee_id = e.employee_id 
LEFT JOIN 
	vehicles v 
ON 
	v.vehicle_id = s.vehicle_id 
LEFT JOIN 
	vehicletypes vt 
ON 
	vt.vehicle_type_id = v.vehicle_type_id 
LEFT JOIN 
	salestypes st
ON 
	st.sales_type_name = 'Purchase'
GROUP BY 
	et.employee_type_name  
ORDER BY
	count
		(vt.make = 'Nissan') 
DESC 
LIMIT 1;

-- Insert some oilchangelogs into the database.
insert into oilchangelogs
	(date_occured, vehicle_id)
values
	('2020-01-09', 1),
	('2021-10-30', 2),
	('2019-02-20', 3),
	('2022-03-17', 4);

-- For the top 5 dealerships, which employees made the most sales? *Note: to get a list of the top 5 employees with the associated dealership, you will need to use a Windows function (next chapter). There are other ways you can interpret this query to not return that strict of data.
WITH top5dealerships AS
(
	SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC
	LIMIT 5
), topemployees AS
(
	SELECT 
		e.employee_id,
		e.first_name || ' ' || e.last_name AS employee_name,
		s.dealership_id,
		sum(s.price) AS employee_sales
	FROM sales s
	JOIN employees e 
	ON e.employee_id = s.employee_id 
	GROUP BY s.dealership_id, e.employee_id, e.first_name, e.last_name
)
SELECT 
	t.business_name,
	te.employee_name,
	te.employee_sales
FROM top5dealerships t
JOIN 
	(
		SELECT dealership_id, MAX(employee_sales) AS max_sales
		FROM topemployees
		GROUP BY dealership_id
	) max_sales
ON 
	t.dealership_id = max_sales.dealership_id
JOIN topemployees te
ON te.dealership_id = max_sales.dealership_id
AND te.employee_sales = max_sales.max_sales
ORDER BY t.total_sales DESC, te.employee_sales DESC;

-- For the top 5 dealerships, which vehicle models were the most popular in sales?
WITH top5dealerships AS
(
	SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC
	LIMIT 5
)
SELECT 
	t5.business_name,
	vt.make, 
	vt.model,
	 count(vt.vehicle_type_id = v.vehicle_type_id) 
FROM top5dealerships t5
JOIN sales s 
ON s.dealership_id = t5.dealership_id
JOIN vehicles v
ON v.vehicle_id = s.vehicle_id 
JOIN vehicletypes vt 
ON vt.vehicle_type_id = v.vehicle_type_id 
GROUP BY t5.business_name, vt.make, vt.model
ORDER BY count(vt.vehicle_type_id = v.vehicle_type_id) DESC 
LIMIT 5;

-- For the top 5 dealerships, were there more sales or leases?
WITH top5dealerships AS
(
	SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC
	LIMIT 5
)
SELECT 
	t5.business_name,
	count(st.sales_type_name = 'Purchase') AS purchases,
	count(st.sales_type_name = 'Lease') AS leases,
	count(st.sales_type_name = 'Rentals') AS rentals
FROM top5dealerships t5
JOIN sales s 
ON s.dealership_id = t5.dealership_id
JOIN salestypes st 
ON st.sales_type_id = s.sales_type_id 
GROUP BY t5.business_name;



-- For all used cars, which states sold the most? The least?

-- For all used cars, which model is greatest in the inventory? Which make is greatest in the inventory? 



