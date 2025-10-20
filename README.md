Retail Sales Database Project
Overview

This project contains SQL queries to manage, clean, and analyze retail sales data. It includes creating a database, replicating data, handling missing or null values, performing basic data exploration, and solving business problems using SQL. The goal is to demonstrate efficient data management and querying techniques for real-world business analysis.

Database: retail_db

The project works with two main tables:

retail_sales_db: Source table containing the original sales data.

retail_sales_staging_db: A staging table used for data cleansing and transformation.

Additionally, a view (retail_sales_view) is created to simplify querying and report generation.

Features

Data Replication: Replicating the structure and content of the retail_sales_db into a staging table (retail_sales_staging_db).

Data Quality: Identifying and removing rows with missing values in critical columns.

Data Exploration: Exploring basic metrics such as total sales, unique customers, and categories.

Time-Based Categorization: Categorizing sales data by shifts (morning, afternoon, evening) based on sale_time.

Business Problem Solving: Writing queries to calculate total sales by category, find top customers, and determine the best-selling months.
