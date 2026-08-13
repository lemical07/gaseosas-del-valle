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