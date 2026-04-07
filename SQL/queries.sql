USE ecommerce;

-- Most Ordered Product
SELECT p.product_name , COUNT(oi.product_id) AS `count`
FROM Order_items oi 
JOIN Products p 
ON oi.product_id = p.product_id 
GROUP BY p.product_name 
ORDER BY `count` DESC
LIMIT 1;


-- Most ordered category
SELECT p.category , COUNT(oi.product_id) AS `Count`
FROM Order_items oi 
JOIN Products p 
ON oi.product_id =p.product_id 
GROUP BY p.category
ORDER BY `Count` DESC
LIMIT 1;


-- Top 5 Products by Revenue 
SELECT  p.product_name , SUM(oi.quantity * oi.unit_price) AS Revenue
FROM Order_items oi 
JOIN Products p 
ON oi.product_id = p.product_id 
GROUP BY p.product_id 
ORDER BY Revenue DESC
LIMIT 5;


-- Category-wise Revenue
SELECT  p.category , SUM(oi.quantity * oi.unit_price) AS Revenue
FROM Order_items oi 
RIGHT JOIN Products p 
ON oi.product_id = p.product_id 
GROUP BY p.category
ORDER BY Revenue DESC;


-- Common Payment Method
SELECT payment_method ,COUNT(payment_method) AS `Count`
FROM Payments 
GROUP BY payment_method 
ORDER BY `Count` DESC
LIMIT 1;


-- Customers who ordered most
SELECT c.name , COUNT(o.order_id) AS Customer_Orders_Count
FROM Customers c 
LEFT JOIN Orders o 
ON c.customer_id = o.customer_id 
GROUP BY c.name
ORDER BY Customer_Orders_Count DESC
LIMiT 5;


-- Monthly sales revenue trend
SELECT MONTHNAME(o.order_date) AS Month_name, SUM(oi.quantity * oi.unit_price) AS Revenue
FROM Orders o
LEFT JOIN Order_items oi ON o.order_id = oi.order_id
GROUP BY Month_name, MONTH(o.order_date)
ORDER BY MONTH(o.order_date);


-- Cancelled and pending , Delivered count/percentage
SELECT status , COUNT(*) as `Count` ,ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM Orders),2) AS `Percentage`
FROM Orders
GROUP BY status;


-- Customers who never ordered
SELECT name 
FROM Customers 
WHERE customer_id NOT IN (
  SELECT customer_id 
  FROM Orders
  );
 
 
-- Repeat vs one time buyers
SELECT c.name ,
CASE 
  	WHEN COUNT(o.customer_id) <=1 THEN 'One-Time Buyer'
    WHEN COUNT(o.customer_id) > 1 THEN 'Repeat Buyer'
    ELSE 'No Orders'
   END AS Buyer_Type
FROM Customers c 
LEFT JOIN Orders o 
ON c.customer_id = o.customer_id
GROUP BY c.name;


-- Percentage of Repeat and One time Buyers 
WITH buyer_cte AS(
  SELECT c.name , 
  CASE 
  	WHEN COUNT(o.customer_id)<=1 THEN 'One-Time Buyer'
    WHEN COUNT(o.customer_id)>1 THEN 'Repeat Buyer'
    ELSE 'No Orders'
  END AS Buyer_Type
  FROM Customers c 
  LEFT JOIN Orders o 
  ON c.customer_id = o.customer_id
  GROUP BY c.name
  )
 SELECT Buyer_Type , COUNT(*) , ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM buyer_cte),2) AS `Percentage`
 FROM buyer_cte
 GROUP BY Buyer_Type;
 
 
 -- Customers who ordered once and never returned
SELECT c.name , COUNT(o.customer_id) AS `Count`
FROM Customers c 
LEFT JOIN Orders o 
ON c.customer_id = o.customer_id 
GROUP BY c.name
HAVING COUNT(o.customer_id) =1;


-- Top 3 products per category
WITH category_cte AS (
  SELECT p.category ,p.product_name ,
  SUM(oi.quantity*oi.unit_price) AS Revenue,
  DENSE_RANK() OVER(
    PARTITION BY p.category
    ORDER BY SUM(oi.quantity*oi.unit_price) DESC )  AS rnk
  	FROM Products p 
  	LEFT JOIN Order_items oi
    ON p.product_id = oi.product_id 
  	GROUP BY p.category , p.product_name 
  )
SELECT category,product_name,Revenue,rnk
FROM category_cte 
WHERE rnk<=3;


-- Monthly revenue growth
WITH monthly_cte AS (
  SELECT MONTH(o.order_date) AS Month_number,
  MONTHNAME(o.order_date) AS Month_name ,
  SUM(oi.quantity*oi.unit_price) AS Revenue
  FROM Orders o 
  LEFT JOIN Order_items oi 
  ON o.order_id = oi.order_id 
  GROUP BY MONTHNAME(o.order_date) , MONTH(o.order_date)
  ORDER BY MONTH(o.order_date)
  ),
 Growth_cte AS(
   SELECT Month_name , Revenue ,
 LAG(Revenue) OVER(ORDER BY Month_number) AS prev_month_revenue
   FROM monthly_cte
   )
 SELECT Month_name , Revenue , prev_month_revenue , ROUND((Revenue-prev_month_revenue)/prev_month_revenue*100 ,2) as Growth_Percentage
 FROM Growth_cte;
 
 
 --  Revenue contribution by top 5 customers
WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        c.name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM Customers c
    JOIN Orders o 
        ON c.customer_id = o.customer_id
    JOIN Order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.name
),

ranked_customers AS (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS rnk
    FROM customer_revenue
),

total AS (
    SELECT SUM(total_revenue) AS overall_revenue
    FROM customer_revenue
)

SELECT 
    rc.name,
    rc.total_revenue,
    ROUND((rc.total_revenue * 100.0) / t.overall_revenue, 2) AS percentage_contribution
FROM ranked_customers rc
CROSS JOIN total t
WHERE rc.rnk <= 5;


