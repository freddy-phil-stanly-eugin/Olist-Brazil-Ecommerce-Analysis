Use OLIST_ECOMMERCE;
-- Delivery time(purchase-delivered) and Diff btwn Estimated and Actual Delivery Date
SELECT 
    order_id,

    order_purchase_timestamp,

    order_delivered_customer_date,

    order_estimated_delivery_date,

    TIMESTAMPDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS delivery_time,

    TIMESTAMPDIFF(
        DAY,
        order_delivered_customer_date,
        order_estimated_delivery_date
    ) AS delivery_diff

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;

-- Identify the top 5 states with the highest average freight value

SELECT 
    a.customer_state,
    ROUND(AVG(c.freight_value),2) AS avg_freight

FROM customers AS a

INNER JOIN orders AS b
    ON a.customer_id = b.customer_id

INNER JOIN order_items AS c
    ON b.order_id = c.order_id

GROUP BY a.customer_state

ORDER BY avg_freight DESC
LIMIT 5;

-- Identify the least states with the Lowest freight value

SELECT 
    a.customer_state,
    ROUND(AVG(c.freight_value),2) AS avg_freight

FROM customers AS a

INNER JOIN orders AS b
    ON a.customer_id = b.customer_id

INNER JOIN order_items AS c
    ON b.order_id = c.order_id

GROUP BY a.customer_state

ORDER BY avg_freight DESC
LIMIT 5;




-- Average Delivery Time and Average Delivery Diff
SELECT 

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                DAY,
                order_purchase_timestamp,
                order_delivered_customer_date
            )
        ),
        1
    ) AS avg_delivery_time,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                DAY,
                order_delivered_customer_date,
                order_estimated_delivery_date
            )
        ),
        1
    ) AS avg_delivery_difference

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;

-- 	Identify the top 5 states with the highest & lowest average delivery times
-- Highest 5	
SELECT 
    a.customer_state,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                DAY,
                b.order_purchase_timestamp,
                b.order_delivered_customer_date
            )
        ),
        2
    ) AS avg_delivery_time

FROM customers AS a

INNER JOIN orders AS b
    ON a.customer_id = b.customer_id

WHERE b.order_delivered_customer_date IS NOT NULL

GROUP BY a.customer_state

ORDER BY avg_delivery_time DESC
limit 5;

-- Lowest
SELECT 
    a.customer_state,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                DAY,
                b.order_purchase_timestamp,
                b.order_delivered_customer_date
            )
        ),
        2
    ) AS avg_delivery_time

FROM customers AS a

INNER JOIN orders AS b
    ON a.customer_id = b.customer_id

WHERE b.order_delivered_customer_date IS NOT NULL

GROUP BY a.customer_state

ORDER BY avg_delivery_time asc
limit 5;
-- 	Identify the top 5 states where delivery is faster than the estimated date.
SELECT 
    a.customer_state,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                DAY,
                b.order_delivered_customer_date,
                b.order_estimated_delivery_date
            )
        ),
        2
    ) AS avg_early_delivery_days

FROM customers AS a

INNER JOIN orders AS b
    ON a.customer_id = b.customer_id

WHERE b.order_delivered_customer_date IS NOT NULL

AND b.order_delivered_customer_date 
    < b.order_estimated_delivery_date

GROUP BY a.customer_state

ORDER BY avg_early_delivery_days DESC

LIMIT 5;