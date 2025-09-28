CREATE DATABASE zepto_sql_project;

DROP TABLE IF EXISTS zepto;

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

SELECT *
FROM zepto;

--data exploration

SELECT COUNT(*)
FROM zepto;

--data sample 

SELECT *
FROM zepto
LIMIT 10;

--null values 
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

--different product categories 

SELECT DISTINCT(category)
FROM zepto
ORDER BY category;

--products in stock vs out of stock

SELECT outofstock, COUNT(skuid)
FROM zepto
GROUP BY outofstock;

--product names present multiple times 

SELECT name, COUNT(skuid) AS "Number of Skus"
FROM zepto
GROUP BY name
HAVING COUNT(skuid)>1
ORDER BY COUNT(skuid) DESC ;

--data cleaning

--products where price = 0

SELECT *
FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees

UPDATE zepto
SET mrp = mrp /100.0,
discountedsellingprice = discountedsellingprice/ 100.0;

--Q1. Find the top 10 best valued products based on the discount percentage

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Q2. What are the products with high MRP but out of stock

SELECT DISTINCT name, mrp 
FROM zepto
WHERE mrp > 300 AND outofstock = True
ORDER BY mrp DESC;

--Q3. Calculate the estimated revenue for each category

SELECT category, 
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. Find all the products where MRP is greater than 500rs and discount is less than 10%

SELECT DISTINCT name, mrp,discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent <10
ORDER BY mrp DESC ,discountpercent DESC ;

--Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT DISTINCT category,
ROUND (AVG (discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6. Find the price per gram for products above 100 gms and sort by best value

SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND (discountedsellingprice /weightingms ,2) AS price_per_gm
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gm;

--Q7. Group the products into categories like low, medium and bulk

SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
     ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

--Q8. What is the total inventory weight per category

SELECT category,
SUM (weightingms * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;














































