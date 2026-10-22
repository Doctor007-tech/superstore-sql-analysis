-- Считаем средний процент удержания (Retention Rate) по всем когортам
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
cohort_sizes AS (
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS total_users
    FROM first_purchase 
    GROUP BY cohort_month
),
cohort_activity AS (
    SELECT 
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_id) AS active_users
    FROM customer_activity
    GROUP BY cohort_month, month_number
)
SELECT 
    ca.month_number AS "Месяц жизни",
    SUM(ca.active_users) AS "Всего вернулось",
    SUM(cs.total_users) AS "Всего было",
    ROUND((SUM(ca.active_users)::numeric / SUM(cs.total_users) * 100), 1) AS "Среднее удержание (%)"
FROM cohort_activity ca
JOIN cohort_sizes cs ON ca.cohort_month = cs.cohort_month
WHERE ca.month_number <= 6
GROUP BY ca.month_number
ORDER BY ca.month_number;