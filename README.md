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

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
```sql
SELECT COUNT(*)
FROM zepto;
```
**Output**

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql
SELECT *
FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;
```
- **Category Count**: Identify all unique product categories in the dataset.
```sql
SELECT DISTINCT(category)
FROM zepto
ORDER BY category;
```
- **Product In stock Vs Out Of Stock**: Check if the products are in stock or are out of stock.
```sql
SELECT outofstock, COUNT(skuid)
FROM zepto
GROUP BY outofstock;
```

- **Product Names Present Multiple Times**: Lists products that appear in the data more than once.
```sql
SELECT name, COUNT(skuid) AS "Number of Skus"
FROM zepto
GROUP BY name
HAVING COUNT(skuid)>1
ORDER BY COUNT(skuid) DESC ;
```

- **Products Where Price = 0** 
```sql
SELECT *
FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;
```

- **Delete Products Where Price = 0**
```sql
DELETE FROM zepto
WHERE mrp = 0;
```
- **Convert Paise To Rupees**
```sql
UPDATE zepto
SET mrp = mrp /100.0,
discountedsellingprice = discountedsellingprice/ 100.0;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Find the top 10 best valued products based on the discount percentage**:
   ```sql
   SELECT DISTINCT name, mrp, discountpercent
   FROM zepto
   ORDER BY discountpercent DESC
   LIMIT 10;
   ```
   **Output**

2. **What are the products with high MRP but out of stock**
```sql
SELECT DISTINCT name, mrp 
FROM zepto
WHERE mrp > 300 AND outofstock = True
ORDER BY mrp DESC;
```
**Output**

3. **Calculate the estimated revenue for each category**
```sql
SELECT category, 
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;
```
**Output**

4. **Find all the products where MRP is greater than 500rs and discount is less than 10%**
```sql
SELECT DISTINCT name, mrp,discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent <10
ORDER BY mrp DESC ,discountpercent DESC ;
```
**Output**

5. **Identify the top 5 categories offering the highest average discount percentage**
```sql
SELECT DISTINCT category,
ROUND (AVG (discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
```
**Output**

6. **Find the price per gram for products above 100 gms and sort by best value**
```sql
SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND (discountedsellingprice /weightingms ,2) AS price_per_gm
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gm;
```

7. **Group the products into categories like low, medium and bulk**
```sql
SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
     ELSE 'Bulk'
	 END AS weight_category
FROM zepto;
```
**Output**

8. **What is the total inventory weight per category**
```sql
SELECT category,
SUM (weightingms * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
```

























