CREATE TABLE IF NOT EXISTS MANUFACTURERS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
);

CREATE TABLE IF NOT EXISTS customers (
    id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT
);

CREATE TABLE IF NOT EXISTS items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    price TEXT,
    manufacturer_id INTEGER NOT NULL REFERENCES manufacturers(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number TEXT,
    order_date NUMERIC,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    item_id INTEGER NOT NULL REFERENCES items(id)
);

