E-commerce Data Analysis with SQL
This repository (or project) contains SQL scripts for setting up a basic e-commerce database and performing various data analysis tasks using standard SQL queries.

Table of Contents
Project Overview

Database Setup

Data Analysis Queries

Basic Queries

Using JOINS

Writing Subqueries

Using Aggregate Functions

Creating Views

Optimizing Queries with Indexes

Deliverables

Tools

Project Overview
This project demonstrates how to create a relational database schema for an e-commerce platform and then leverage SQL queries to extract meaningful insights from the data. It covers fundamental to intermediate SQL concepts essential for data analysis.

Database Setup
Before running the analysis queries, you need to set up the ecommerce_db database and populate it with sample data.

Create the Database and Tables:
Execute the following SQL script in your MySQL Workbench (or chosen SQL client) to create the ecommerce_db database and all its associated tables (Categories, Products, Customers, Orders, Order_Items, Reviews).

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Table for Product Categories
CREATE TABLE IF NOT EXISTS Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Table for Products
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    category_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Table for Customers
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- In real apps, store hashed passwords
    phone_number VARCHAR(20),
    address TEXT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for Orders
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(50) DEFAULT 'Pending', -- e.g., 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Table for Order Items (to link products to orders)
CREATE TABLE IF NOT EXISTS Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL, -- Price when order was placed
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Table for Reviews (Optional)
CREATE TABLE IF NOT EXISTS Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

Insert Sample Data:
After creating the tables, execute the following INSERT statements to populate them with sample data.

-- Insert into Categories
INSERT INTO Categories (category_name, description) VALUES
('Electronics', 'Gadgets and electronic devices'),
('Apparel', 'Clothing and accessories'),
('Books', 'Fiction and non-fiction books'),
('Home Goods', 'Items for the home');

-- Insert into Products
INSERT INTO Products (product_name, description, price, stock_quantity, category_id, image_url) VALUES
('Laptop Pro', 'Powerful laptop for professionals', 1200.00, 50, (SELECT category_id FROM Categories WHERE category_name = 'Electronics'), 'http://example.com/laptop_pro.jpg'),
('Wireless Headphones', 'Noise-cancelling headphones', 150.00, 200, (SELECT category_id FROM Categories WHERE category_name = 'Electronics'), 'http://example.com/headphones.jpg'),
('T-Shirt (Medium)', '100% cotton t-shirt', 25.00, 300, (SELECT category_id FROM Categories WHERE category_name = 'Apparel'), 'http://example.com/tshirt.jpg'),
('The Great Novel', 'A captivating fiction novel', 15.99, 100, (SELECT category_id FROM Categories WHERE category_name = 'Books'), 'http://example.com/novel.jpg'),
('Coffee Maker', 'Automatic drip coffee maker', 75.50, 80, (SELECT category_id FROM Categories WHERE category_name = 'Home Goods'), 'http://example.com/coffee_maker.jpg');

-- Insert into Customers
INSERT INTO Customers (first_name, last_name, email, password_hash, phone_number, address) VALUES
('Alice', 'Smith', 'alice.smith@example.com', 'hashed_pass_123', '9876543210', '123 Main St, Anytown'),
('Bob', 'Johnson', 'bob.j@example.com', 'hashed_pass_456', '9988776655', '456 Oak Ave, Othercity');

-- Insert into Orders
INSERT INTO Orders (customer_id, total_amount, order_status) VALUES
((SELECT customer_id FROM Customers WHERE email = 'alice.smith@example.com'), 1225.00, 'Processing'),
((SELECT customer_id FROM Customers WHERE email = 'bob.j@example.com'), 15.99, 'Pending');

-- Insert into Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity, price_at_purchase) VALUES
((SELECT order_id FROM Orders WHERE customer_id = (SELECT customer_id FROM Customers WHERE email = 'alice.smith@example.com') AND total_amount = 1225.00), (SELECT product_id FROM Products WHERE product_name = 'Laptop Pro'), 1, 1200.00),
((SELECT order_id FROM Orders WHERE customer_id = (SELECT customer_id FROM Customers WHERE email = 'alice.smith@example.com') AND total_amount = 1225.00), (SELECT product_id FROM Products WHERE product_name = 'T-Shirt (Medium)'), 1, 25.00),
((SELECT order_id FROM Orders WHERE customer_id = (SELECT customer_id FROM Customers WHERE email = 'bob.j@example.com') AND total_amount = 15.99), (SELECT product_id FROM Products WHERE product_name = 'The Great Novel'), 1, 15.99);

-- Insert into Reviews
INSERT INTO Reviews (product_id, customer_id, rating, comment) VALUES
((SELECT product_id FROM Products WHERE product_name = 'Laptop Pro'), (SELECT customer_id FROM Customers WHERE email = 'alice.smith@example.com'), 5, 'Absolutely love this laptop! Fast and reliable.'),
((SELECT product_id FROM Products WHERE product_name = 'The Great Novel'), (SELECT customer_id FROM Customers WHERE email = 'bob.j@example.com'), 4, 'Good read, but took a while to get into.');

Data Analysis Queries
The SQL Queries for E-commerce Data Analysis Canvas contains a comprehensive set of queries categorized by SQL concepts. Refer to that Canvas for the specific queries.

Basic Queries
This section covers fundamental SELECT, WHERE, ORDER BY, and GROUP BY clauses to retrieve and sort data.

Using JOINS
Learn how to combine data from multiple tables using INNER JOIN, LEFT JOIN, and RIGHT JOIN.

Writing Subqueries
Explore how to use nested queries to solve more complex data retrieval problems.

Using Aggregate Functions
Understand how to use SUM, AVG, COUNT, MIN, and MAX to summarize data.

Creating Views
Learn to create virtual tables (views) to simplify complex queries and enhance data access.

Optimizing Queries with Indexes
Discover how to improve query performance by creating indexes on frequently accessed columns.

Deliverables
For each query provided in the SQL Queries for E-commerce Data Analysis Canvas:

Execute the SQL query in your chosen SQL client (e.g., MySQL Workbench).

Take a screenshot of the SQL query itself as it appears in your editor.

Take a screenshot of the query's output (the result set) in the result grid.

Compile these queries into a .sql file and the screenshots into a document (e.g., PDF or Word document).

Tools
Database: MySQL (or PostgreSQL, SQLite)

Client: MySQL Workbench (or pgAdmin, DBeaver, DB Browser for SQLite)
