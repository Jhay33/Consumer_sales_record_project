-- SQL Retail Sales Analysis  - P1
CREATE DATABASE sql_project_p2;

--Create a table
DROP Table IF Exists retail_sales_tb;
CREATE TABLE retail_sales_tb
	( 
		transaction_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender	VARCHAR(15), 
		age	INT,
		category VARCHAR(15), 
		quantity INT,
		price_per_unit FLOAT,	
		cogs FLOAT,
		total_sale FLOAT
	)

SELECT * FROM retail_sales_tb;
--Before uploading the data file only column names are visible
--After uploading the data file using the public, tables(Import/Export data) option we can refresh and reload the command
SELECT * FROM retail_sales_tb;

-- to view the table on the [order by] of [transaction_id]
-- to view the first 100 rows [ASC Limit 100] is used
SELECT * FROM retail_sales_tb
ORDER BY transaction_id ASC LIMIT 100

--DATA CLEANING --
--count(*) used to count the total number of rows
SELECT COUNT(*)
FROM retail_sales_tb

--to find the null(empty) value
SELECT * FROM retail_sales_tb
WHERE quantity IS NULL

--use the below method to find the null values in the Table
SELECT * FROM retail_sales_tb
WHERE 
	transaction_id IS NULL
 	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Delete the null values
DELETE FROM retail_sales_tb
WHERE 
	transaction_id IS NULL
 	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration --

--How many sales we have from this data?
SELECT COUNT(*) AS total_sale FROM retail_sales_tb

--So we have done 1987 sales.

--How many Uniques Customers do we have?
SELECT COUNT(*) AS customer_id FROM retail_sales_tb

-- To find out the values without duplication we can use Distinct()
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales_tb

--To check out the categories the products sold
SELECT DISTINCT category AS total_sale FROM retail_sales_tb

-- DATA ANALYSIS -- BUSINESS KEY PROBLEMS --
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

*******************
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales_tb
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 3 in the month of Nov-2022
-- Answer 1:
SELECT *
FROM retail_sales_tb
WHERE category = 'Clothing' 
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity > 3;

--Answer 2
SELECT *
FROM retail_sales_tb
WHERE category = 'Clothing'
  AND quantity > 3
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,
	COUNT(*) as total_orders,
	SUM(total_sale) as net_sale
FROM retail_sales_tb
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age), 2) as Average_age_in_Beauty_sales
FROM retail_sales_tb
WHERE category = 'Beauty'

-- Round function is used to round the value as before the value is 40.415711

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales_tb
WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales_tb
GROUP BY category, gender
ORDER BY category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
	year,
	month,
	average_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as average_sale,
	RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales_tb
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- ORDER BY year, average_sale DESC

--ORDER BY 1, 3 DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales_tb
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales_tb
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'afternoon'
		ELSE 'evening'
	END as shift
FROM retail_sales_tb
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- To BE Continued