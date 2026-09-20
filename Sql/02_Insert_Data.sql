INSERT INTO customers (customer_id, customer_name, email, city)
VALUES
(1, 'Alice Mukamana', 'alice@gmail.com', 'Kigali'),
(2, 'Eric Niyonzima', 'eric@gmail.com', 'Huye'),
(3, 'Diane Uwase', 'diane@gmail.com', 'Musanze'),
(4, 'Kevin Habimana', 'kevin@gmail.com', 'Kigali'),
(5, 'Grace Ingabire', 'grace@gmail.com', 'Rubavu');

INSERT INTO products (product_id, product_name, category, price)
VALUES
(1, 'Milk 1L', 'Dairy', 1200.00),
(2, 'Bread', 'Bakery', 1500.00),
(3, 'Yoghurt', 'Dairy', 1000.00),
(4, 'Orange Juice', 'Beverages', 2500.00),
(5, 'Mineral Water', 'Beverages', 800.00),
(6, 'Rice 5kg', 'Groceries', 7500.00),
(7, 'Laundry Soap', 'Household', 2000.00),
(8, 'Biscuits', 'Bakery', 1200.00);

INSERT INTO orders (order_id, customer_id, order_date)
VALUES
(101, 1, '2026-09-01'),
(102, 2, '2026-09-02'),
(103, 1, '2026-09-03'),
(104, 3, '2026-09-04'),
(105, 4, '2026-09-05'),
(106, 2, '2026-09-06'),
(107, 1, '2026-09-07'),
(108, 3, '2026-09-08'),
(109, 4, '2026-09-09'),
(110, 2, '2026-09-10'),
(111, 1, '2026-09-11'),
(112, 3, '2026-09-12'),
(113, 4, '2026-09-13'),
(114, 2, '2026-09-14'),
(115, 1, '2026-09-15');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity)
VALUES
(1, 101, 1, 2),
(2, 101, 2, 1),
(3, 102, 4, 2),
(4, 102, 5, 3),
(5, 103, 6, 1),
(6, 103, 3, 2),
(7, 104, 2, 2),
(8, 104, 8, 3),
(9, 105, 7, 2),
(10, 105, 1, 1),
(11, 106, 6, 2),
(12, 106, 5, 4),
(13, 107, 4, 1),
(14, 107, 3, 3),
(15, 108, 1, 2),
(16, 108, 8, 2),
(17, 109, 7, 1),
(18, 109, 2, 2),
(19, 110, 6, 1),
(20, 110, 4, 2),
(21, 111, 5, 5),
(22, 111, 1, 2),
(23, 112, 3, 4),
(24, 113, 7, 3),
(25, 114, 8, 5),
(26, 115, 1, 1);