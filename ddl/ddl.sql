DROP DATABASE IF EXISTS gaseosas_del_valle;
CREATE DATABASE IF NOT EXISTS gaseosas_del_valle;

USE gaseosas_del_valle;

CREATE TABLE client(
    id_client INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    ident_doc VARCHAR(13) UNIQUE NOT NULL,
    adress VARCHAR(150) NOT NULL,
    phone_number VARCHAR(8) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE order_details(
    id_order_details INT PRIMARY KEY AUTO_INCREMENT,
    quantity VARCHAR(5) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2)
);

CREATE TABLE product(
    id_product INT PRIMARY KEY AUTO_INCREMENT,
    id_order_details INT,
    name VARCHAR(60) NOT NULL,
    volume_ml VARCHAR(10) NOT NULL,
    price DECIMAL(10, 2),

    FOREIGN KEY (id_order_details) REFERENCES order_details (id_order_details)
);


CREATE TABLE category(
    id_category INT PRIMARY KEY AUTO_INCREMENT,
    id_product INT,
    category_name VARCHAR(25) NOT NULL,

    FOREIGN KEY (id_product) REFERENCES product(id_product)
);

CREATE TABLE stock(
    id_sotck INT PRIMARY KEY AUTO_INCREMENT,
    id_product INT,
    minium_stock_level VARCHAR(5),
    current_stock VARCHAR(5),

    FOREIGN KEY (id_product) REFERENCES product(id_product)
);
