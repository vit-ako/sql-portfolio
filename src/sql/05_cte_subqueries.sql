-- =====================================================
-- CTE AND SUBQUERIES
-- Навыки: подзапросы, WITH, многоуровневые CTE
-- =====================================================

-- 1. Простой подзапрос в WHERE
-- Найти товары, цена которых выше средней цены по всем товарам
SELECT DISTINCT
    product_title,
    price
FROM retail_sales
WHERE price > (SELECT AVG(price) FROM retail_sales)
ORDER BY price DESC
LIMIT 20;


-- 2. Подзапрос в SELECT (скалярный)
-- Для каждой транзакции показать средний чек по её каналу
SELECT 
    transaction_id,
    channel,
    revenue,
    (SELECT ROUND(AVG(revenue), 2) FROM retail_sales r2 WHERE r2.channel = r1.channel) as channel_avg_revenue
FROM retail_sales r1
LIMIT 20;


-- 3. Подзапрос с EXISTS
-- Найти клиентов, которые покупали через канал Mobile
SELECT DISTINCT customer_id
FROM retail_sales r1
WHERE EXISTS (
    SELECT 1 FROM retail_sales r2 
    WHERE r2.customer_id = r1.customer_id AND r2.channel = 'Mobile'
)
LIMIT 20;


-- 4. Простая CTE (WITH) 
-- Посчитать общую выручку на клиента, затем найти среднюю выручку среди топ-100 клиентов
WITH customer_revenue AS (
    SELECT 
        customer_id,
        SUM(revenue) as total_spent,
        COUNT(*) as order_count
    FROM retail_sales
    GROUP BY customer_id
),
top_100_customers AS (
    SELECT total_spent, order_count
    FROM customer_revenue
    ORDER BY total_spent DESC
    LIMIT 100
)
SELECT 
    ROUND(AVG(total_spent), 2) as avg_spent_top100,
    ROUND(AVG(order_count), 2) as avg_orders_top100
FROM top_100_customers;


-- 5. CTE с несколькими подзапросами
-- Найти клиентов, которые покупали чаще среднего И тратили больше среднего
WITH customer_stats AS (
    SELECT 
        customer_id,
        COUNT(*) as order_count,
        SUM(revenue) as total_spent
    FROM retail_sales
    GROUP BY customer_id
),
global_avg AS (
    SELECT 
        AVG(order_count) as avg_orders,
        AVG(total_spent) as avg_spent
    FROM customer_stats
)
SELECT 
    cs.customer_id,
    cs.order_count,
    cs.total_spent,
    ROUND(ga.avg_orders, 2) as avg_orders_global,
    ROUND(ga.avg_spent, 2) as avg_spent_global
FROM customer_stats cs, global_avg ga
WHERE cs.order_count > ga.avg_orders 
  AND cs.total_spent > ga.avg_spent
ORDER BY cs.total_spent DESC
LIMIT 30;


-- 6. CTE с оконной функцией внутри
-- Для каждого клиента посчитать его вклад в выручку региона
WITH customer_region_share AS (
    SELECT 
        region,
        customer_id,
        SUM(revenue) as customer_revenue,
        SUM(SUM(revenue)) OVER (PARTITION BY region) as region_total
    FROM retail_sales
    GROUP BY region, customer_id
)
SELECT 
    region,
    customer_id,
    customer_revenue,
    region_total,
    ROUND(100.0 * customer_revenue / region_total, 2) as pct_of_region
FROM customer_region_share
WHERE region_total > 0
ORDER BY region, pct_of_region DESC
LIMIT 30;


-- 7. Многоуровневые CTE (цепочка)
-- Анализ: какие товары приносят 80% выручки (Pareto)
WITH product_revenue AS (
    SELECT 
        product_title,
        SUM(revenue) as total_revenue
    FROM retail_sales
    GROUP BY product_title
),
total_revenue AS (
    SELECT SUM(total_revenue) as all_revenue FROM product_revenue
),
ranked_products AS (
    SELECT 
        product_title,
        total_revenue,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC) as running_total,
        (SELECT all_revenue FROM total_revenue) as grand_total
    FROM product_revenue
)
SELECT 
    product_title,
    total_revenue,
    ROUND(100.0 * running_total / grand_total, 2) as cumulative_pct
FROM ranked_products
WHERE running_total <= 0.8 * grand_total
ORDER BY cumulative_pct
LIMIT 30;


-- 8. Рекурсивная CTE (пример для последовательности чисел)
-- Простая демонстрация рекурсии (работает всегда)
WITH RECURSIVE numbers(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;


-- 9. Подзапрос с IN
-- Найти товары, которые покупали клиенты из региона Europe
SELECT DISTINCT product_title
FROM retail_sales
WHERE customer_id IN (
    SELECT DISTINCT customer_id 
    FROM retail_sales 
    WHERE region = 'Europe'
)
LIMIT 20;