-- =====================================================
-- BASIC QUERIES
-- Навыки: фильтрация, сортировка, агрегация, GROUP BY
-- =====================================================

-- 1. Простая фильтрация и сортировка
-- Задача: Показать 10 самых дорогих транзакций (по revenue) за 2024 год
-- Навыки: WHERE, ORDER BY, LIMIT
SELECT 
    transaction_id,
    product_title,
    revenue,
    date,
    channel
FROM retail_sales
WHERE date >= '2024-01-01' AND date <= '2024-12-31'
ORDER BY revenue DESC
LIMIT 10;


-- 2. Агрегация с GROUP BY
-- Задача: Общая выручка и количество транзакций по каждому каналу продаж
-- Навыки: GROUP BY, COUNT, SUM
SELECT 
    channel,
    COUNT(*) as transaction_count,
    SUM(revenue) as total_revenue,
    ROUND(AVG(revenue), 2) as avg_revenue
FROM retail_sales
GROUP BY channel
ORDER BY total_revenue DESC;


-- 3. Фильтрация после агрегации (HAVING)
-- Задача: Найти регионы с общей выручкой больше 400 000
-- Навыки: HAVING, GROUP BY
SELECT 
    region,
    SUM(revenue) as total_revenue,
    COUNT(*) as transaction_count
FROM retail_sales
GROUP BY region
HAVING SUM(revenue) > 400000
ORDER BY total_revenue DESC;


-- 4. Простой подзапрос
-- Задача: Найти товары, цена которых выше средней цены всех товаров
-- Навыки: подзапрос, AVG, вложенный SELECT
SELECT 
    DISTINCT product_title,
    price
FROM retail_sales
WHERE price > (SELECT AVG(price) FROM retail_sales)
ORDER BY price DESC
LIMIT 20;


-- 5. Группировка с ROLLUP (промежуточные итоги)
-- Задача: Выручка по регионам и каналам с общими итогами
-- Навыки: ROLLUP, GROUP BY
SELECT 
    region,
    channel,
    SUM(revenue) as total_revenue
FROM retail_sales
GROUP BY ROLLUP(region, channel)
ORDER BY region, channel;


-- 6. CASE WHEN для категоризации
-- Задача: Разбить транзакции на категории по сумме выручки
-- Навыки: CASE WHEN, агрегация
SELECT 
    CASE 
        WHEN revenue < 50 THEN 'small (0-50)'
        WHEN revenue < 200 THEN 'medium (50-200)'
        ELSE 'large (200+)'
    END as transaction_size,
    COUNT(*) as count,
    ROUND(AVG(revenue), 2) as avg_revenue
FROM retail_sales
GROUP BY transaction_size
ORDER BY avg_revenue DESC;