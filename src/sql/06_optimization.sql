-- =====================================================
-- OPTIMIZATION 
-- =====================================================

-- 1. EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT region, SUM(revenue)
FROM retail_sales
WHERE date > '2024-01-01'
GROUP BY region;

-- 2. Создание индекса
CREATE INDEX IF NOT EXISTS idx_retail_sales_date ON retail_sales(date);

-- 3. Проверка после индекса
EXPLAIN ANALYZE
SELECT region, SUM(revenue)
FROM retail_sales
WHERE date > '2024-01-01'
GROUP BY region;

-- 4. Составной индекс
CREATE INDEX IF NOT EXISTS idx_retail_sales_date_channel ON retail_sales(date, channel);

-- 5. Анализ размера таблицы
SELECT 
    relname as table_name,
    pg_size_pretty(pg_total_relation_size(oid)) as total_size
FROM pg_class
WHERE relname = 'retail_sales';

-- 6. Обновление статистики
ANALYZE retail_sales;