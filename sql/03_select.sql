-- ============================================
-- 03_select.sql
-- Примеры SELECT-запросов разной сложности
-- ============================================

-- ------------------------------------------
-- Базовые SELECT
-- ------------------------------------------

-- Все товары
SELECT * FROM products;

-- Только название и цена
SELECT name, price FROM products;

-- Товары дороже 5000
SELECT name, price FROM products WHERE price > 5000;

-- Товары в наличии, отсортированные по цене (дорогие первые)
SELECT name, price, in_stock
FROM products
WHERE in_stock = TRUE
ORDER BY price DESC;

-- Первые 3 самых дешёвых товара
SELECT name, price
FROM products
ORDER BY price ASC
LIMIT 3;

-- ------------------------------------------
-- Агрегации: COUNT, SUM, AVG, MIN, MAX
-- ------------------------------------------

-- Сколько всего товаров?
SELECT COUNT(*) AS total_products FROM products;

-- Средняя цена товара
SELECT ROUND(AVG(price), 2) AS avg_price FROM products;

-- Самый дорогой и самый дешёвый товар
SELECT
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive
FROM products;

-- Общая сумма всех заказов
SELECT SUM(total_price) AS total_revenue FROM orders;

-- ------------------------------------------
-- GROUP BY + HAVING
-- ------------------------------------------

-- Сколько товаров в каждой категории
SELECT
    category_id,
    COUNT(*) AS product_count
FROM products
GROUP BY category_id;

-- Средняя цена по категориям (только где больше 1 товара)
SELECT
    category_id,
    COUNT(*) AS product_count,
    ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category_id
HAVING COUNT(*) > 1;

-- Количество заказов по статусам
SELECT
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status;

-- Пользователи, у которых больше 1 заказа
SELECT
    user_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1;

-- ------------------------------------------
-- Подзапросы
-- ------------------------------------------

-- Товары, которые дороже средней цены
SELECT name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Пользователи, у которых есть хотя бы один заказ
SELECT username, email
FROM users
WHERE id IN (SELECT DISTINCT user_id FROM orders);

-- Товары, которые никто не заказывал (NOT IN)
SELECT name, price
FROM products
WHERE id NOT IN (
    SELECT DISTINCT product_id FROM order_items
);

-- Коррелированный подзапрос: товары, цена которых выше средней в их категории
SELECT p.name, p.price, p.category_id
FROM products p
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);

-- ------------------------------------------
-- JOIN (обзорно — подробнее будет на следующей лекции)
-- ------------------------------------------

-- Товары с названиями их категорий
SELECT
    p.name  AS product_name,
    p.price,
    c.name  AS category_name
FROM products p
JOIN categories c ON p.category_id = c.id;

-- Заказы с именами пользователей
SELECT
    o.id         AS order_id,
    u.username,
    o.status,
    o.total_price
FROM orders o
JOIN users u ON o.user_id = u.id
ORDER BY o.total_price DESC;