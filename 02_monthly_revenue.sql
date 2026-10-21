--Вариант 1. Выдаст более точную на 48 строк, каждый месяц за 4 года отдельно

SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS monthly_revenue
FROM superstore
GROUP BY month
ORDER BY month; 

--Вариант 2. Выдаст более наглядную аналитику по месяцам за все 4 года сразу

SELECT
    TO_CHAR(order_date, 'Month') AS month_name,
    SUM(sales) AS total_revenue
FROM superstore
GROUP BY month_name, EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date); --Выдаст аналитику с января по декабрь с названиями месяцев