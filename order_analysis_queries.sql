
-- 1. Monthly Revenue and Order Volume
SELECT
    STRFTIME('%Y', order_date) AS year,
    STRFTIME('%m', order_date) AS month,
    SUM(amount) AS monthly_revenue,
    COUNT(DISTINCT order_id) AS order_volume
FROM
    orders
GROUP BY
    year, month
ORDER BY
    year, month;

-- 2. Top 3 Highest Revenue Months
SELECT
    STRFTIME('%Y-%m', order_date) AS year_month,
    SUM(amount) AS total_revenue
FROM
    orders
GROUP BY
    year_month
ORDER BY
    total_revenue DESC
LIMIT 3;

-- 3. Lowest Revenue Month
SELECT
    STRFTIME('%Y-%m', order_date) AS year_month,
    SUM(amount) AS total_revenue
FROM
    orders
GROUP BY
    year_month
ORDER BY
    total_revenue ASC
LIMIT 1;

-- 4. Daily Order Volume and Revenue
SELECT
    order_date,
    COUNT(order_id) AS total_orders,
    SUM(amount) AS total_revenue
FROM
    orders
GROUP BY
    order_date
ORDER BY
    order_date;

-- 5. Month-over-Month Revenue Change
WITH monthly_data AS (
    SELECT
        STRFTIME('%Y-%m', order_date) AS month,
        SUM(amount) AS revenue
    FROM
        orders
    GROUP BY
        month
),
changes AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly_data
)
SELECT
    month,
    revenue,
    prev_revenue,
    ROUND(((revenue - prev_revenue) * 100.0) / prev_revenue, 2) AS percent_change
FROM changes
WHERE prev_revenue IS NOT NULL;

-- 6. Average Order Value per Month
SELECT
    STRFTIME('%Y-%m', order_date) AS month,
    ROUND(SUM(amount) * 1.0 / COUNT(order_id), 2) AS avg_order_value
FROM
    orders
GROUP BY
    month
ORDER BY
    month;
