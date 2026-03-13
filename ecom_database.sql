DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE users(
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products(
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders(
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items(
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments(
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE deliveries(
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    delivery_status VARCHAR(50),
    delivery_date DATE,
    courier VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO users(name,email,phone,address)
VALUES
('Rahul Sharma','rahul@gmail.com','9876543210','Delhi'),
('Priya Singh','priya@gmail.com','9123456780','Mumbai'),
('Aman Gupta','aman@gmail.com','9988776655','Lucknow'),
('Riya Verma','riya@gmail.com','9012345678','Noida');

INSERT INTO products(product_name,category,price,stock)
VALUES
('Laptop','Electronics',65000,10),
('Smartphone','Electronics',30000,25),
('Headphones','Accessories',2000,50),
('Keyboard','Accessories',1500,40),
('Monitor','Electronics',12000,20);

INSERT INTO orders(user_id,order_date,total_amount,status)
VALUES
(1,'2026-03-10',65000,'Placed'),
(2,'2026-03-11',30000,'Placed'),
(3,'2026-03-11',2000,'Placed');

INSERT INTO order_items(order_id,product_id,quantity,price)
VALUES
(1,1,1,65000),
(2,2,1,30000),
(3,3,1,2000);

INSERT INTO payments(order_id,payment_method,payment_status,amount,payment_date)
VALUES
(1,'UPI','Paid',65000,'2026-03-10'),
(2,'Card','Paid',30000,'2026-03-11'),
(3,'Cash','Pending',2000,'2026-03-11');

INSERT INTO deliveries(order_id,delivery_status,delivery_date,courier)
VALUES
(1,'Shipped','2026-03-11','BlueDart'),
(2,'Processing','2026-03-12','Delhivery');

SELECT * FROM users;

SELECT * FROM products;

SELECT * FROM orders;

UPDATE products
SET stock = stock - 1
WHERE product_id = 1;

DELETE FROM orders
WHERE status='Cancelled';

SELECT o.order_id, u.name, o.order_date, o.total_amount
FROM orders o
JOIN users u
ON o.user_id = u.user_id;

SELECT o.order_id, p.product_name, oi.quantity, oi.price
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id;

SELECT u.name, o.order_id, p.payment_method, p.payment_status
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id;

SELECT o.order_id, u.name, d.delivery_status
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id;

CREATE VIEW order_summary AS
SELECT
o.order_id,
u.name,
o.total_amount,
o.status
FROM orders o
JOIN users u
ON o.user_id = u.user_id;

DELIMITER //

CREATE TRIGGER reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE getUserOrders(IN uid INT)
BEGIN
    SELECT *
    FROM orders
    WHERE user_id = uid;
END //

DELIMITER ;

CALL getUserOrders(1);

SELECT SUM(amount) AS total_revenue
FROM payments
WHERE payment_status='Paid';

SELECT product_id, SUM(quantity) AS total_sold
FROM order_items
GROUP BY product_id
ORDER BY total_sold DESC;

SELECT user_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id;
