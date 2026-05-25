-- ============================================
-- 02_insert.sql
-- Заполнение таблиц тестовыми данными
-- ============================================

-- Пользователи
INSERT INTO users (email, username, role) VALUES
    ('alice@mail.com',   'alice',   'customer'),
    ('bob@mail.com',     'bob',     'customer'),
    ('charlie@mail.com', 'charlie', 'admin'),
    ('diana@mail.com',   'diana',   'customer'),
    ('eve@mail.com',     'eve',     'customer');

-- Категории
INSERT INTO categories (name, description) VALUES
    ('Электроника',   'Гаджеты и устройства'),
    ('Одежда',        'Верхняя одежда, обувь, аксессуары'),
    ('Книги',         'Художественная и техническая литература'),
    ('Спорт',         'Спортивный инвентарь и экипировка');

-- Товары
INSERT INTO products (name, description, price, in_stock, category_id) VALUES
    ('Смартфон X10',       'Флагманский смартфон',              49990.00,  TRUE,  1),
    ('Наушники Pro',        'Беспроводные наушники с шумодавом',  8990.00,  TRUE,  1),
    ('Клавиатура Mech',     'Механическая клавиатура',            7490.00,  TRUE,  1),
    ('Футболка Classic',    'Хлопковая футболка',                  1990.00,  TRUE,  2),
    ('Зимняя куртка',       'Тёплая куртка с капюшоном',         12990.00,  FALSE, 2),
    ('TypeScript на практике', 'Книга по TypeScript',              2500.00,  TRUE,  3),
    ('PostgreSQL для всех',   'Книга по PostgreSQL',              3200.00,  TRUE,  3),
    ('Гантели 5 кг',        'Пара гантелей',                       2990.00,  TRUE,  4),
    ('Коврик для йоги',     'Противоскользящий коврик',            1490.00,  TRUE,  4),
    ('Планшет Tab8',        '8-дюймовый планшет',                19990.00,  FALSE, 1);

-- Заказы
INSERT INTO orders (user_id, status, total_price) VALUES
    (1, 'completed', 58980.00),
    (1, 'created',    8990.00),
    (2, 'completed', 19990.00),
    (2, 'shipped',   12990.00),
    (4, 'completed',  5700.00),
    (5, 'created',    2990.00);

-- Позиции заказов
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
    (1, 1, 1, 49990.00),
    (1, 2, 1,  8990.00),
    (2, 2, 1,  8990.00),
    (3, 6, 2,  5000.00),
    (3, 10, 1, 19990.00),
    (4, 5, 1, 12990.00),
    (5, 6, 1,  2500.00),
    (5, 7, 1,  3200.00),
    (6, 8, 1,  2990.00);