-- Строим матрицу удержания клиентов (Retention Matrix) по когортам
WITH first_purchase AS (
    SELECT customer_id, MIN(DATE_TRUNC('month', invoice_date)) AS cohort_month
    FROM invoice 
    GROUP BY customer_id
),
customer_activity AS (
    SELECT 
        i.customer_id,
        f.cohort_month,
        (EXTRACT(YEAR FROM i.invoice_date) * 12 + EXTRACT(MONTH FROM i.invoice_date)) - 
        (EXTRACT(YEAR FROM f.cohort_month) * 12 + EXTRACT(MONTH FROM f.cohort_month)) AS month_number
    FROM invoice i 
    JOIN first_purchase f ON i.customer_id = f.customer_id
),
cohort_data AS (
    SELECT 
        cohort_month, 
        month_number, 
        COUNT(DISTINCT customer_id) AS users
    FROM customer_activity
    GROUP BY cohort_month, month_number
)
SELECT 
    cohort_month AS "Когорта (Месяц прихода)",
    MAX(CASE WHEN month_number = 0 THEN users ELSE 0 END) AS "Мес 0",
    MAX(CASE WHEN month_number = 1 THEN users ELSE 0 END) AS "Мес 1",
    MAX(CASE WHEN month_number = 2 THEN users ELSE 0 END) AS "Мес 2",
    MAX(CASE WHEN month_number = 3 THEN users ELSE 0 END) AS "Мес 3",
    MAX(CASE WHEN month_number = 4 THEN users ELSE 0 END) AS "Мес 4",
    MAX(CASE WHEN month_number = 5 THEN users ELSE 0 END) AS "Мес 5",
    MAX(CASE WHEN month_number = 6 THEN users ELSE 0 END) AS "Мес 6"
FROM cohort_data
GROUP BY cohort_month
ORDER BY cohort_month;