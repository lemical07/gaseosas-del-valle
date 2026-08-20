USE  gaseosas_del_valle;

DELIMITER //

CREATE FUNCTION total_pedidos_clientes_periodo(p_id_cliente INT, p_fecha_inicio DATE, p_fecha_final DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_pedidos DECIMAL(10,2);

    SELECT COALESCE(SUM(total), 0) INTO total_pedidos
    FROM orders
    WHERE id_cliente = p_id_cliente
        AND fecha_pedido BETWEEN p_fecha_inicio AND p_fecha_final;

    RETURN total_pedidos;
END //

DELIMITER ;

























