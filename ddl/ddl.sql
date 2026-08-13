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