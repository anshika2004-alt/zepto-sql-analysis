# Zepto Inventory Analysis SQL  Project

## Project Overview 


*Project Title* : Zepto Inventory Analysis

*Database* : zepto_sql_project

This project is a retail data analysis using SQL. The dataset (zepto_v2.csv) contains product details such as category, price, discount, stock, and weight. The SQL script (zepto_sql_query.sql) covers data cleaning, exploration, and analysis to answer business questions like top discounts, revenue by category, and stock availability.

## Dataset Information

The dataset is sourced from Kaggle (Zepto Inventory dataset) and contains product-level details:

skuid – Unique product ID
category – Product category
name – Product name
mrp – Maximum Retail Price (₹)
discountPercent – Discount percentage
availableQuantity – Stock available
discountedSellingPrice – Price after discount (₹)
weightInGms – Product weight in grams
outOfStock – Availability status (True/False)
quantity – Quantity per product entry

## Features

The SQL script (zepto_sql_query.sql) covers:

1. **Table Creation** – Defining schema for the dataset
2. **Data exploration** – Checking categories, stock, duplicates
3. **Data Cleaning** – Handling nulls, removing invalid prices, unit conversion
4. **Analysis queries** -
- 1.Top 10 discounted products
- 2.High MRP but out-of-stock items
- 3.Revenue estimation by category
- 4.Categories with highest average discount
- 5.Best value products (price per gram)
- 6.Inventory weight by category

## Tools And Techniques 

1. **PostgreSQL**: An open-source relational database system used to manage all project data. It was chosen for its reliability and advanced features, which ensured data integrity and efficient query processing.
2. **PgAdmin 4**: The primary graphical user interface (GUI) used for administering and developing the PostgreSQL database. It facilitated tasks such as database design, data management, and query execution.

## Project Structure

### 1.Database Setup

- **Database Creation**: The project starts by creating a database named `zepto`.
  ```sql
   CREATE DATABASE zepto_sql_project;
  ```
- **Table Creation**: A table named `zepto` is created to store the inventory data. The table structure includes columns for skuid, category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, outOfStock, quantity
```sql
CREATE TABLE zepto
(
   skuid SERIAL PRIMARY KEY,
   Category	VARCHAR (120),
   name	VARCHAR (150) NOT NULL,
   mrp NUMERIC (8,2),
   discountPercent NUMERIC (5,2),
   availableQuantity INTEGER,
   discountedSellingPrice NUMERIC (8,2),
   weightInGms INTEGER,
   outOfStock BOOLEAN,
   quantity INTEGER
);
```







