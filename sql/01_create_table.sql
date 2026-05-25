-- ============================================
-- 01_create_table.sql
-- Создание таблиц для практики
-- ============================================

-- Удаляем таблицы, если они уже существуют (для повторного запуска)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- Таблица пользователей
CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    email       VARCHAR(255) NOT NULL UNIQUE,
    username    VARCHAR(100) NOT NULL,
    role        VARCHAR(20)  NOT NULL DEFAULT 'customer',
    created_at  TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- Таблица категорий товаров
CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Таблица товаров
CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    description TEXT,
    price       NUMERIC(10, 2) NOT NULL DEFAULT 0,
    in_stock    BOOLEAN NOT NULL DEFAULT TRUE,
    category_id INTEGER REFERENCES categories(id),
    created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Таблица заказов
CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL REFERENCES users(id),
    status      VARCHAR(20) NOT NULL DEFAULT 'created',
    total_price NUMERIC(10, 2) NOT NULL DEFAULT 0,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Таблица позиций заказа (связь заказ ↔ товар)
CREATE TABLE order_items (
    id          SERIAL PRIMARY KEY,
    order_id    INTEGER NOT NULL REFERENCES orders(id),
    product_id  INTEGER NOT NULL REFERENCES products(id),
    quantity    INTEGER NOT NULL DEFAULT 1,
    price       NUMERIC(10, 2) NOT NULL
);