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
DELIMITER ;

-- ------------------------------------------------
-- Pruenba de fn_calculate_total_with_iva
-- ------------------------------------------------
SELECT fn_calculate_total_with_iva(50) 
	AS total_with_iva;