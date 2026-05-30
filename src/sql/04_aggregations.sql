-- =====================================================
-- AGGREGATIONS
-- Навыки: GROUP BY, HAVING, ROLLUP, CUBE, GROUPING SETS
-- =====================================================

-- 1. Простая группировка: выручка по каналам продаж
SELECT 
    channel,
    COUNT(*) as transaction_count,
    SUM(revenue) as total_revenue,
    ROUND(AVG(revenue), 2) as avg_revenue,
    MIN(revenue) as min_revenue,
    MAX(revenue) as max_revenue
FROM retail_sales
GROUP BY channel
ORDER BY total_revenue DESC;


-- 2. Группировка по двум полям: выручка по региону и каналу
SELECT 
    region,
    channel,
    COUNT(*) as transaction_count,
    SUM(revenue) as total_revenue,
    ROUND(AVG(revenue), 2) as avg_revenue
FROM retail_sales
GROUP BY region, channel
ORDER BY region, total_revenue DESC
LIMIT 30;


-- 3. HAVING: фильтрация после группировки
-- Найти регионы с общей выручкой больше 400 000
SELECT 
    region,
    SUM(revenue) as total_revenue,
    COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY region
HAVING SUM(revenue) > 400000
ORDER BY total_revenue DESC;


-- 4. HAVING с несколькими условиями
-- Регионы, где больше 100 транзакций И средний чек выше 100
SELECT 
    region,
    COUNT(*) as transaction_count,
    ROUND(AVG(revenue), 2) as avg_revenue,
    SUM(revenue) as total_revenue
FROM retail_sales
GROUP BY region
HAVING COUNT(*) > 100 AND AVG(revenue) > 100
ORDER BY transaction_count DESC;


-- 5. ROLLUP: промежуточные итоги по иерархии (регион → канал)
-- Суммирует: по региону+каналу, потом по региону (субтотал), потом общий итог
SELECT 
    region,
    channel,
    SUM(revenue) as total_revenue,
    COUNT(*) as transaction_count
FROM retail_sales
GROUP BY ROLLUP(region, channel)
ORDER BY region, channel;


-- 6. CUBE: все возможные комбинации группировок
-- Суммирует: по региону+каналу, по региону, по каналу, и общий итог
SELECT 
    region,
    channel,
    SUM(revenue) as total_revenue
FROM retail_sales
GROUP BY CUBE(region, channel)
ORDER BY region, channel;


-- 7. GROUPING SETS: произвольные наборы группировок
-- Только три конкретных среза: (регион), (канал), (регион+канал)
SELECT 
    region,
    channel,
    SUM(revenue) as total_revenue,
    GROUPING(region) as region_grouped,
    GROUPING(channel) as channel_grouped
FROM retail_sales
GROUP BY GROUPING SETS ((region), (channel), (region, channel))
ORDER BY region, channel;


-- 8. Агрегация с фильтрацией внутри (FILTER)
-- Сравнить выручку онлайн и офлайн каналов
SELECT 
    region,
    SUM(revenue) FILTER (WHERE channel = 'Online') as online_revenue,
    SUM(revenue) FILTER (WHERE channel = 'Store') as store_revenue,
    SUM(revenue) FILTER (WHERE channel = 'Mobile') as mobile_revenue
FROM retail_sales
GROUP BY region
ORDER BY region;


-- 9. COUNT(DISTINCT) и соотношения
-- Сколько уникальных клиентов, товаров, средний чек на клиента
SELECT 
    COUNT(DISTINCT customer_id) as unique_customers,
    COUNT(DISTINCT product_title) as unique_products,
    ROUND(SUM(revenue) / COUNT(DISTINCT customer_id), 2) as revenue_per_customer
FROM retail_sales;


-- 10. Группировка по датам: выручка по месяцам
SELECT 
    DATE_TRUNC('month', date) as month,
    SUM(revenue) as total_revenue,
    COUNT(*) as transaction_count,
    COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;