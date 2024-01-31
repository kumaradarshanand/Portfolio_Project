/*	Creating Table */


CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
	tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);


/* Add the time_of_day column */


SELECT time,
	(CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
	) AS time_of_day
FROM sales;


ALTER TABLE sales ADD  time_of_day VARCHAR(20);


UPDATE sales
SET time_of_day = (
	CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);


/* Add day_name column */


SELECT date, 
  to_char(date, 'Day')
AS day_name 
FROM sales;


ALTER TABLE sales ADD day_name VARCHAR(10);


UPDATE sales 
SET day_name = to_char(date, 'Day');


/* Add month_name column */


SELECT date, 
  to_char(date, 'Month')
AS month_name 
FROM sales;


ALTER TABLE sales ADD month_name VARCHAR(10);


UPDATE sales 
SET month_name = to_char(date, 'Month');


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------


Q1: How many unique cities does the data have?

SELECT DISTINCT city FROM sales;


Q2: In which city is each branch?

SELECT DISTINCT city,branch FROM sales;


-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

Q1: How many unique product lines does the data have?

SELECT DISTINCT product_line 
FROM sales;

Q2:What is the most common payment method?

SELECT payment, COUNT(payment) AS c 
FROM sales
GROUP BY payment
ORDER BY c DESC;

Q3: What is the most selling product line?

SELECT product_line, SUM(quantity) as qty
FROM sales
GROUP BY product_line
ORDER BY qty DESC;


Q4: What is the total revenue by month?

SELECT month_name AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;


Q5: What month had the largest COGS?

SELECT month_name AS month, SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC;


Q6: What product line had the largest revenue?

SELECT product_line, SUM(total) AS total_revenve
FROM sales
GROUP BY product_line
ORDER BY total_revenve DESC;

Q7: What is the city with the largest revenue?

SELECT city, SUM(total) AS total_revenve
FROM sales
GROUP BY city
ORDER BY total_revenve DESC;


Q8: What product line had the largest VAT?

SELECT product_line, AVG(tax_pct) as avg_tax 
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

Q9: Fetch each product line and add a column to those product  line showing "Good", "Bad". 
     Good if its greater than average sales.

SELECT AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.51 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM sales
GROUP BY product_line;


Q10: Which branch sold more products than average product sold?

SELECT branch, SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

Q11: What is the most common product line by gender?

SELECT  product_line, gender, COUNT(quantity) AS total_cnt
FROM sales
GROUP BY product_line,gender
ORDER BY COUNT(quantity) DESC;

Q12: What is the average rating of each product line?

SELECT product_line, AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

Q1: Number of sales made in each time of the day per weekday? 

SELECT time_of_day, COUNT(invoice_id) 
FROM sales
GROUP BY time_of_day
ORDER BY COUNT(invoice_id) DESC;


Q2: Which of the customer types brings the most revenue?

SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

Q3: Which city has the largest tax/VAT percent?

SELECT city, AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY city
ORDER BY avg_tax DESC;

Q4: Which customer type pays the most in VAT?

SELECT customer_type, AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax DESC;


-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

Q1: How many unique customer types does the data have?

SELECT DISTINCT customer_type
FROM sales;

Q2: How many unique payment methods does the data have?

SELECT DISTINCT payment
FROM sales;


Q3: What is the most common customer type?

SELECT customer_type, COUNT(invoice_id)
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

Q4: Which customer type buys the most?

SELECT customer_type, SUM(quantity) AS quantity
FROM sales
GROUP BY customer_type
ORDER BY quantity DESC

Q5: What is the gender of most of the customers?

SELECT gender, COUNT (invoice_id) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

Q6: What is the gender distribution per branch?
 
SELECT  branch, gender, COUNT (invoice_id) AS gender_distribution_count
FROM sales
GROUP BY gender, branch
ORDER BY branch, gender;

Q7: Which time of the day do customers give most ratings?

SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

Q8: Which time of the day do customers give most ratings per branch?

SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'A'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'B'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = 'C'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

Q9: Which day fo the week has the best avg ratings?

SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

Q10: Which day of the week has the best average ratings per branch?

SELECT branch, day_name, AVG(rating) AS avg_rating
FROM sales
WHERE branch= 'A'
GROUP BY  day_name,branch
ORDER BY avg_rating DESC;

SELECT branch, day_name, AVG(rating) AS avg_rating
FROM sales
WHERE branch= 'B'
GROUP BY  day_name,branch
ORDER BY avg_rating DESC;

SELECT branch, day_name, AVG(rating) AS avg_rating
FROM sales
WHERE branch= 'C'
GROUP BY  day_name,branch
ORDER BY avg_rating DESC;
-- --------------------------------------------------------------------
-- -----------------------------


















