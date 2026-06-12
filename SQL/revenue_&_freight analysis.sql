USE OLIST_ECOMMERCE;
-- Analyzing money movement across the platform 
SELECT 
    ROUND(SUM(price),2) AS total_revenue,
    ROUND(AVG(price),2) AS avg_order_value,
    ROUND(SUM(freight_value),2) AS total_freight,
    ROUND(AVG(freight_value),1) AS avg_freight
FROM order_items;

-- Freight Contribution to Total Revenue 
SELECT 
    ROUND(SUM(price),2) AS total_revenue,
    
    ROUND(SUM(freight_value),2) AS total_freight,
    
    ROUND(
        (SUM(freight_value) / SUM(price)) * 100,
        2
    ) AS freight_percentage
FROM order_items;

-- Percentage increase in sales in 2018 compared to 2017
WITH yearly_revenue AS (

    SELECT
        
        EXTRACT(YEAR FROM b.order_purchase_timestamp) AS order_year,
        
        ROUND(SUM(a.price),2) AS total_revenue

    FROM order_items AS a

    INNER JOIN orders AS b
        ON a.order_id = b.order_id

    WHERE EXTRACT(MONTH FROM b.order_purchase_timestamp)
          BETWEEN 1 AND 8

      AND EXTRACT(YEAR FROM b.order_purchase_timestamp)
          IN (2017, 2018)

    GROUP BY order_year
)

SELECT 
ROUND(((MAX(total_revenue) - MIN(total_revenue))),2) AS revenue_increase,
ROUND(((MAX(total_revenue) - MIN(total_revenue))/ MIN(total_revenue)) * 100,2) AS percentage_increase
FROM yearly_revenue;

-- State Wise Revenue Analysis
SELECT 
    a.customer_state,
    
    ROUND(SUM(c.price),2) AS total_revenue,
    
    ROUND(AVG(c.price),2) AS avg_order_value

FROM customers AS a

INNER JOIN orders AS b
    ON a.customer_id = b.customer_id

INNER JOIN order_items AS c
    ON b.order_id = c.order_id

GROUP BY a.customer_state

ORDER BY total_revenue DESC,avg_order_value desc;

-- state wise Freight Analysis
SELECT 
    a.customer_state,
    ROUND(SUM(freight_value),2) AS total_freight,
    ROUND(AVG(c.freight_value),2) AS avg_freight

FROM customers AS a

INNER JOIN orders AS b
    ON a.customer_id = b.customer_id

INNER JOIN order_items AS c
    ON b.order_id = c.order_id

GROUP BY a.customer_state

ORDER BY avg_freight DESC;

