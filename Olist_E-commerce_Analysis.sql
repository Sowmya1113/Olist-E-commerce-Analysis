CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;

CREATE TABLE customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
) ENGINE=InnoDB;

CREATE TABLE sellers (
    seller_id VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)
) ENGINE=InnoDB;

CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE products (
    product_id VARCHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    FOREIGN KEY (product_category_name) REFERENCES product_category_translation(product_category_name)
) ENGINE=InnoDB;

CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) ENGINE=InnoDB;

CREATE TABLE order_items (
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
) ENGINE=InnoDB;

CREATE TABLE order_payments (
    order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
) ENGINE=InnoDB;

CREATE TABLE order_reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    PRIMARY KEY (review_id, order_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
) ENGINE=InnoDB;

CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10,7),
    geolocation_lng DECIMAL(10,7),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
) ENGINE=InnoDB;


SHOW TABLES;


SHOW VARIABLES LIKE 'secure_file_priv';


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
INTO TABLE product_category_translation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category_name, @product_name_length, @product_description_length,
 @product_photos_qty, @product_weight_g, @product_length_cm, @product_height_cm, @product_width_cm)
SET
    product_name_length = NULLIF(@product_name_length, ''),
    product_description_length = NULLIF(@product_description_length, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');

SET FOREIGN_KEY_CHECKS = 1;


SELECT DISTINCT p.product_category_name
FROM products p
LEFT JOIN product_category_translation t ON p.product_category_name = t.product_category_name
WHERE t.product_category_name IS NULL;


SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, @order_purchase_timestamp, @order_approved_at,
 @order_delivered_carrier_date, @order_delivered_customer_date, @order_estimated_delivery_date)
SET
    order_purchase_timestamp = NULLIF(@order_purchase_timestamp, ''),
    order_approved_at = NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date, '');

SET FOREIGN_KEY_CHECKS = 1;


SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 1;

USE olist_ecommerce;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE order_reviews;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_cleaned.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, order_id, review_score, review_comment_title, review_comment_message,
 @review_creation_date, @review_answer_timestamp)
SET
    review_creation_date = STR_TO_DATE(@review_creation_date, '%d-%m-%Y %H.%i'),
    review_answer_timestamp = STR_TO_DATE(@review_answer_timestamp, '%d-%m-%Y %H.%i.%s');

SET FOREIGN_KEY_CHECKS = 1;

SELECT COUNT(*) FROM order_reviews;


SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 1;

SELECT COUNT(*) FROM geolocation;



SELECT 'customers' AS tbl, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM product_category_translation
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation;



SELECT
    o.order_id,
    o.customer_id,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
FROM orders o
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
LIMIT 10;


WITH delivery_delay AS (
    SELECT
        o.order_id,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    COUNT(*) AS total_orders,
    ROUND(AVG(dd.delay_days), 2) AS avg_delay_days,
    SUM(CASE WHEN dd.delay_days > 0 THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN dd.delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM delivery_delay dd
JOIN order_items oi ON dd.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t ON p.product_category_name = t.product_category_name
GROUP BY category
HAVING total_orders >= 30
ORDER BY late_pct DESC
LIMIT 15;


SELECT COUNT(*) FROM products WHERE product_category_name IS NULL;


SELECT COUNT(*) FROM products WHERE product_category_name = '';



WITH delivery_delay AS (
    SELECT
        o.order_id,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    s.seller_state,
    COUNT(*) AS total_orders,
    ROUND(AVG(dd.delay_days), 2) AS avg_delay_days,
    ROUND(SUM(CASE WHEN dd.delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct,
    RANK() OVER (ORDER BY AVG(dd.delay_days) DESC) AS delay_rank
FROM delivery_delay dd
JOIN order_items oi ON dd.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
HAVING total_orders >= 30
ORDER BY avg_delay_days DESC;


CREATE TEMPORARY TABLE geo_avg AS
SELECT
    geolocation_zip_code_prefix AS zip_prefix,
    AVG(geolocation_lat) AS lat,
    AVG(geolocation_lng) AS lng
FROM geolocation
GROUP BY geolocation_zip_code_prefix;


DROP TEMPORARY TABLE IF EXISTS geo_avg;

CREATE TABLE geo_avg AS
SELECT
    geolocation_zip_code_prefix AS zip_prefix,
    AVG(geolocation_lat) AS lat,
    AVG(geolocation_lng) AS lng
FROM geolocation
GROUP BY geolocation_zip_code_prefix;

SELECT
    dd.order_id,
    dd.delay_days,
    ROUND(
        111.045 * DEGREES(ACOS(
            LEAST(1, GREATEST(-1,
                COS(RADIANS(cg.lat)) * COS(RADIANS(sg.lat)) *
                COS(RADIANS(sg.lng) - RADIANS(cg.lng)) +
                SIN(RADIANS(cg.lat)) * SIN(RADIANS(sg.lat))
            ))
        )), 1
    ) AS distance_km
FROM (
    SELECT
        o.order_id,
        o.customer_id,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
) dd
JOIN customers c ON dd.customer_id = c.customer_id
JOIN geo_avg cg ON c.customer_zip_code_prefix = cg.zip_prefix
JOIN order_items oi ON dd.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
JOIN geo_avg sg ON s.seller_zip_code_prefix = sg.zip_prefix
LIMIT 100;



WITH delivery_delay AS (
    SELECT
        o.order_id,
        o.customer_id,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),
order_distance AS (
    SELECT
        dd.order_id,
        dd.delay_days,
        ROUND(
            111.045 * DEGREES(ACOS(
                LEAST(1, GREATEST(-1,
                    COS(RADIANS(cg.lat)) * COS(RADIANS(sg.lat)) *
                    COS(RADIANS(sg.lng) - RADIANS(cg.lng)) +
                    SIN(RADIANS(cg.lat)) * SIN(RADIANS(sg.lat))
                ))
            )), 1
        ) AS distance_km
    FROM delivery_delay dd
    JOIN customers c ON dd.customer_id = c.customer_id
    JOIN geo_avg cg ON c.customer_zip_code_prefix = cg.zip_prefix
    JOIN order_items oi ON dd.order_id = oi.order_id
    JOIN sellers s ON oi.seller_id = s.seller_id
    JOIN geo_avg sg ON s.seller_zip_code_prefix = sg.zip_prefix
)
SELECT
    CASE
        WHEN distance_km < 100 THEN '1. Under 100km'
        WHEN distance_km < 500 THEN '2. 100-500km'
        WHEN distance_km < 1000 THEN '3. 500-1000km'
        WHEN distance_km < 2000 THEN '4. 1000-2000km'
        ELSE '5. Over 2000km'
    END AS distance_bucket,
    COUNT(*) AS total_orders,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    ROUND(SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM order_distance
GROUP BY distance_bucket
ORDER BY distance_bucket;

WITH delivery_delay AS (
    SELECT
        o.order_id,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    CASE
        WHEN dd.delay_days <= 0 THEN '1. On time or early'
        WHEN dd.delay_days BETWEEN 1 AND 7 THEN '2. Late by 1-7 days'
        WHEN dd.delay_days BETWEEN 8 AND 14 THEN '3. Late by 8-14 days'
        ELSE '4. Late by 15+ days'
    END AS delay_bucket,
    COUNT(*) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_bad_reviews
FROM delivery_delay dd
JOIN order_reviews r ON dd.order_id = r.order_id
GROUP BY delay_bucket
ORDER BY delay_bucket;


WITH customer_delay_status AS (
    SELECT
        c.customer_unique_id,
        MAX(CASE WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) > 0 THEN 1 ELSE 0 END) AS ever_delayed
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY c.customer_unique_id
),
customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN cds.ever_delayed = 1 THEN 'Experienced a delay' ELSE 'Never delayed' END AS customer_group,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN coc.total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_purchase_rate_pct
FROM customer_delay_status cds
JOIN customer_order_counts coc ON cds.customer_unique_id = coc.customer_unique_id
GROUP BY customer_group;


WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS order_rank,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),
customer_totals AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    CASE WHEN fo.delay_days > 0 THEN 'First order was late' ELSE 'First order was on time' END AS first_order_experience,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN ct.total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_who_ordered_again
FROM first_orders fo
JOIN customer_totals ct ON fo.customer_unique_id = ct.customer_unique_id
WHERE fo.order_rank = 1
GROUP BY first_order_experience;

-- First, get average order value
SELECT ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(oi.price + oi.freight_value) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id
) order_totals;

WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS order_rank,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),
late_first_order_customers AS (
    SELECT COUNT(*) AS total_late_first_orders
    FROM first_orders
    WHERE order_rank = 1 AND delay_days > 0
)
SELECT
    total_late_first_orders,
    ROUND(total_late_first_orders * 0.0054, 0) AS estimated_lost_repeat_customers,
    ROUND(total_late_first_orders * 0.0054 * 159.83, 2) AS estimated_revenue_at_risk_reais
FROM late_first_order_customers;


WITH delivery_delay AS (
    SELECT
        o.order_id,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    s.seller_id,
    s.seller_state,
    COUNT(*) AS total_orders,
    ROUND(SUM(CASE WHEN dd.delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM delivery_delay dd
JOIN order_items oi ON dd.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_state
HAVING total_orders >= 50 AND late_pct >= 20
ORDER BY late_pct DESC, total_orders DESC
LIMIT 20;

-- View 1: Delay by category
CREATE OR REPLACE VIEW vw_delay_by_category AS
WITH delivery_delay AS (
    SELECT o.order_id,
           DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name) AS category,
    COUNT(*) AS total_orders,
    ROUND(AVG(dd.delay_days), 2) AS avg_delay_days,
    ROUND(SUM(CASE WHEN dd.delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM delivery_delay dd
JOIN order_items oi ON dd.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t ON p.product_category_name = t.product_category_name
GROUP BY category
HAVING total_orders >= 30;

-- View 2: Delay by seller state
CREATE OR REPLACE VIEW vw_delay_by_state AS
WITH delivery_delay AS (
    SELECT o.order_id,
           DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    s.seller_state,
    COUNT(*) AS total_orders,
    ROUND(AVG(dd.delay_days), 2) AS avg_delay_days,
    ROUND(SUM(CASE WHEN dd.delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM delivery_delay dd
JOIN order_items oi ON dd.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_state
HAVING total_orders >= 30;

-- View 3: Delay by distance bucket
CREATE OR REPLACE VIEW vw_delay_by_distance AS
WITH delivery_delay AS (
    SELECT o.order_id, o.customer_id,
           DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),
order_distance AS (
    SELECT dd.order_id, dd.delay_days,
        ROUND(111.045 * DEGREES(ACOS(LEAST(1, GREATEST(-1,
            COS(RADIANS(cg.lat)) * COS(RADIANS(sg.lat)) * COS(RADIANS(sg.lng) - RADIANS(cg.lng)) +
            SIN(RADIANS(cg.lat)) * SIN(RADIANS(sg.lat))
        )))), 1) AS distance_km
    FROM delivery_delay dd
    JOIN customers c ON dd.customer_id = c.customer_id
    JOIN geo_avg cg ON c.customer_zip_code_prefix = cg.zip_prefix
    JOIN order_items oi ON dd.order_id = oi.order_id
    JOIN sellers s ON oi.seller_id = s.seller_id
    JOIN geo_avg sg ON s.seller_zip_code_prefix = sg.zip_prefix
)
SELECT
    CASE
        WHEN distance_km < 100 THEN '1. Under 100km'
        WHEN distance_km < 500 THEN '2. 100-500km'
        WHEN distance_km < 1000 THEN '3. 500-1000km'
        WHEN distance_km < 2000 THEN '4. 1000-2000km'
        ELSE '5. Over 2000km'
    END AS distance_bucket,
    COUNT(*) AS total_orders,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    ROUND(SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM order_distance
GROUP BY distance_bucket;

-- View 4: Review score by delay severity
CREATE OR REPLACE VIEW vw_review_by_delay AS
WITH delivery_delay AS (
    SELECT o.order_id,
           DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    CASE
        WHEN dd.delay_days <= 0 THEN '1. On time or early'
        WHEN dd.delay_days BETWEEN 1 AND 7 THEN '2. Late by 1-7 days'
        WHEN dd.delay_days BETWEEN 8 AND 14 THEN '3. Late by 8-14 days'
        ELSE '4. Late by 15+ days'
    END AS delay_bucket,
    COUNT(*) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pct_bad_reviews
FROM delivery_delay dd
JOIN order_reviews r ON dd.order_id = r.order_id
GROUP BY delay_bucket;

-- View 5: Flagged high-late-rate sellers
CREATE OR REPLACE VIEW vw_flagged_sellers AS
WITH delivery_delay AS (
    SELECT o.order_id,
           DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT
    s.seller_id, s.seller_state,
    COUNT(*) AS total_orders,
    ROUND(SUM(CASE WHEN dd.delay_days > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS late_pct
FROM delivery_delay dd
JOIN order_items oi ON dd.order_id = oi.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_state
HAVING total_orders >= 50 AND late_pct >= 20;

SHOW FULL TABLES WHERE Table_type = 'VIEW';