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
- Top 10 discounted products
- High MRP but out-of-stock items
- Revenue estimation by category
- Categories with highest average discount
- Best value products (price per gram)
- Inventory weight by category

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

<img width="128" height="82" alt="2-a" src="https://github.com/user-attachments/assets/57ee2404-ca7c-4121-8de9-5c479c431f4c" />


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
**Output**

<img width="250" height="483" alt="2-b" src="https://github.com/user-attachments/assets/0acbedde-fec3-4043-9bd4-c6bcbc3379db" />


- **Product In stock Vs Out Of Stock**: Check if the products are in stock or are out of stock.
```sql
SELECT outofstock, COUNT(skuid)
FROM zepto
GROUP BY outofstock;
```
**Output**

<img width="242" height="110" alt="2-c" src="https://github.com/user-attachments/assets/39fb8d58-01e7-4f5e-a093-ccb3d94bf5ae" />


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
   
   <img width="670" height="361" alt="q1" src="https://github.com/user-attachments/assets/2b8335b1-3945-4120-ab9e-e5ac0cf718f1" />


2. **What are the products with high MRP but out of stock**
```sql
SELECT DISTINCT name, mrp 
FROM zepto
WHERE mrp > 300 AND outofstock = True
ORDER BY mrp DESC;
```
**Output**

<img width="612" height="175" alt="q2" src="https://github.com/user-attachments/assets/99739043-1c68-41e5-980a-ffb8c76de0f7" />


3. **Calculate the estimated revenue for each category**
```sql
SELECT category, 
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;
```
**Output**

<img width="380" height="483" alt="q3" src="https://github.com/user-attachments/assets/28c7c4d5-47cc-4ec4-8b80-a75aa9ec873e" />


4. **Find all the products where MRP is greater than 500rs and discount is less than 10%**
```sql
SELECT DISTINCT name, mrp,discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent <10
ORDER BY mrp DESC ,discountpercent DESC ;
```
**Output**

<img width="892" height="296" alt="q4" src="https://github.com/user-attachments/assets/de040f47-102a-4587-9551-2071b1f5569c" />


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

<img width="378" height="201" alt="q5" src="https://github.com/user-attachments/assets/d8875f3b-50fb-4677-af1f-325dad458256" />


6. **Find the price per gram for products above 100 gms and sort by best value**
```sql
SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND (discountedsellingprice /weightingms ,2) AS price_per_gm
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gm;
```
**Output**

<img width="1087" height="362" alt="q6" src="https://github.com/user-attachments/assets/f576fb56-2591-4b9d-bb76-b11bfafe56d9" />


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

<img width="1008" height="208" alt="q7" src="https://github.com/user-attachments/assets/5ba37c3d-3d6a-4d3b-a44f-1e9c7eff1963" />


8. **What is the total inventory weight per category**
```sql
SELECT category,
SUM (weightingms * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
```
**Output**

<img width="372" height="485" alt="q8" src="https://github.com/user-attachments/assets/8a516641-3ab0-4a79-92ba-d0ac73796bbd" />

## Findings

-**Duplicate Product Records**: Multiple SKUs were found to be listed more than once, indicating redundancy that could affect inventory tracking and analytics accuracy.

-**Missing or Invalid Prices**: Product entries had an MRP of zero or null, suggesting incomplete data that needed cleaning before revenue calculations.

-**Overlapping Category Assignments**: Certain products appeared under multiple categories, pointing to inconsistent classification within the catalog.

-**Stock Imbalance Across Categories**: Some categories had significantly higher out of stock rates compared to others, signaling potential demand supply gaps.

-**High Demand for Premium Products**: Products priced above ₹300 were more frequently out of stock, indicating strong customer preference for higher-value items.

## Reports

-**Top Discounted Products**: A ranked list of the top 10 products with the highest discount percentages was generated to highlight customer attractive offerings.

-**Revenue Potential Estimation**: Estimated revenue was calculated for each product by multiplying its discounted price with available stock, helping identify high value SKUs.

-**Price per Gram Normalization**: Price was standardized across different weight variations to enable fair comparison between products of varying sizes.

-**Weight Based Product Segmentation**: Products were classified as Low, Medium, or Bulk based on weight, offering better clarity for logistics and categorization.

-**Category Wise Discount Analysis**: The top 5 categories offering the greatest average customer savings were identified to assess promotional effectiveness.


## Conclusion

The analysis highlights that product catalog inconsistencies such as duplicate entries and missing price values can significantly affect inventory and pricing accuracy. Premium priced products showed higher demand, often going out of stock faster than lower priced items, suggesting strong consumer preference for value over budget options. Discount driven categories emerged as major customer attractors, reinforcing the importance of strategic pricing and inventory alignment.


## Author - Anshika Srivastava

























