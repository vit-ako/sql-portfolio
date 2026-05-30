-- создаём таблицу
CREATE TABLE IF NOT EXISTS retail_sales (
    product_title TEXT,
    rating VARCHAR(20),
    transaction_id VARCHAR(50) PRIMARY KEY,
    date DATE,
    channel VARCHAR(20),
    region VARCHAR(50),
    customer_id VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    revenue DECIMAL(10,2)
);

