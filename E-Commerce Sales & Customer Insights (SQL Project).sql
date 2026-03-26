#  E-Commerce Sales & Customer Insights – Complete SQL Project
# Create Database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;


# Create Tables
## Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE
);

## Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2)
);

## Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

## Order Details Table
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

# Insert Sample Data
## Insert Customers
INSERT INTO customers VALUES
(1,'Rahul','Sharma','rahul@gmail.com','Bangalore','Karnataka','2023-01-15'),
(2,'Priya','Mehta','priya@gmail.com','Mumbai','Maharashtra','2023-02-10'),
(3,'Amit','Verma','amit@gmail.com','Delhi','Delhi','2023-03-05'),
(4,'Sneha','Reddy','sneha@gmail.com','Hyderabad','Telangana','2023-04-20'),
(5,'Vikram','Patel','vikram@gmail.com','Ahmedabad','Gujarat','2023-05-18');


## Insert Products
INSERT INTO products VALUES
(101,'iPhone 14','Electronics',70000,60000),
(102,'Samsung TV','Electronics',50000,42000),
(103,'Nike Shoes','Fashion',6000,3500),
(104,'Laptop','Electronics',80000,72000),
(105,'Washing Machine','Home Appliances',30000,25000);

## Insert Orders
INSERT INTO orders VALUES
(1001,1,'2023-06-01',76000),
(1002,2,'2023-06-10',50000),
(1003,3,'2023-07-05',6000),
(1004,1,'2023-07-15',80000),
(1005,4,'2023-08-01',30000),
(1006,5,'2023-08-10',70000);

## Insert Order Details
INSERT INTO order_details VALUES
(1,1001,101,1,70000),
(2,1001,103,1,6000),
(3,1002,102,1,50000),
(4,1003,103,1,6000),
(5,1004,104,1,80000),
(6,1005,105,1,30000),
(7,1006,101,1,70000);


# Business Analysis Queries
## Total Revenue

SELECT SUM(total_amount) AS total_revenue
FROM orders;

##  Monthly Sales Trend
SELECT MONTH(order_date) AS month, SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY MONTH(order_date)
ORDER BY month;

## Top Selling Products
SELECT p.product_name, SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

## Revenue by Category
SELECT p.category, SUM(od.quantity * od.price) AS category_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

## Top Customers by Spending
SELECT c.customer_id, CONCAT(c.first_name,' ',c.last_name) AS customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC;


## Customer Lifetime Value (CLV)
SELECT c.customer_id, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS lifetime_value
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

## Average Order Value (AOV)
SELECT ROUND(AVG(total_amount),2) AS average_order_value
FROM orders;

## Most Profitable Products
SELECT p.product_name, SUM((od.price - p.cost) * od.quantity) AS total_profit
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC;
