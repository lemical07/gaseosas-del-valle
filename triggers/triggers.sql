USE gaseosas_del_valle;
DELIMITER //

CREATE TRIGGER tr_validate_stock_before_sale
BEFORE INSERT ON order_details
FOR EACH ROW
BEGIN
    DECLARE v_id_loc_office INT;
    DECLARE v_current_stock INT;

    SELECT id_loc_office INTO v_id_loc_office
    FROM orders
    WHERE id_order = NEW.id_order;

    SELECT current_stock 
        INTO v_current_stock
        FROM stock
    WHERE id_product = NEW.id_product
        AND id_loc_office = v_id_loc_office;

    IF v_current_stock IS NULL OR v_current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for this product at this office';
    END IF;
END//

CREATE TRIGGER tr_update_stock
AFTER INSERT ON order_details
FOR EACH ROW
BEGIN
    DECLARE v_id_loc_office INT;

    SELECT id_loc_office 
    INTO v_id_loc_office
        FROM orders
        WHERE id_order = NEW.id_order;

    UPDATE stock
    SET current_stock = current_stock - NEW.quantity
    WHERE id_product = NEW.id_product
        AND id_loc_office = v_id_loc_office;
END//

CREATE TRIGGER tr_audit_price_change
AFTER UPDATE ON product
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT 
            INTO price_audit (id_product, change_date, old_price, new_price)
        VALUES 
            (OLD.id_product, NOW(), OLD.price, NEW.price);
    END IF;
END//
DELIMITER ;
-- ---------------------------------------------------------
-- tr_update_stock test
-- ---------------------------------------------------------
SELECT * FROM stock WHERE id_product = 1 AND id_loc_office = 1;

INSERT INTO order_details (id_product, id_order, quantity, unit_price)
VALUES 
(1, 1, 5, 5.00);
SELECT * FROM stock WHERE id_product = 1 AND id_loc_office = 1;

-- ---------------------------------------------------------
-- tr_audit_price_change test
-- ---------------------------------------------------------
-- <--Caso1-->

SELECT * FROM price_audit WHERE id_product = 1;
SELECT price FROM product WHERE id_product = 1;

UPDATE product SET price = price + 1.00 WHERE id_product = 1;

SELECT * FROM price_audit WHERE id_product = 1;
SELECT price FROM product WHERE id_product = 1;


-- <--Caso2-->
UPDATE product SET name = name WHERE id_product = 1;

SELECT * FROM price_audit WHERE id_product = 1;


SELECT * FROM stock WHERE id_product = 1 AND id_loc_office = 1;
INSERT INTO order_details (id_product, id_order, quantity, unit_price)
VALUES (1, 1, 500, 5.00);
SELECT * FROM stock WHERE id_product = 1 AND id_loc_office = 1;