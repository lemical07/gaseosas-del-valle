USE gaseosas_del_valle;

DELIMITER //

CREATE FUNCTION total_pedidos_clientes_periodo(p_id_cliente INT, p_fecha_inicio DATE, p_fecha_final DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_pedidos DECIMAL(10,2);

    SELECT COALESCE(SUM(total), 0) INTO total_pedidos
    FROM orders
    WHERE id_cliente = p_id_cliente AND fecha_pedido BETWEEN p_fecha_inicio AND p_fecha_final;

    RETURN total_pedidos;
END //

DELIMITER ;

CREATE VIEW vista_clientes_activos AS
SELECT 
    c.id_client AS id_cliente,
    
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
    COUNT(o.id_order) AS total_pedidos,
    SUM(fn_calculate_total_with_iva(o.id_order)) AS valor_total_comprado
	FROM client c
		JOIN 
			orders o 
			ON c.id_client = o.id_client
			WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
	GROUP BY 
		c.id_client, c.first_name, c.last_name;

SELECT * FROM vista_clientes_activos;

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
    COUNT(o.id_order) AS cantidad_pedidos,
    SUM(fn_calculate_total_with_iva(o.id_order)) AS total_comprado
    
	FROM client c
		JOIN orders o ON c.id_client = o.id_client
		WHERE YEAR(o.order_date) = YEAR(CURDATE())
			GROUP BY c.id_client, c.first_name, c.last_name
			ORDER BY total_comprado DESC
	LIMIT 5;


















