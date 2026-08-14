USE gaseosas_del_valle;
SELECT * FROM product;
SELECT * FROM order_details;

DELIMITER //
CREATE FUNCTION fn_calculate_total_with_iva(p_id_order INT) 
RETURNS DECIMAL(10,2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_total_with_iva DECIMAL(10,2);

    SELECT COALESCE(SUM(subtotal), 0) INTO v_subtotal
    FROM order_details
    WHERE id_order = p_id_order;

    SET v_total_with_iva = v_subtotal * 1.19;
    RETURN v_total_with_iva;
END //

CREATE FUNCTION fn_validate_stock(p_id_product INT, p_id_loc_office INT, p_quantity INT)
RETURNS VARCHAR(100)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_current_stock INT DEFAULT NULL;

    SELECT current_stock INTO v_current_stock
    FROM stock
    WHERE id_product = p_id_product AND id_loc_office = p_id_loc_office
    LIMIT 1;

    IF v_current_stock IS NULL THEN
        RETURN 'No stock record for this product at this office';
    ELSEIF v_current_stock >= p_quantity THEN
        RETURN 'Stock available';
    ELSE
        RETURN 'Insufficient stock';
    END IF;
END//
DELIMITER ;

-- ------------------------------------------------
-- Pruenba de fn_calculate_total_with_iva
-- ------------------------------------------------
SELECT fn_calculate_total_with_iva(50) 
	AS total_with_iva;

-- ------------------------------------------------
-- Prueba de fn_validate_stock
-- ------------------------------------------------
SELECT fn_validate_stock(1, 1, 50) 
	AS stock_status;

SELECT fn_validate_stock(1, 2, 100) 
	AS stock_status;

SELECT fn_validate_stock(1, 3, 10) 
	AS stock_status;


