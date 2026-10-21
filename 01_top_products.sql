SELECT
    product_name,
    SUM(sales) AS total_revenue
FROM superstore
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 5;

