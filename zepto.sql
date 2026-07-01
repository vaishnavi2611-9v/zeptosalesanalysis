create database zepto_Project;

create table zepto(
id INT AUTO_INCREMENT PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150)Not NUll,
mrp Numeric (8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSeliingPrice Numeric(8,2),
weightInGms INTEGER,
outOfStock varchar(10),
quantity INTEGER
);

Update zepto 
set outOfStock = 
case 
when outOfStock='TRUE' then '1'
when outOfStock='FALSE'then'0'
end;


-- DATA EXPLORATION

-- COUNT OF ROWS 
select COUNT(*)from zepto;

-- SAMPLE DATA
select *from zepto
where name IS NULL
or category  IS NULL 
or mrp IS NULL
or discountPercent IS NULL
or discountedSeliingPrice IS NULL
or weightInGms IS NULL
or availableQuantity IS NULL 
or outOfStock IS NULL
or quantity IS NULL ;

-- DIFFERENT PRODUCT CATEGORIES
SELECT DISTINCT Category from zepto order by category;

-- PRODUCTS IN STOCK VS OUT OF STOCK
SELECT outOfStock,count(category)
from zepto
group by outOfStock;

-- PRODUCT NAMES PRESENT MULTIPLE TIMES
select name, count(Category)as "number of category"
from zepto
group by name
having count(Category)>1
order by count(category)desc;

-- DATA CLEANING

-- PRODUCTS WITH PRICE=0
select*from zepto where mrp=0 or discountedSeliingPrice=0;
delete from zepto where mrp=0;

-- CONVERT PAISE INTO RUPPES
Update zepto
set mrp = mrp/100.0,
discountedSeliingPrice = discountedSeliingPrice/100.0;

select mrp,discountedseliingPrice from zepto;


-- data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name,mrp
FROM zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSeliingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSeliingPrice,
ROUND(discountedSeliingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

-- Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

