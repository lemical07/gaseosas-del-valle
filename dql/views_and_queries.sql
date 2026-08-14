USE gaseosas_del_valle;
CREATE VIEW v_order_summary AS
SELECT
    o.id_order,
    CONCAT(c.first_name, ' ', c.last_name) AS client_name,
    lo.office_name,
    o.order_date,
    o.status,
    fn_calculate_total_with_iva(o.id_order) AS total_with_iva
FROM orders o
    JOIN client c ON o.id_client = c.id_client
    JOIN location_office lo ON o.id_loc_office = lo.id_loc_office;
    
SELECT * FROM v_order_summary ORDER BY id_order;