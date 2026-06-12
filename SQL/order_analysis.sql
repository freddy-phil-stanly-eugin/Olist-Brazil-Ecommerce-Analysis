Use OLIST_ECOMMERCE;
-- Order trends
SELECT 
    EXTRACT(YEAR FROM order_purchase_timestamp) AS order_year,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_year
ORDER BY order_year;

-- monthly seasonality for orders
SELECT 
    DATE(order_purchase_timestamp) AS order_date,
    COUNT(order_id) AS total_orders
FROM orders
WHERE DATE(order_purchase_timestamp) BETWEEN '2018-01-01' AND '2018-03-31'
GROUP BY order_date
ORDER BY total_orders desc
LIMIT 20;

-- Time of Day Trends

WITH time_category AS (

    SELECT
        order_id,

        CASE
            WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 5
                THEN 'Dawn'
            WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 6 AND 11
                THEN 'Morning'
            WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 12 AND 17
                THEN 'Afternoon'
            ELSE 'Night'
        END AS time_of_day

    FROM orders
)

SELECT
    time_of_day,
    COUNT(order_id) AS total_orders

FROM time_category

GROUP BY time_of_day

ORDER BY total_orders DESC; 
