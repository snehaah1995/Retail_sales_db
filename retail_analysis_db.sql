-- Create the database
CREATE DATABASE retail_db;

-- Use the newly created database
USE retail_db;

-- Select all records from the retail_sales_db
SELECT *
FROM retail_sales_db;

-- Replica of data: Create a new table with the same structure as retail_sales_db but with no data
SELECT * INTO retail_sales_staging_db
FROM retail_sales_db
WHERE 1 = 0;

-- Insert all data from retail_sales_db into the staging table retail_sales_staging_db
INSERT INTO retail_sales_staging_db
SELECT *
FROM retail_sales_db;

-- Count the rows in retail_sales_staging_db (to check data count after insert)
SELECT *
FROM retail_sales_staging_db;

-- Query to find records where key columns have null values (data quality check)
SELECT *
FROM retail_sales_staging_db
WHERE transactions_id IS NULL 
  OR customer_id IS NULL
  OR gender IS NULL
  -- OR age IS NULL -- Commented out if age is not critical
  OR category IS NULL
  OR sale_date IS NULL
  OR quantiy IS NULL
  OR price_per_unit IS NULL
  OR cogs IS NULL
  OR total_sale IS NULL;

-- Delete rows from staging table where there are NULL values in critical columns
DELETE FROM retail_sales_staging_db
WHERE transactions_id IS NULL 
  OR customer_id IS NULL
  OR gender IS NULL
  -- OR age IS NULL -- Commented out if age is not critical
  OR category IS NULL
  OR sale_date IS NULL
  OR quantiy IS NULL
  OR price_per_unit IS NULL
  OR cogs IS NULL
  OR total_sale IS NULL;

-- Count the number of remaining rows in the staging table after deletion
SELECT count(*) as total_rows
FROM retail_sales_staging_db;

-- Data exploration section: Exploring various metrics about sales data

-- Total number of sales records in staging table
SELECT COUNT(*) AS Total_Sales
FROM retail_sales_staging_db;

-- Total number of unique customers (counting distinct customer_ids)
SELECT COUNT(DISTINCT customer_id) AS Total_customer
FROM retail_sales_staging_db;

-- List of unique categories available in the sales data
SELECT DISTINCT category
FROM retail_sales_staging_db;

-- Business problem: Retrieve sales data made on a specific date (2022-11-05)
SELECT *
FROM retail_sales_staging_db
WHERE sale_date = '2022-11-05';

-- Create a view for easier querying (filtered columns for sales data)
CREATE VIEW retail_sales_view AS
SELECT transactions_id,
       sale_date,
       sale_time,
       customer_id,
       gender,
       age,
       category,
       quantiy,
       price_per_unit,
       cogs,
       total_sale
FROM retail_sales_staging_db;

-- Query the view to get records for sales on 2022-11-05
SELECT *
FROM retail_sales_view
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and quantity sold is greater than 4 in the month of Nov-2022
SELECT *
FROM retail_sales_view
WHERE category = 'Clothing' AND quantiy > 4 AND MONTH(sale_date) = 11;

-- Another example: Query with quantity greater than 3 (example filter change)
SELECT *
FROM retail_sales_view
WHERE category = 'Clothing'
  AND quantiy > 3
  AND MONTH(sale_date) = 11;

-- Write a SQL query to calculate the total sales for each category (group by category)
SELECT category, 
       SUM(total_sale) AS Total_sales
FROM retail_sales_staging_db
GROUP BY category
ORDER BY Total_sales DESC;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT AVG(age) AS avg_age_of_customer
FROM retail_sales_staging_db
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total sale amount is greater than 1000
SELECT *
FROM retail_sales_view
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category, gender, COUNT(*) AS Total_transaction
FROM retail_sales_staging_db
GROUP BY gender, category
ORDER BY 1;  -- Orders by category

-- Write a SQL query to calculate the average sale for each month and find the best-selling month in each year
SELECT
    Year,
    Month,
    Avg_sale
FROM 
(
    SELECT 
        MONTH(sale_date) AS Month,
        YEAR(sale_date) AS Year,
        CAST(AVG(total_sale) AS decimal(10,2)) AS Avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales_staging_db
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rank = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales
SELECT TOP 5 customer_id, SUM(total_sale) AS Total_sales
FROM retail_sales_staging_db
GROUP BY customer_id
ORDER BY Total_sales DESC;

-- Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales_staging_db
GROUP BY category
ORDER BY unique_customers DESC;

-- Write a SQL query to categorize sales by shift based on sale time
-- Example: Morning < 12, Afternoon Between 12 & 17, Evening > 17
SELECT max(sale_time), min(sale_time)
FROM retail_sales_staging_db;

-- Using CASE and DATEPART to categorize sales into time shifts (morning, afternoon, evening)
SELECT *,
    CASE
        WHEN DATEPART(HOUR, sale_time) >= 6 AND DATEPART(HOUR, sale_time) < 12 THEN 'morning'
        WHEN DATEPART(HOUR, sale_time) >= 12 AND DATEPART(HOUR, sale_time) < 18 THEN 'afternoon'
        ELSE 'evening'
    END AS Time_shifts
FROM retail_sales_staging_db;
