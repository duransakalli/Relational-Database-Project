
--					DURAN SAKALLI A01079058 


-- Part A - Database and Tables

/*
   Question 1

   Create a database called Cus_Orders.

*/

USE master
GO

CREATE DATABASE  Cus_Orders
GO

USE Cus_Orders
GO

/*
	Question 2

	2.	Create a user defined data types  for all similar Primary Key attribute columns  (e.g. order_id,  product_id,title_id),
		to ensure the same data type, length and null ability. See pages 12/13 for specifications.
*/

CREATE TYPE cusid FROM char(5) NOT NULL;
CREATE TYPE intid FROM int NOT NULL;
GO

/*
	Question 3

		Create the following tables (see column information on pages 12 and 13 ):

		customers
		orders
		order_details
		products
		shippers
		suppliers
		titles

*/

CREATE TABLE customers 
(
	customer_id cusid,
	name varchar(50) NOT NULL,
	contact_name varchar(30),
	title_id char(3) NOT NULL,
	address varchar(50),
	city varchar(20),
	region varchar(15),
	country_code varchar(10),
	country varchar(15),
	phone varchar(20),
	fax varchar(20)
);

CREATE TABLE orders
(
	order_id intid,
	customer_id cusid,
	employee_id int NOT NULL,
	shipping_name varchar(50),
	shipping_address varchar(50),
	shipping_city varchar(20),
	shipping_region varchar(15),
	shipping_country_code varchar(10),
	shipping_country varchar(15),
	shipper_id int NOT NULL,
	order_date datetime,
	required_date datetime,
	shipped_date datetime,
	freight_charge money
);

CREATE TABLE order_details 
(
	order_id intid,
	product_id intid,
	quantity int NOT NULL,
	discount float NOT NULL
);

CREATE TABLE products
(
	product_id intid,
	supplier_id int NOT NULL,
	name varchar(40) NOT NULL,
	alternate_name varchar(40),
	quantity_per_unit varchar(25),
	unit_price money,
	quantity_in_stock int,
	units_on_order int,
	reorder_level int
);

CREATE TABLE shippers
(
	shipper_id int IDENTITY NOT NULL,
	name varchar(20) NOT NULL
);

CREATE TABLE suppliers
(
	supplier_id int IDENTITY NOT NULL,
	name varchar(40) NOT NULL,
	address varchar(30),
	city varchar(20),
	province char(2)
);

CREATE TABLE titles
(
	title_id char(3) NOT NULL,
	description varchar(35) NOT NULL
);
GO

/*
	Question 4
	Set the primary keys and foreign keys for the tables.
*/

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE shippers
ADD PRIMARY KEY (shipper_id);

ALTER TABLE titles
ADD PRIMARY KEY (title_id);

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE suppliers
ADD PRIMARY KEY (supplier_id);

ALTER TABLE products
ADD PRIMARY KEY (product_id);

ALTER TABLE order_details
ADD PRIMARY KEY (order_id, product_id);

GO

ALTER TABLE customers
ADD CONSTRAINT fk_cust_titles FOREIGN KEY (title_id)
REFERENCES titles(title_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_cust FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_shippers FOREIGN KEY (shipper_id)
REFERENCES shippers(shipper_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_orders FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_products FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE products
ADD CONSTRAINT fk_products_suppliers FOREIGN KEY (supplier_id)
REFERENCES suppliers(supplier_id);

GO

/*
	Question 5

		Set the constraints as follows:

			customers table			- country should default to Canada

			orders table			-  required_date should default to today’s date plus ten days 

			order details table		-  quantity must be greater than or equal to 1

			products table		    -  reorder_level must be greater than or equal to 1
								    -  quantity_in_stock value must not be greater than 150

			suppliers table			-  province should default to BC
*/

ALTER TABLE customers
ADD CONSTRAINT default_country DEFAULT('Canada') FOR country;

ALTER TABLE orders
ADD CONSTRAINT default_required_date DEFAULT(GETDATE() + 10) FOR required_date;

ALTER TABLE order_details
ADD CONSTRAINT min_quant CHECK (quantity >= 1);

ALTER TABLE products
ADD CONSTRAINT min_reorder_level CHECK (reorder_level >= 1);

ALTER TABLE products
ADD CONSTRAINT max_quant_in_stock CHECK (quantity_in_stock < 150);

ALTER TABLE suppliers
ADD CONSTRAINT default_province DEFAULT('BC') FOR province;

GO


/*
	Question 6
	Load the data into your created tables using the following files:
	
		customers.txt		into the customers table		(91 rows)
		orders.txt			into the orders table			(1078 rows)
		order_details.txt	into the order_details table	(2820 rows)
		products.txt		into the products table			(77 rows)
		shippers.txt		into the shippers table			(3 rows)
		suppliers.txt		into the suppliers table		(15 rows)
		titles.txt			into the titles table			(12 rows)
        employees.txt       into the employees table which is created in Part C (See Note)                                                                                                                             

*/

BULK INSERT titles 
FROM 'C:\TextFiles\titles.txt' 
WITH (
               CODEPAGE=1252,                  
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 )

BULK INSERT suppliers 
FROM 'C:\TextFiles\suppliers.txt' 
WITH (  
               CODEPAGE=1252,               
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

 
BULK INSERT shippers 
FROM 'C:\TextFiles\shippers.txt' 
WITH (
               CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

BULK INSERT customers 
FROM 'C:\TextFiles\customers.txt' 
WITH (
               CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

BULK INSERT products 
FROM 'C:\TextFiles\products.txt' 
WITH (
               CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

BULK INSERT order_details 
FROM 'C:\TextFiles\order_details.txt'  
WITH (
               CODEPAGE=1252,              
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

BULK INSERT orders 
FROM 'C:\TextFiles\orders.txt' 
WITH (
               CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )



--		Part B - SQL Statements

/*	
	Question 1
	List the customer id, name, city, and country from the customer table.  
	Order the result set by the customer id.
*/

SELECT customer_id, name, city, country
FROM customers
ORDER BY customer_id;
GO

/*
	Question 2
	Add a new column called active to the customers table using the ALTER statement.  
	The only valid values are 1 or 0.  The default should be 1.
*/

ALTER TABLE customers
ADD active BIT NOT NULL
CONSTRAINT default_active DEFAULT(1);
GO

/*
	Question 3
	3.	List all the orders where the order date is between January 1 and December 31, 2001.  
	Display the order id, order date, and a new shipped date calculated by adding 17 days to the shipped date from the orders table, 
	the product name from the product table, the customer name from the customer table, and the cost of the order.  
	Format the date order date and the shipped date as MON DD YYYY.  Use the formula (quantity * unit_price) to calculate the cost of the order.  
*/

SELECT 
orders.order_id,
'product_name' = products.name,
'customer_name' = customers.name,
'order_date' = CONVERT(char(11), orders.order_date, 100),
'new_shipped_date' = CONVERT(char(11), orders.shipped_date + 17, 100),
'order_cost' = (order_details.quantity * products.unit_price)
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN customers ON customers.customer_id = orders.customer_id
WHERE orders.order_date BETWEEN 'Jan 1 2001' AND 'Dec 31 2001'
GO

/*
	Question 4
	4.	List all the orders that have not been shipped.  
	Display the customer id, name and phone number from the customers table, and the order id and order date from the orders table.  
	Order the result set by the customer name. 
*/

SELECT
orders.customer_id,
'name' = customers.name,
customers.phone,
orders.order_id,
orders.order_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE shipped_date IS NULL
ORDER BY name
GO

/*
	Question 5
	List all the customers where the region is NULL.  
	Display the customer id, name, and city from the customers table, and the title description from the titles table.   
*/

SELECT
customers.customer_id,
customers.name,
customers.city,
titles.description
FROM customers
INNER JOIN titles ON customers.title_id = titles.title_id
WHERE customers.region IS NULL
GO

/*
	Question 6
	List the products where the reorder level is higher than the quantity in stock.  
	Display the supplier name from the suppliers table, the product name, reorder level, and quantity in stock from the products table.  
	Order the result set by the supplier name. 
*/

SELECT
'supplier_name' = suppliers.name,
'products_name' = products.name,
products.reorder_level,
products.quantity_in_stock
FROM suppliers
INNER JOIN products ON suppliers.supplier_id = products.supplier_id
WHERE products.reorder_level > products.quantity_in_stock
ORDER BY supplier_name
GO

/*
	Question 7
	Calculate the length in years from January 1, 2008 and when an order was shipped where the shipped date is not null.  
	Display the order id, and the shipped date from the orders table, the customer name, and the contact name from the customers table, and the length in years for each order.  
	Display the shipped date in the format MMM DD YYYY.  
	Order the result set by order id and the calculated years.
*/

SELECT
orders.order_id,
customers.name,
customers.contact_name,
'shipped_date' = CONVERT(char(11), orders.shipped_date, 100),
'elapsed' = DATEDIFF(YEAR, orders.shipped_date, 'Jan 1 2008')
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.shipped_date IS NOT NULL
GO


/*
	Question 8
	List number of customers with names beginning with each letter of the alphabet.  
	Ignore customers whose name begins with the letter S.  
	Do not display the letter and count unless at least two customer’s names begin with the letter. 
*/

SELECT
'name' = LEFT(name, 1),
'total' = COUNT(name)
FROM customers
GROUP BY LEFT(name, 1)
HAVING COUNT(name) >= 2 AND LEFT(name, 1) != 'S'
GO

/*
	Question 9
	List the order details where the quantity is greater than 100.  
	Display the order id and quantity from the order_details table, the product id, the supplier_id and reorder level from the products table. 
	Order the result set by the order id.
*/

SELECT
order_details.order_id,
order_details.quantity,
products.product_id,
products.reorder_level,
suppliers.supplier_id
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE order_details.quantity > 100
ORDER BY order_details.order_id
GO

/*
	Question 10
	List the products which contain tofu or chef in their name.  
	Display the product id, product name, quantity per unit and unit price from the products table.  
	Order the result set by product name. 
*/

SELECT
product_id,
name,
quantity_per_unit,
unit_price
FROM products
WHERE name LIKE '%tofu%' OR name LIKE '%chef%'
ORDER BY name
GO


-- Part C - INSERT, UPDATE, DELETE and VIEWS Statements

/*
	Question 1
	Create an employee table with the following columns:
*/

CREATE TABLE employee 
(
	employee_id int NOT NULL,
	last_name varchar(30) NOT NULL,
	first_name varchar(15) NOT NULL,
	address varchar(30),
	city varchar(20),
	province char(2),
	postal_code varchar(7),
	phone varchar(10),
	birth_date datetime NOT NULL
);
GO

/*
	Question 2
	The primary key for the employee table should be the employee id.  
*/

ALTER TABLE employee
ADD PRIMARY KEY (employee_id)
GO

/*
	Question 3
	Load the data into the employee table using the employee.txt file; 9 rows.  
	In addition, create the relationship to enforce referential integrity between the employee and orders tables.  
*/

BULK INSERT employee
FROM 'C:\TextFiles\employee.txt'
WITH (
	CODEPAGE=1252,
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = '\t',
	KEEPNULLS,
	ROWTERMINATOR = '\n'
)

ALTER TABLE orders
ADD CONSTRAINT fk_employee_orders FOREIGN KEY (employee_id)
REFERENCES employee(employee_id);
GO

/*	Question 4
	Using the INSERT statement, add the shipper Quick Express to the shippers table.
*/

INSERT INTO shippers(name)
VALUES('Quick Express')
GO

SELECT *
FROM shippers
GO

/*
	Question 5
	Using the UPDATE statement, increate the unit price in the products table of all rows with a current unit price between $5.00 and $10.00 by 5%; 12 rows affected.
*/

UPDATE products
SET unit_price = unit_price * 1.05
WHERE unit_price >= 5 AND unit_price <= 10
GO

/*
	Question 6
	Using the UPDATE statement, change the fax value to Unknown for all rows in the customers table where the current fax value is NULL; 22 rows affected.
*/

UPDATE customers
SET fax = 'Unknown'
WHERE fax IS NULL
GO

/*
	Question 7
	Create a view called vw_order_cost to list the cost of the orders.  
	Display the order id and order_date from the orders table, the product id from the products table,
	the customer name from the customers table, and the order cost.  
	To calculate the cost of the orders, use the formula (order_details.quantity * products.unit_price).  
	Run the view for the order ids between 10000 and 10200.  
*/

CREATE VIEW vw_order_cost
AS
SELECT
	orders.order_id,
	orders.order_date,
	products.product_id,
	customers.name,
	'order_cost' = (order_details.quantity * products.unit_price)
FROM orders
INNER JOIN order_details ON order_details.order_id = orders.order_id
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN customers ON orders.customer_id = customers.customer_id
GO

SELECT * FROM vw_order_cost
WHERE order_id BETWEEN 10000 AND 10200
GO

/*
	Question 8
	Create a view called vw_list_employees to list all the employees and all the columns in the employee table.  
	Run the view for employee ids 5, 7, and 9.  Display the employee id, last name, first name, and birth date.  
	Format the name as last name followed by a comma and a space followed by the first name.  
	Format the birth date as YYYY.MM.DD.  
*/

CREATE VIEW vw_list_employees
AS
SELECT * FROM employee
GO


SELECT
	employee_id,
	'name' = last_name + ', ' + first_name,
	'birth_date' = convert(char(10), birth_date, 102)
FROM vw_list_employees
WHERE employee_id = 5 OR employee_id = 7 OR employee_id = 9
GO


/*
	Question 9
	Create a view called vw_all_orders to list all the orders. 
	Display the order id and shipped date from the orders table, and the customer id, name, city, and country from the customers table.  
	Run the view for orders shipped from January 1, 2002 and December 31, 2002, formatting the shipped date as MON DD YYYY.  
	Order the result set by customer name and country.  
*/

CREATE VIEW vw_all_orders
AS
SELECT
	orders.order_id,
	orders.shipped_date,
	customers.customer_id,
	'customer_name' = customers.name,
	customers.city,
	customers.country
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
GO

SELECT
	order_id,
	customer_id,
	customer_name,
	city,
	country,
	'shipped_date' = CONVERT(char(11), shipped_date, 100)
FROM vw_all_orders
WHERE shipped_date BETWEEN 'Jan 1 2002' AND 'Dec 31 2002'
ORDER BY customer_name, country
GO

/*
	Question 10
	Create a view listing the suppliers and the items they have shipped.  
	Display the supplier id and name from the suppliers table, and the product id and name from the products table.  
	Run the view.
*/

CREATE VIEW vw_supplier_products_shipped
AS
SELECT
	suppliers.supplier_id,
	'supplier_name' = suppliers.name,
	products.product_id,
	'product_name' = products.name
FROM suppliers
INNER JOIN products ON products.supplier_id = suppliers.supplier_id
GO


SELECT * FROM vw_supplier_products_shipped
GO

-- PART D Stored Procedures and Triggers

/*
	Question 1
	Create a stored procedure called sp_customer_city displaying the customers living in a particular city.  
	The city will be an input parameter for the stored procedure.  
	Display the customer id, name, address, city and phone from the customers table.  
	Run the stored procedure displaying customers living in London.  
	The stored procedure should produce the result set listed below.
*/

CREATE PROCEDURE sp_customer_city
(@city varchar(30))
AS
SELECT
customer_id,
name,
address,
city,
phone
FROM customers
WHERE city = @city
GO
EXECUTE sp_customer_city 'London'
GO

/*
	Question 2
	Create a stored procedure called sp_orders_by_dates displaying the orders shipped between particular dates. 
	The start and end date will be input parameters for the stored procedure.  
	Display the order id, customer id, and shipped date from the orders table, the customer name from the customer table, and the shipper name from the shippers table.  
	Run the stored procedure displaying orders from January 1, 2003 to June 30, 2003.  
	The stored procedure should produce the result set listed below.
*/

CREATE PROCEDURE sp_orders_by_dates 
(@start datetime,@end datetime)
AS
SELECT
	orders.order_id,
	orders.customer_id,
	'customer_name' = customers.name,
	'shipper_name' = shippers.name,
	orders.shipped_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN shippers ON orders.shipper_id = shippers.shipper_id
WHERE shipped_date BETWEEN @start AND @end
GO

EXECUTE sp_orders_by_dates 'Jan 1 2003', 'Jun 30 2003'
GO

/*
	Question 3
	Create a stored procedure called sp_product_listing listing a specified product ordered during a specified month and year.  
	The product and the month and year will be input parameters for the stored procedure.  
	Display the product name, unit price, and quantity in stock from the products table, and the supplier name from the suppliers table.  
	Run the stored procedure displaying a product name containing Jack and the month of the order date is June and the year is 2001.  
	The stored procedure should produce the result set listed below. 
*/
CREATE PROCEDURE sp_product_listing 
(@product varchar(50),@month varchar(8),@year int)
AS
SELECT
	'product_name' = products.name,
	products.unit_price,
	products.quantity_in_stock,
	'supplier_name' = suppliers.name
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
INNER JOIN order_details ON products.product_id = order_details.product_id
INNER JOIN orders ON order_details.order_id = orders.order_id
WHERE products.name LIKE '%' + @product + '%'
AND DATENAME(Month, orders.order_date) = @month
AND DATENAME(Year, orders.order_date) = @year
GO

EXECUTE sp_product_listing 'Jack', June, 2001
GO

/*
	Question 4
	Create a DELETE trigger on the order_details table to display the information shown below when you issue the following statement:

	DELETE order_details
     WHERE order_id=10001 AND product_id=25
*/

CREATE TRIGGER tr_order_details
ON order_details
AFTER DELETE
AS
DECLARE @prod_id intid, @qty_del int
SELECT @prod_id = product_id, @qty_del = quantity
FROM deleted
UPDATE products
SET quantity_in_stock = quantity_in_stock + @qty_del
WHERE product_id = @prod_id
BEGIN
SELECT
	'Product_ID' = deleted.product_id,
	'Product Name' = products.name,
	'Quantity being deleted from Order' = @qty_del,
	'In stock Quantity after Deletion' = products.quantity_in_stock
FROM deleted
INNER JOIN products ON deleted.product_id = products.product_id
END
GO

DELETE order_details
WHERE order_id = 10001 AND product_id = 25
GO

/*
	Question 5
	Create an UPDATE trigger called tr_qty_check on the order_details table which will reject any update to the quantity column if an addition to the original quantity cannot be supplied from the existing quantity in stock.  
	The trigger should also report on the additional quantity needed and the quantity available.
	If there is enough stock, the trigger should update the stock value in the products table by subtracting the additional quantity from the original stock value and display the updated stock value.
*/

CREATE TRIGGER tr_qty_check
ON order_details
FOR UPDATE
AS 
DECLARE @prod_id intid, @gty int, @quantity_INSTOCK int 
SELECT  @prod_id = products.product_id, @gty = inserted.quantity-deleted.quantity, @quantity_INSTOCK = products.quantity_in_stock
FROM inserted
INNER JOIN deleted ON inserted.product_id = deleted.product_id
INNER JOIN products ON inserted.product_id = products.product_id
IF(@gty > @quantity_INSTOCK)
BEGIN 
     PRINT 'additional quantity needed'
	 ROLLBACK TRANSACTION 
END
ELSE
BEGIN
   UPDATE products 
   SET quantity_in_stock = quantity_in_stock - @gty
   WHERE product_id = @prod_id
END
GO


/*
	Question 6
	Run the following 2 queries separately to verify your trigger:un the following 2 queries separately to verify your trigger:
*/

UPDATE order_details
SET quantity =50
WHERE order_id = '10044'
     AND product_id = 7;

UPDATE order_details
SET quantity =40
WHERE order_id = '10044'
     AND product_id = 7;


/*
	Question 7
	Create a stored procedure called sp_del_inactive_cust to delete customers that have no orders.  
	The stored procedure should delete 1 row.
*/

CREATE PROCEDURE sp_del_inactive_cust
AS
DELETE
FROM customers
WHERE customers.customer_id	  NOT IN
(
SELECT orders.customer_id
FROM orders
)

EXECUTE sp_del_inactive_cust
GO

/*
	Question 8
	Create a stored procedure called sp_employee_information to display the employee information for a particular employee.  
	The employee id will be an input parameter for the stored procedure.  Run the stored procedure displaying information for employee id of 5.  
	The stored procedure should produce the result set listed below.
*/

CREATE PROCEDURE sp_employee_information 
( @employ_id int )
AS
SELECT
	employee_id,
	last_name,
	first_name,
	address,
	city,
	province,
	postal_code,
	phone,
	birth_date
FROM employee
WHERE employee_id = @employ_id
GO

EXECUTE sp_employee_information 5
GO

/*
	Question 9
	Create a stored procedure called sp_reorder_qty to show when the reorder level subtracted from the quantity in stock is less than a specified value.  
	The unit value will be an input parameter for the stored procedure.  
	Display the product id, quantity in stock, and reorder level from the products table, and the supplier name, address, city, and province from the suppliers table.  
	Run the stored procedure displaying the information for a value of 5.  The stored procedure should produce the result set listed below
*/

CREATE PROCEDURE sp_reorder_qty 
(
@unit int
)
AS
SELECT
	products.product_id,
	suppliers.name,
	suppliers.address,
	suppliers.city,
	suppliers.province,
	'qty' = products.quantity_in_stock,
	products.reorder_level
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
WHERE (products.quantity_in_stock - products.reorder_level) < @unit
GO

EXECUTE sp_reorder_qty 5
GO
/*
	Question 10
	Create a stored procedure called sp_unit_prices for the product table where the unit price is between particular values.  
	The two unit prices will be input parameters for the stored procedure.  Display the product id, product name, alternate name, and unit price from the products table.  
	Run the stored procedure to display products where the unit price is between $5.00 and $10.00.  The stored procedure should produce the result set listed below.    
*/

CREATE PROCEDURE sp_unit_prices 
(
@unit_1 money,
@unit_2 money
)
AS
SELECT
	product_id, name,
	alternate_name,
	unit_price
FROM products
WHERE unit_price BETWEEN @unit_1 AND @unit_2
GO

EXECUTE sp_unit_prices 5, 10
GO




