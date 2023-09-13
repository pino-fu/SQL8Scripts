-- Write a query that shows the total purchase sales income per dealership.
SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC;

-- Write a query that shows the purchase sales income per dealership for July of 2020.
SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	AND EXTRACT(MONTH FROM purchase_date) = 7
	AND EXTRACT(YEAR FROM purchase_date) = 2020
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC;

-- Write a query that shows the purchase sales income per dealership for all of 2020.
SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	AND s.sales_type_id = 1
	AND EXTRACT(YEAR FROM purchase_date) = 2020
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC;

-- Write a query that shows the total lease income per dealership.
SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	AND s.sales_type_id = 2
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC;

-- Write a query that shows the lease income per dealership for Jan of 2020.
SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	AND s.sales_type_id = 2
	AND EXTRACT(YEAR FROM purchase_date) = 2020
	AND EXTRACT(MONTH FROM purchase_date) = 1
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC;

-- Write a query that shows the lease income per dealership for all of 2019.
SELECT 
		d.dealership_id,
		d.business_name,
		sum(s.price) AS total_sales
	FROM dealerships d 
	JOIN sales s
	ON s.dealership_id = d.dealership_id
	AND s.sales_type_id = 2
	AND EXTRACT(YEAR FROM purchase_date) = 2019
	GROUP BY d.dealership_id, d.business_name 
	ORDER BY total_sales DESC;

--Write a query that shows the total income (purchase and lease) per employee.
























