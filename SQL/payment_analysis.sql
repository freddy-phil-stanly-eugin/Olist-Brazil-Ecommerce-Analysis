-- Month-on-Month number of orders placed using different payment types
SELECT 
    a.payment_type,

    EXTRACT(YEAR FROM b.order_purchase_timestamp) AS order_year,

    EXTRACT(MONTH FROM b.order_purchase_timestamp) AS order_month,

    COUNT(b.order_id) AS total_orders

FROM payments AS a

INNER JOIN orders AS b
    ON a.order_id = b.order_id

GROUP BY
    a.payment_type,
    order_year,
    order_month

ORDER BY
    a.payment_type,
    order_year,
    order_month;
    
-- Number of orders based on payment installments
SELECT 
    payment_installments,

    COUNT(order_id) AS total_orders,

    ROUND(
        COUNT(order_id) * 100.0 /
        SUM(COUNT(order_id)) OVER(),
        2
    ) AS percentage_orders
FROM payments
WHERE payment_installments > 0
GROUP BY payment_installments
ORDER BY payment_installments;
