-- month on month numbers of orders placed in each state
SELECT 
    a.customer_state,
    
    EXTRACT(YEAR FROM b.order_purchase_timestamp) AS order_year,
    
    EXTRACT(MONTH FROM b.order_purchase_timestamp) AS order_month,
    
    COUNT(b.order_id) AS total_orders

FROM customers AS a

INNER JOIN orders AS b
    ON a.customer_id = b.customer_id

GROUP BY
    a.customer_state,
    order_year,
    order_month

ORDER BY
    a.customer_state,
    order_year,
    order_month;
    
-- Highest orders state
WITH monthly_orders AS (

    SELECT 
        a.customer_state,

        EXTRACT(MONTH FROM b.order_purchase_timestamp) AS order_month,
        EXTRACT(YEAR FROM b.order_purchase_timestamp) AS order_year,

        COUNT(b.order_id) AS total_orders

    FROM customers AS a

    INNER JOIN orders AS b
        ON a.customer_id = b.customer_id

    GROUP BY
        a.customer_state,
        order_year,order_month
),

ranked_orders AS (

    SELECT *,
    
    RANK() OVER(
        PARTITION BY customer_state,order_year
        ORDER BY total_orders DESC
    ) AS month_rank

    FROM monthly_orders
)

SELECT customer_state,order_year,order_month,total_orders,month_rank
FROM ranked_orders
where month_rank<=3
order by customer_state,order_year,order_month,month_rank;
-- Customer Distribution across States

SELECT customer_state,
    
    COUNT(DISTINCT customer_id) AS total_customers

FROM customers

GROUP BY customer_state

ORDER BY total_customers DESC;