-- создаём таблицу
DROP TABLE retail_sales;
CREATE TABLE retail_sales (
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

-- загружаем данные из CSV
COPY retail_sales
FROM 'retailhive_10k.csv'
DELIMITER ','
CSV HEADER;
