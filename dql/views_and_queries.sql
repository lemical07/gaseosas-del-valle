USE gaseosas_del_valle;

CREATE VIEW v_order_summary_by_office AS
SELECT lo.id_loc_office, lo.office_name,
    COUNT(DISTINCT o.id_order) AS total_orders,
    SUM(fn_calculate_total_with_iva(o.id_order)) AS total_sales
FROM location_office lo
    JOIN orders o 
    ON o.id_loc_office = lo.id_loc_office
GROUP BY lo.id_loc_office, lo.office_name;
SELECT * FROM v_order_summary_by_office;

CREATE VIEW v_products_below_min_stock AS
SELECT p.id_product, p.name AS product_name,
    lo.office_name,
    s.current_stock, s.minimum_stock_level
FROM stock s
    JOIN product p 
        ON s.id_product = p.id_product
    JOIN location_office lo 
        ON s.id_loc_office = lo.id_loc_office
WHERE s.current_stock <= s.minimum_stock_level;

SELECT * FROM v_products_below_min_stock;
-- ------before test
UPDATE stock SET current_stock = 10 WHERE id_product = 1 AND id_loc_office = 1;
SELECT * FROM v_products_below_min_stock;
-- ----after test
UPDATE stock SET current_stock = 250 WHERE id_product = 1 AND id_loc_office = 1;
SELECT COUNT(*) FROM stock WHERE current_stock <= minimum_stock_level;


CREATE VIEW v_active_clients AS
SELECT DISTINCT c.id_client, c.first_name, c.last_name, c.email
FROM client c
    JOIN orders o 
        ON o.id_client = c.id_client;

SELECT * FROM v_active_clients;

SELECT c.id_client, c.first_name FROM client c
LEFT JOIN orders o ON o.id_client = c.id_client
WHERE o.id_order IS NULL;
CREATE VIEW v_order_summary AS
SELECT
    o.id_order,
    CONCAT(c.first_name, ' ', c.last_name) AS client_name,
    lo.office_name,
    o.order_date,
    o.status,
    fn_calculate_total_with_iva(o.id_order) AS total_with_iva
FROM orders o
    JOIN client c 
        ON o.id_client = c.id_client
    JOIN location_office lo ON o.id_loc_office = lo.id_loc_office;

SELECT * FROM v_order_summary ORDER BY id_order;