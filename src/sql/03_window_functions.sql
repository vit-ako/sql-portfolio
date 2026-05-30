-- =====================================================
-- WINDOW FUNCTIONS
-- =====================================================

-- 1. ROW_NUMBER() - порядковый номер транзакции для каждого клиента
SELECT 
    customer_id,
    transaction_id,
    date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY date DESC) as transaction_seq
FROM retail_sales
LIMIT 20;


-- 2. RANK() - ранжирование транзакций по выручке внутри канала
SELECT 
    channel,
    transaction_id,
    revenue,
    RANK() OVER (PARTITION BY channel ORDER BY revenue DESC) as rank_by_revenue
FROM retail_sales
WHERE revenue > 0
LIMIT 30;


-- 3. LAG() - предыдущая покупка клиента (работает для клиентов с 2+ покупками)
SELECT 
    customer_id,
    date,
    revenue,
    LAG(revenue) OVER (PARTITION BY customer_id ORDER BY date) as prev_revenue
FROM retail_sales
LIMIT 30;


-- 4. LEAD() - следующая покупка клиента
SELECT 
    customer_id,
    date,
    revenue,
    LEAD(date) OVER (PARTITION BY customer_id ORDER BY date) as next_purchase_date
FROM retail_sales
LIMIT 30;


-- 5. FIRST_VALUE() - дата первой покупки клиента
SELECT 
    customer_id,
    date as current_date,
    FIRST_VALUE(date) OVER (PARTITION BY customer_id ORDER BY date) as first_purchase_date
FROM retail_sales
LIMIT 30;


-- 6. SUM() OVER() - накопительная сумма выручки
-- Суммирует revenue по всем строкам до текущей
SELECT 
    transaction_id,
    date,
    revenue,
    SUM(revenue) OVER (ORDER BY date) as running_total
FROM retail_sales
ORDER BY date
LIMIT 30;


-- 7. AVG() OVER() - скользящее среднее по 3 предыдущим транзакциям
SELECT 
    transaction_id,
    date,
    revenue,
    AVG(revenue) OVER (ORDER BY date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as moving_avg
FROM retail_sales
ORDER BY date
LIMIT 30;


-- 8. NTILE() - разбить клиентов на 4 группы по сумме покупок
-- Сначала считаем сумму на клиента, потом применяем NTILE
WITH customer_spent AS (
    SELECT 
        customer_id,
        SUM(revenue) as total_spent
    FROM retail_sales
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_spent,
    NTILE(4) OVER (ORDER BY total_spent) as spent_quartile
FROM customer_spent
LIMIT 30;