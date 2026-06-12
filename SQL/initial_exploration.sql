Use OLIST_ECOMMERCE;
-- Time range between the orders placed
select MIN(order_purchase_timestamp) as 'first_order_date',MAX(order_purchase_timestamp) as 'latest_order_date' from orders;
-- Total No of cities and states
SELECT 
    COUNT(DISTINCT a.customer_city) AS total_cities,
    COUNT(DISTINCT a.customer_state) AS total_states
FROM customers AS a
INNER JOIN orders AS b
    ON a.customer_id = b.customer_id;

