CREATE DATABASE  ecommerce_db;
USE ecommerce_db;

CREATE TABLE  Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE  Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, 
    phone_number VARCHAR(20),
    address TEXT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE  Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(50) DEFAULT 'Pending', -- e.g., 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL, -- Price when order was placed
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE  Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


INSERT INTO Categories (category_name, description) VALUES
('Electronics', 'Gadgets and electronic devices'),
('Apparel', 'Clothing and accessories'),
('Books', 'Fiction and non-fiction books'),
('Home Goods', 'Items for the home');


INSERT INTO Products (product_name, description, price, stock_quantity, category_id, image_url) VALUES
('Laptop Pro', 'Powerful laptop for professionals', 1200.00, 50, (SELECT category_id FROM Categories WHERE category_name = 'Electronics'), 'http://example.com/laptop_pro.jpg'),
('Wireless Headphones', 'Noise-cancelling headphones', 150.00, 200, (SELECT category_id FROM Categories WHERE category_name = 'Electronics'), 'http://example.com/headphones.jpg'),
('T-Shirt (Medium)', '100% cotton t-shirt', 25.00, 300, (SELECT category_id FROM Categories WHERE category_name = 'Apparel'), 'http://example.com/tshirt.jpg'),
('The Great Novel', 'A captivating fiction novel', 15.99, 100, (SELECT category_id FROM Categories WHERE category_name = 'Books'), 'http://example.com/novel.jpg'),
('Coffee Maker', 'Automatic drip coffee maker', 75.50, 80, (SELECT category_id FROM Categories WHERE category_name = 'Home Goods'), 'http://example.com/coffee_maker.jpg');


INSERT INTO Customers (first_name, last_name, email, password_hash, phone_number, address) VALUES
('Alice', 'Smith', 'alice.smith@example.com', 'hashed_pass_123', '9876543210', '123 Main St, Anytown'),
('Bob', 'Johnson', 'bob.j@example.com', 'hashed_pass_456', '9988776655', '456 Oak Ave, Othercity');


INSERT INTO Orders (customer_id, total_amount, order_status) VALUES
((SELECT customer_id FROM Customers WHERE email = 'alice.smith@example.com'), 1225.00, 'Processing'),
((SELECT customer_id FROM Customers WHERE email = 'bob.j@example.com'), 15.99, 'Pending');

INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
((SELECT order_id FROM Orders WHERE customer_id = (SELECT customer_id FROM Customers WHERE email = 'alice.smith@example.com') AND total_amount = 1225.00), (SELECT product_id FROM Products WHERE product_name = 'Laptop Pro'), 1, 1200.00),
((SELECT order_id FROM Orders WHERE customer_id = (SELECT customer_id FROM Customers WHERE email = 'alice.smith@example.com') AND total_amount = 1225.00), (SELECT product_id FROM Products WHERE product_name = 'T-Shirt (Medium)'), 1, 25.00),
((SELECT order_id FROM Orders WHERE customer_id = (SELECT customer_id FROM Customers WHERE email = 'bob.j@example.com') AND total_amount = 15.99), (SELECT product_id FROM Products WHERE product_name = 'The Great Novel'), 1, 15.99);


INSERT INTO Reviews (product_id, customer_id, rating, comment) VALUES
((SELECT product_id FROM Products WHERE product_name = 'Laptop Pro'), (SELECT customer_id FROM Customers WHERE email = 'alice.smith@example.com'), 5, 'Absolutely love this laptop! Fast and reliable.'),
((SELECT product_id FROM Products WHERE product_name = 'The Great Novel'), (SELECT customer_id FROM Customers WHERE email = 'bob.j@example.com'), 4, 'Good read, but took a while to get into.');


Show Tables;
SELECT * FROM categories;
SELECT * FROM customerordersummary;
SELECT * FROM productsalesperformance;
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
Select * FROM products;
SELECT * FROM reviews;


SELECT customer_id, first_name, last_name, email, address
FROM Customers
WHERE address LIKE '%Anytown%';

SELECT product_name, price, stock_quantity
FROM Products
ORDER BY price DESC, product_name ASC;

SELECT c.category_name, COUNT(p.product_id) AS number_of_products
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY number_of_products DESC;

SELECT p.product_name, c.category\_name
FROM Products p
INNER JOIN Categories c ON p.category_id = c.category_id;

SELECT cust.first_name, cust.last_name, o.order_id, o.order_date, o.total_amount
FROM Customers cust
LEFT JOIN Orders o ON cust.customer_id = o.customer_id
ORDER BY cust.first_name, o.order_date;


SELECT p.product_name, oi.order_item_id, oi.quantity, oi.price_at_purchase
FROM Order_Items oi
RIGHT JOIN Products p ON oi.product_id = p.product_id
ORDER BY p.product_name;

SELECT first_name, last_name, email
FROM Customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE p.product_name = 'Laptop Pro'
);

SELECT product_name, price
FROM Products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM Order_Items
);

SELECT SUM(total_amount) AS total_revenue
FROM Orders;

SELECT AVG(p.price) AS average_electronics_price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics';

SELECT cust.first_name, cust.last_name, COUNT(o.order_id) AS number_of_orders
FROM Customers cust
LEFT JOIN Orders o ON cust.customer_id = o.customer_id
GROUP BY cust.customer_id, cust.first_name, cust.last_name
ORDER BY number_of_orders DESC;

SELECT MAX(price) AS highest_price, MIN(price) AS lowest_price
FROM Products;

CREATE VIEW CustomerOrderSummary AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC;

-- To query the view:
SELECT *
FROM CustomerOrderSummary;

CREATE VIEW ProductSalesPerformance AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price_at_purchase) AS total_product_revenue
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY p.product_id, p.product_name, c.category_name
ORDER BY total_product_revenue DESC;

-- To query the view:
SELECT *
FROM ProductSalesPerformance;

CREATE INDEX idx_orders_customer_id ON Orders (customer_id);

CREATE INDEX idx_products_product_name ON Products (product_name);

CREATE INDEX idx_customers_email ON Customers (email);







