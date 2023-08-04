INSERT
	INTO
	public.salestypes(sales_type_name)
VALUES ('Rent');

INSERT
	INTO
	public.sales(sales_type_id,
	vehicle_id,
	employee_id,
	dealership_id,
	price,
	invoice_number)
VALUES (3,
21,
12,
7,
55999,
123477289)

INSERT
	INTO
	public.sales(sales_type_id,
	vehicle_id,
	employee_id,
	dealership_id,
	price,
	invoice_number)
VALUES 
(3,
21,
12,
7,
55999,
123477289),
(3,
14,
3,
7,
19999,
232727349),
(3,
6,
75,
7,
39500,
8635482010);

DELETE
FROM
	public.sales
WHERE
	sale_id = 5001;

INSERT
	INTO
	public.customers(first_name,
	last_name,
	email,
	phone,
	street,
	city,
	state,
	zipcode,
	company_name,
	phone_number)
VALUES 
('Akshay',
'Khona',
'ak@ak.ak',
'cell',
'123 Fourth St',
'Nashville',
'TN',
'56789',
'Firgon',
'1234567890'),
('Chris',
'Olivarez',
'chris@chris.chris',
'cell',
'567 Eighth St',
'Nashville',
'TN',
'11111',
'JAG Resources',
'1222323233');

INSERT
	INTO
	public.vehicletypes(body_type,
	make,
	model)
VALUES
('Truck',
'Toyota',
'Tacoma TRD Off-Road');

INSERT
	INTO
	public.vehicles
(vin,
	engine_type,
	vehicle_type_id,
	exterior_color,
	interior_color,
	floor_price,
	msr_price,
	miles_count,
	year_of_car,
	is_sold,
	is_new,
	dealership_location_id)
VALUES 
('5HGCM82633A123456',
'V6',
31,
'red',
'black/grey',
30995,
37995,
50100,
2015,
TRUE,
FALSE,
31);

INSERT
	INTO
	public.employees(first_name,
	last_name,
	email_address,
	phone,
	employee_type_id)
VALUES 
('Kennie',
'Maharg',
'kmaharge@com.com',
'598-678-4885',
4)

INSERT
	INTO
	public.dealershipemployees(dealership_id,
	employee_id)
VALUES 
(1,
1001),
(2,
1001),
(3,
1001);
