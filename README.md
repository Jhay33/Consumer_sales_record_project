# Consumer Sales Analysis SQL Project

## Project Overview

**Project Title**: Consumer Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p2`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a consumer retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p2`.
- **Table Creation**: A table named `retail_sales_tb` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_p2;

CREATE TABLE retail_sales_tb
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT * FROM retail_sales_tb;
--Before uploading the data file only column names are visible
--After uploading the data file using the public, tables(Import/Export data) option we can refresh and reload the command
SELECT * FROM retail_sales_tb;

-- to view the table on the [order by] of [transaction_id]
-- to view the first 100 rows [ASC Limit 100] is used
SELECT * FROM retail_sales_tb
ORDER BY transaction_id ASC LIMIT 100
```
--DATA CLEANING --
--count(*) used to count the total number of rows
```
SELECT COUNT(*)
FROM retail_sales_tb
```

--to find the null(empty) value
```
SELECT * FROM retail_sales_tb
WHERE quantity IS NULL
```

--use the below method to find the null values in the Table
```
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
```

--Delete the null values
```
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
```
-- Data Exploration --

--How many sales we have from this data?
```
SELECT COUNT(*) AS total_sale
FROM retail_sales_tb
```
--So we have done 1987 sales.

--How many Uniques Customers do we have?
```
SELECT COUNT(*) AS customer_id
FROM retail_sales_tb
```

-- To find out the values without duplication we can use Distinct()
```
SELECT COUNT(DISTINCT customer_id) AS total_sale
FROM retail_sales_tb
```
--To check out the categories the products sold
```
SELECT DISTINCT category AS total_sale 
FROM retail_sales_tb
```
### 3. Data Analysis & Findings

### The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * FROM retail_sales_tb
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
*** Answer 1
```sql
SELECT *
FROM retail_sales_tb
WHERE category = 'Clothing' 
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity > 3;
```
***Answer 2
```sql
SELECT *
FROM retail_sales_tb
WHERE category = 'Clothing'
  AND quantity > 3
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category,
	COUNT(*) as total_orders,
	SUM(total_sale) as net_sale
FROM retail_sales_tb
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(age), 2) as Average_age_in_Beauty_sales
FROM retail_sales_tb
WHERE category = 'Beauty'
-- Round function is used to round the value as before the value is 40.415711
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales_tb
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales_tb
GROUP BY category, gender
ORDER BY category
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales_tb
GROUP BY 1, 2
) as t1
WHERE rank = 1
-- ORDER BY year, average_sale DESC

--ORDER BY 1, 3 DESC
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales_tb
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales_tb
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 400, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

jhayjohnson2@gmail.com

Thank you for your support, and I look forward to connecting with you!
