USE gaseosas_del_valle;
DELIMITER //
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
-- tr_update_stock test
-- ---------------------------------------------------------
