DROP DATABASE IF EXISTS gaseosas_del_valle;
CREATE DATABASE IF NOT EXISTS gaseosas_del_valle;

USE gaseosas_del_valle;

CREATE TABLE client(
    id_client INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    ident_doc VARCHAR(13) UNIQUE NOT NULL,
    address VARCHAR(150) NOT NULL,
    phone_number VARCHAR(8) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE category(
    id_category INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(25) NOT NULL
);

CREATE TABLE product(
    id_product INT PRIMARY KEY AUTO_INCREMENT,
    id_category INT NOT NULL,
    name VARCHAR(60) NOT NULL,
    volume_ml DECIMAL(6,2) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),

    FOREIGN KEY (id_category) REFERENCES category (id_category)
);

CREATE TABLE location_office(
    id_loc_office INT PRIMARY KEY AUTO_INCREMENT,
    office_name VARCHAR(50) NOT NULL UNIQUE,
    address VARCHAR(150) NOT NULL,
    storage_capacity INT NOT NULL
);

CREATE TABLE in_charge(
    id_in_charge INT PRIMARY KEY AUTO_INCREMENT,
    id_loc_office INT NOT NULL,
    name_in_charge VARCHAR(50),

    FOREIGN KEY (id_loc_office) REFERENCES location_office(id_loc_office)
);

CREATE TABLE stock(
    id_stock INT PRIMARY KEY AUTO_INCREMENT,
    id_product INT NOT NULL,
    id_loc_office INT NOT NULL,
    minimum_stock_level INT NOT NULL CHECK (minimum_stock_level >= 0),
    current_stock INT NOT NULL,

    FOREIGN KEY (id_product) REFERENCES product (id_product),
    FOREIGN KEY (id_loc_office) REFERENCES location_office (id_loc_office)
);

CREATE TABLE orders(
    id_order INT PRIMARY KEY AUTO_INCREMENT,
    id_client INT NOT NULL,
    id_loc_office INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_client) REFERENCES client(id_client),
    FOREIGN KEY (id_loc_office) REFERENCES location_office(id_loc_office)
);

CREATE TABLE order_details(
    id_order_details INT PRIMARY KEY AUTO_INCREMENT,
    id_product INT NOT NULL,
    id_order INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,

    FOREIGN KEY (id_product) REFERENCES product(id_product),
    FOREIGN KEY (id_order) REFERENCES orders(id_order)
);

CREATE TABLE price_audit(
    id_audit INT PRIMARY KEY AUTO_INCREMENT,
    id_product INT NOT NULL,
    change_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    old_price DECIMAL(10,2) NOT NULL,
    new_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_product) REFERENCES product(id_product)
);

DESCRIBE orders;
ALTER TABLE orders
ADD COLUMN status ENUM('pending', 'completed', 'cancelled') NOT NULL DEFAULT 'pending';