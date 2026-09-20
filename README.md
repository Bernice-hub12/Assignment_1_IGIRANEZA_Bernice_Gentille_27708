# Sunrise Supermarket – PL/SQL Assignment One(1)

## My Information

**Name:** IGIRANEZA Bernice Gentille
**Student ID:** 27708
**Database Management System:** PostgreSQL

## Business Scenario

Sunrise Supermarket sells different products to customers. Customers place orders containing one or more products. The supermarket management needs to analyze customer information, purchases, and sales trends.

This project uses PostgreSQL to create and populate the supermarket database and demonstrates the use of JOINs, Common Table Expressions (CTEs), and Window Functions.

## Database Structure

The database contains four main tables:

* **customers** – stores customer information such as name, email, and city.
* **products** – stores product names, categories, and prices.
* **orders** – stores customer orders and order dates.
* **order_items** – stores the products and quantities included in each order.

The database was populated with:

* 5 customers
* 8 products
* 5 product categories
* 15 orders
* 26 order items
* Orders distributed across multiple dates

## JOIN Queries

### 1. Orders with Customer Information

This query uses an INNER JOIN between the `orders` and `customers` tables.

It displays each order together with the customer's name, city, and order date.

**Business interpretation:**
This allows the supermarket to identify which customer placed each order and where the customer is located.

**Result:**
See `screenshots/join1.png`.

### 2. Order Items with Product Information

This query joins `order_items` with `products`.

It displays the product name, category, price, and quantity for each order item.

**Business interpretation:**
This helps the supermarket understand which products were purchased and in what quantities.

**Result:**
See `screenshots/join2.png`.

### 3. All Customers and Their Orders

This query uses a LEFT JOIN between `customers` and `orders`.

It includes customers even when they have no orders.

**Business interpretation:**
This can help management identify customers who have not yet made any purchases.

**Result:**
See `screenshots/join3.png`.

## Common Table Expression (CTE)

### Customers Above Average Spending

The CTE first calculates the total amount spent by each customer using:

`quantity × price`

The main query then compares each customer's total spending with the average customer spending and returns customers whose spending is above average.

**Business interpretation:**
Management can identify customers who contribute more revenue than the average customer.

**Result:**
See `screenshots/cte.png`.

## Window Functions

### 1. Rank Customers by Total Spending

The `RANK()` window function ranks customers according to their total spending, with the highest spender receiving the first rank.

**Business interpretation:**
This helps management understand customer spending patterns.

**Result:**
See `screenshots/window1.png`.

### 2. Number Each Customer's Orders

The `ROW_NUMBER()` window function numbers each customer's orders according to the order date.

**Business interpretation:**
This allows the supermarket to see the sequence of purchases made by each customer.

**Result:**
See `screenshots/window2.png`.

### 3. Running Total Revenue

A window function calculates the cumulative revenue over time based on order dates.

**Business interpretation:**
Management can use the running total to monitor how revenue accumulates over the selected period.

**Result:**
See `screenshots/window3.png`.

### 4. Days Between Customer Orders

The `LAG()` window function retrieves each customer's previous order date. The difference between the current and previous order dates is then calculated.

**Business interpretation:**
This helps management understand how frequently customers return to make purchases.

**Result:**
See `screenshots/window4.png`.

## Challenges and Resolutions

One challenge was adapting the provided database schema to PostgreSQL because the original schema used Oracle-style data types such as `NUMBER` and `VARCHAR2`.

The solution was to use PostgreSQL-compatible types such as `INTEGER`, `VARCHAR`, and `NUMERIC`.

Another challenge was calculating customer spending while still including customers who had no orders. This was handled using `LEFT JOIN` and `COALESCE()`.

## How to Run the Project

1. Create a PostgreSQL database named `sunrise_supermarket`.
2. Run `sql/01_create_tables.sql` to create the tables.
3. Run `sql/02_insert_data.sql` to insert the sample data.
4. Run `sql/03_queries.sql` to execute the JOIN, CTE, and Window Function queries.
5. The screenshots in the `screenshots` folder show the query results.
