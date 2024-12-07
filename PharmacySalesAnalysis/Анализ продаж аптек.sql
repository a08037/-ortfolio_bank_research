WITH customer_orders AS (
    SELECT
        c.customer_id,
        CONCAT(c.last_name, ' ', c.first_name, ' ', c.second_name) AS full_name,
        DATE_TRUNC('month', TO_DATE(p.report_date, 'YYYY-MM-DD')) AS month,
        SUM(p.price * p.count) AS total_sales
    FROM
        pharma_orders p
    JOIN
        customers c ON p.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        full_name,
        DATE_TRUNC('month', TO_DATE(p.report_date, 'YYYY-MM-DD'))
),
cumulative_sales AS (
    SELECT
        customer_id,
        full_name,
        month,
        SUM(total_sales) OVER (PARTITION BY customer_id ORDER BY month) AS cumulative_sales
    FROM
        customer_orders
)
SELECT
    customer_id,
    full_name,
    TO_CHAR(month, 'Month YYYY') AS month_name,
    cumulative_sales
FROM
    cumulative_sales
ORDER BY
    customer_id,
    month;
