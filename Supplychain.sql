-- Creation of a schema/database
CREATE SCHEMA tech_electro;
USE tech_electro;
SHOW tables;

-- Data Exploration
SHOW tables;
SELECT * FROM external_factors LIMIT 5;
SELECT * FROM sales_data LIMIT 5;
SELECT * FROM product_information LIMIT 5;

-- Understanding the structure of the datasets

SHOW COLUMNS FROM external_factors;
DESCRIBE sales_data;
DESC product_information;

-- Data Cleaning
-- changing the data types across all datasets

ALTER TABLE external_factors
ADD COLUMN New_Sales_Date DATE;

ALTER TABLE external_factors
DROP COLUMN New_Sales_Date;

SET SQL_SAFE_UPDATES = 0; -- turning off safe updates

UPDATE external_factors
SET New_Sales_Date = str_to_date(Sales_Date,'%d/%m/%Y');

ALTER TABLE external_factors
DROP COLUMN Sales_Date;

ALTER TABLE external_factors
CHANGE COLUMN New_Sales_Date Sales_Date DATE;

ALTER TABLE external_factors
MODIFY COLUMN GDP DECIMAL(15,2);

ALTER TABLE external_factors
MODIFY COLUMN Inflation_Rate DECIMAL (5,2);

ALTER TABLE external_factors
MODIFY COLUMN Seasonal_Factor DECIMAL (5,2);

SHOW COLUMNS FROM external_factors;

-- Let's change the datatypes of the product data to the appropriate one
SHOW COLUMNS FROM product_information;

ALTER TABLE product_information
ADD COLUMN NewPromotions ENUM('Yes', 'No');

UPDATE product_information
SET NewPromotions = CASE
	WHEN Promotions = 'yes' THEN 'yes'
	WHEN Promotions = 'no' THEN 'no'
    ELSE NULL 
END;

ALTER TABLE product_information
DROP COLUMN Promotions;

ALTER TABLE product_information
CHANGE COLUMN NewPromotions Promotions ENUM('yes', 'no');

DESCRIBE product_information;

-- For sales_data
ALTER TABLE sales_data
ADD COLUMN New_Sales_Date DATE;

UPDATE sales_data
SET New_Sales_Date = str_to_date(Sales_Date, '%d/%m/%Y');

ALTER TABLE sales_data
DROP COLUMN Sales_Date;

ALTER TABLE sales_data
CHANGE COLUMN New_Sales_Date Sales_Date DATE;

DESC sales_data;

-- checking for missing values using 'IS NULL' function
-- looking out for external_factors
DESC external_factors;
SELECT 
SUM(CASE WHEN GDP IS NULL THEN 1 ELSE 0 END) AS missing_GDP,
SUM(CASE WHEN Inflation_Rate IS NULL THEN 1 ELSE 0 END) AS missing_inflation_rate,
SUM(CASE WHEN Seasonal_Factor IS NULL THEN 1 ELSE 0 END) AS missing_seasonal_factor,
SUM(CASE WHEN Sales_Date IS NULL THEN 1 ELSE 0 END) AS missing_sales_date
FROM external_factors;

-- For product information
DESC product_information;
SELECT 
SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
SUM(CASE WHEN Product_Category IS NULL THEN 1 ELSE 0 END) AS missing_product_category,
SUM(CASE WHEN Promotions IS NULL THEN 1 ELSE 0 END) AS missing_promotions
FROM product_information;

-- checking for duplicates using 'HAVING' and 'GROUPBY'
-- external factors
SELECT Sales_Date, COUNT(*) AS TOTAL
FROM external_factors
GROUP BY Sales_Date
HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM
(SELECT Sales_Date, COUNT(*) AS TOTAL
FROM external_factors
GROUP BY Sales_Date
HAVING COUNT(*) > 1) AS dup;

-- there are total of 352 duplicates

-- product information
DESC product_information;

SELECT Product_ID, COUNT(*) AS TOTAL
FROM product_information
GROUP BY Product_ID
HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM
(SELECT Product_ID, COUNT(*) AS TOTAL
FROM product_information
GROUP BY Product_ID
HAVING COUNT(*) > 1) AS dup;

-- Total of 117 duplicates

-- dealing with duplicates for external_factors and product_information
DELETE e1 FROM external_factors e1
INNER JOIN(
SELECT Sales_Date, 
ROW_NUMBER() OVER (PARTITION BY Sales_Date ORDER BY Sales_Date) AS rn
FROM external_factors) e2 ON e1.Sales_Date = e2.Sales_Date
WHERE e2.rn > 1;

DELETE p1 FROM product_information p1
INNER JOIN(
SELECT Product_ID, 
ROW_NUMBER() OVER (PARTITION BY Product_ID ORDER BY Product_ID) AS rn
FROM product_information) p2 ON p1.Product_ID = p2.Product_ID
WHERE p2.rn > 1;

-- DATA INTEGRATION
-- sales_data and product_information
DESC sales_data;
DESC product_information;

CREATE VIEW sales_product_information AS
SELECT
s.Product_ID,
s.Inventory_Quantity,
s.Product_Cost,
s.Sales_Date,
p.Product_Category,
p.Promotions
FROM sales_data s
JOIN product_information p ON s.Product_ID = p.Product_ID;

-- sales_product_information and external_factors
DESC external_factors;

CREATE VIEW inventory_data AS
SELECT
sp.Product_ID,
sp.Inventory_Quantity,
sp.Product_Cost,
sp.Sales_Date,
sp.Product_Category,
sp.Promotions,
e.GDP,
e.Inflation_Rate,
e.Seasonal_Factor
FROM sales_product_information sp
JOIN external_factors e ON sp.Sales_Date = e.Sales_Date;

-- DESCRIPTIVE ANALYSIS
-- Average sales
SELECT Product_ID, AVG(Inventory_Quantity * Product_Cost) AS avg_sales
FROM inventory_data
GROUP BY Product_ID
ORDER BY avg_sales DESC;

-- Product_ID 2010 has the highest Average sales of 19,669.

DESC inventory_data;

-- checking for the total sales for everyday
SELECT Sales_Date, SUM(Inventory_Quantity * Product_Cost) AS Total_sales
FROM inventory_data
GROUP BY Sales_Date
ORDER BY Total_sales DESC;


-- Checking for the Sales_year with most sales 
SELECT YEAR(Sales_Date) AS Sales_year, COUNT(YEAR(Sales_Date)) AS Count
FROM inventory_data
GROUP BY Sales_year
ORDER BY Count DESC;

-- 2020 recorded most sales of 121

-- checking for year with most sales amount
SELECT 
    YEAR(Sales_Date) AS Sales_year,
    COUNT(*) AS Count, SUM(Inventory_Quantity * Product_Cost) AS Total_sales
FROM 
    inventory_data
GROUP BY 
    Sales_year
ORDER BY 
    Count DESC;

-- 2020 still comes out with the most amount of sales of 661555.2100000002

-- Checking to see the product most purchased in total
SELECT Product_Category, COUNT(*) AS Count
FROM inventory_data
GROUP BY Product_Category
ORDER BY Count DESC;

-- It shows that Smartphones were the most purchased

-- Checking if promotions played a vital role to number of sales
SELECT Product_Category, COUNT(*) AS Total_count, COUNT(CASE WHEN Promotions = 'yes' THEN 1 END) AS Promotion_count 
FROM inventory_data
GROUP BY Product_Category
ORDER BY Total_count DESC;

-- From the result it can be seen as the availiability of promotions aided in the increase in sales.

-- Checking the most revenue generated

SELECT Product_Category, COUNT(*) AS Count, SUM(Inventory_Quantity * Product_Cost) AS Total_sales
FROM inventory_data
GROUP BY Product_Category
ORDER BY Total_sales DESC;

-- Tho Smartphones had more sales, but Electronics generated more revenue.

-- checking across each year for each Product_Category

SELECT YEAR(Sales_Date) AS Sales_year, Product_Category, COUNT(*) AS Count
FROM inventory_data
WHERE Product_Category = 'SmartPhones'
GROUP BY Sales_year, Product_Category
ORDER BY Count DESC;

-- FROM 2019, there has been an experience in the drop of purchase of smartphones

SELECT YEAR(Sales_Date) AS Sales_year, Product_Category, COUNT(*) AS Count
FROM inventory_data
WHERE Product_Category = 'Electronics'
GROUP BY Sales_year, Product_Category
ORDER BY Count DESC;

-- FROM 2020, there has been an experience in the drop of purchase of electronics

SELECT YEAR(Sales_Date) AS Sales_year, Product_Category, COUNT(*) AS Count
FROM inventory_data
WHERE Product_Category = 'Laptops'
GROUP BY Sales_year, Product_Category
ORDER BY Count DESC;

-- There has been a drop in the purchase of laptops

SELECT YEAR(Sales_Date) AS Sales_year, Product_Category, COUNT(*) AS Count
FROM inventory_data
WHERE Product_Category = 'Home_Appliances'
GROUP BY Sales_year, Product_Category
ORDER BY Count DESC;

-- There has been drops in purchase not until 2022 that there was a rise

-- There is need to investigate to know the reason behind the increase in purchase of Home_appliances in 2022
SELECT MONTH(Sales_Date) AS Sales_month, Product_Category, COUNT(*) AS Count
FROM inventory_data
WHERE Product_Category = 'Home_Appliances' AND YEAR(Sales_Date) = '2022'
GROUP BY Sales_month, Product_Category
ORDER BY Count DESC;

-- This shows that most Home_appliances was purchased in August in the year 2022

-- Checking if the reason for the spike was promotions
SELECT MONTH(Sales_Date) AS Sales_month, Product_Category, COUNT(*) AS Count,
COUNT(CASE WHEN Promotions = 'yes' THEN 1 END) AS promotion_count
FROM inventory_data
WHERE Product_Category = 'Home_Appliances' AND YEAR(Sales_Date) = '2022'
GROUP BY Sales_month, Product_Category
ORDER BY Count DESC;
