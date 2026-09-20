# Sunrise Supermarket – PLSQL Assignment One

## Student Information

**Full Name:** IGIRANEZA Bernice Gentille
**Student ID:** 27708
**Group:** Group C
**Database Management System:** PostgreSQL

## 1. Business Scenario

Sunrise Supermarket sells products to customers who place orders containing one or more items. Management wants to understand who their customers are, what they buy, and how sales are trending over time.

For this assignment, a PostgreSQL database was created and populated with sample supermarket data. JOINs, a Common Table Expression (CTE), and Window Functions were then used to analyze customers, orders, products, and revenue.

### Database Population

The database contains:

* 5 customers
* 8 products
* 5 product categories
* 15 orders
* 26 order items
* Orders distributed across multiple dates

## 2. Database Structure

The database contains four tables:

* **customers** – stores customer information such as name, email, and city.
* **products** – stores product names, categories, and prices.
* **orders** – stores customer orders and order dates.
* **order_items** – stores the products and quantities included in each order.

## 3. JOIN Queries

### JOIN 1: Orders with Customer Information

**Purpose:** List every order with the customer's name, city, and order date.

**SQL Query:**

```sql
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;
```

**Explanation:**

An `INNER JOIN` connects the `orders` table with the `customers` table using `customer_id`. This allows customer information to be displayed together with order information.

**Business Interpretation:**

This helps the supermarket identify which customer placed each order and the city associated with that customer.

**Result:**

See `Screenshots/Join1.png`.

---

### JOIN 2: Order Items with Product Information

**Purpose:** List every order item with product name, category, price, and quantity.

**SQL Query:**

```sql
SELECT
    oi.order_item_id,
    oi.order_id,
    p.product_name,
    p.category,
    p.price,
    oi.quantity
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.order_item_id;
```

**Explanation:**

This `INNER JOIN` connects `order_items` with `products` using `product_id`. It combines information about the purchased quantity with the corresponding product details.

**Business Interpretation:**

This helps the supermarket understand which products were purchased, their categories, prices, and the quantities purchased.

**Result:**

See `Screenshots/Join2.png`.

---

### JOIN 3: All Customers and Their Orders

**Purpose:** List all customers and their orders, including customers who have no orders.

**SQL Query:**

```sql
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;
```

**Explanation:**

A `LEFT JOIN` keeps every customer from the `customers` table. If a customer has no order, the order information appears as `NULL`.

**Business Interpretation:**

This allows management to identify both active customers and customers who have not yet placed an order.

**Result:**

See `Screenshots/Join3.png`.

## 4. Common Table Expression (CTE)

### Customers Above Average Spending

**Purpose:** Calculate each customer's total spending and return customers whose spending is above the average.

**SQL Query:**

```sql
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(SUM(oi.quantity * p.price), 0) AS total_spend
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend
FROM customer_totals
WHERE total_spend > (
    SELECT AVG(total_spend)
    FROM customer_totals
)
ORDER BY total_spend DESC;
```

**Explanation:**

The CTE named `customer_totals` first calculates the total amount spent by every customer using:

`quantity × price`

The main query then calculates the average spending and returns customers whose total spending is greater than that average.

`COALESCE()` is used so that customers with no orders have a total spending value of zero.

**Business Interpretation:**

This helps management identify customers whose spending is above the average customer spending level.

**Result:**

See `Screenshots/CTE.png`.

## 5. Window Functions

### Window Function 1: Rank Customers by Total Spending

**Purpose:** Rank customers according to their total amount spent, with the highest spending ranked first.

**SQL Query:**

```sql
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(SUM(oi.quantity * p.price), 0) AS total_spend
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    LEFT JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend,
    RANK() OVER (
        ORDER BY total_spend DESC
    ) AS spending_rank
FROM customer_totals
ORDER BY spending_rank;
```

**Explanation:**

The `RANK()` window function assigns a ranking to each customer based on total spending. The `DESC` order means customers with higher spending receive higher positions.

**Business Interpretation:**

This allows management to compare customer spending levels and identify the customers with the highest total purchases.

**Result:**

See `Screenshots/Window1.png`.

---

### Window Function 2: Number Each Customer's Orders

**Purpose:** Number each customer's orders according to the order date.

**SQL Query:**

```sql
SELECT
    customer_id,
    order_id,
    order_date,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS order_number
FROM orders
ORDER BY customer_id, order_date;
```

**Explanation:**

`ROW_NUMBER()` gives each order a sequential number. `PARTITION BY customer_id` makes the numbering restart for each customer, while `ORDER BY order_date` places the orders in chronological order.

**Business Interpretation:**

This helps the supermarket see the sequence of purchases made by each customer.

**Result:**

See `Screenshots/Window2.png`.

---

### Window Function 3: Running Total Revenue

**Purpose:** Show a running total of revenue over time.

**SQL Query:**

```sql
WITH order_revenue AS (
    SELECT
        o.order_id,
        o.order_date,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        o.order_id,
        o.order_date
)
SELECT
    order_id,
    order_date,
    order_revenue,
    SUM(order_revenue) OVER (
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM order_revenue
ORDER BY order_date, order_id;
```

**Explanation:**

The CTE first calculates the revenue for each order. The window function then adds each order's revenue to the revenue from all previous orders to produce a cumulative running total.

**Business Interpretation:**

This allows management to monitor how total revenue accumulates over time and observe sales trends across the selected dates.

**Result:**

See `Screenshots/Window3.png`.

---

### Window Function 4: Days Between Customer Orders

**Purpose:** Show the number of days between each customer's current order and their previous order.

**SQL Query:**

```sql
WITH order_history AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
)
SELECT
    customer_id,
    order_id,
    order_date,
    previous_order_date,
    order_date - previous_order_date AS days_between_orders
FROM order_history
WHERE previous_order_date IS NOT NULL
ORDER BY customer_id, order_date;
```

**Explanation:**

`LAG()` retrieves the previous order date for each customer. The previous date is then subtracted from the current order date to calculate the number of days between purchases.

The first order of each customer is excluded because it has no previous order.

**Business Interpretation:**

This helps management understand customer purchasing frequency and how often customers return to make another purchase.

**Result:**

See `Screenshots/Window4.png`.

## 6. Challenges and Resolutions

### Challenge 1: Database Compatibility

The provided schema used Oracle-style data types such as `NUMBER` and `VARCHAR2`, while this project was implemented using PostgreSQL.

**Resolution:** The data types were adapted to PostgreSQL-compatible types such as `INTEGER`, `VARCHAR`, and `NUMERIC`.

### Challenge 2: Customers with No Orders

The analysis needed to include customers who had not placed any orders.

**Resolution:** A `LEFT JOIN` was used to retain all customers, and `COALESCE()` was used in the spending calculations to represent customers with no purchases as having zero spending.

## 7. How to Run the Project

1. Open PostgreSQL/pgAdmin.
2. Create a database named `sunrise_supermarket`.
3. Open and run `Sql/01_Create_Tables.sql` to create the tables.
4. Run `Sql/02_Insert_Data.sql` to populate the tables with sample data.
5. Run `Sql/03_Queries.sql` to execute all JOIN, CTE, and Window Function queries.
6. The query results are shown in the screenshots stored in the `Screenshots` folder.

## 8. Project Files

```text
Assignment_1_IGIRANEZA_Bernice_Gentille_27708/
│
├── README.md
│
├── Sql/
│   ├── 01_Create_Tables.sql
│   ├── 02_Insert_Data.sql
│   └── 03_Queries.sql
│
└── Screenshots/
    ├── CTE.png
    ├── Join1.png
    ├── Join2.png
    ├── Join3.png
    ├── Window1.png
    ├── Window2.png
    ├── Window3.png
    └── Window4.png
```
