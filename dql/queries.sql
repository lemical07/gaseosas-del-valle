USE gaseosas_del_valle;

SELECT p.id_product, p.name AS product_name,
    lo.office_name, s.current_stock, 
    s.minimum_stock_level
FROM stock s
    JOIN product p ON s.id_product = p.id_product
    JOIN location_office lo 
        ON s.id_loc_office = lo.id_loc_office
WHERE s.current_stock < s.minimum_stock_level;


SELECT id_order, id_client, id_loc_office, order_date, status
FROM orders
WHERE order_date 
    BETWEEN '2026-01-01' AND '2026-02-28';

SELECT p.id_product, p.name AS product_name,
    SUM(od.quantity) AS total_units_sold
FROM order_details od
    JOIN product p 
        ON od.id_product = p.id_product
GROUP BY p.id_product, p.name
ORDER BY total_units_sold DESC;

SELECT c.id_client, CONCAT(c.first_name, ' ', c.last_name) AS client_name,
    COUNT(o.id_order) AS total_orders
FROM client c
    JOIN orders o 
        ON o.id_client = c.id_client
GROUP BY c.id_client, c.first_name, c.last_name
ORDER BY total_orders DESC;

SELECT id_client, first_name, last_name, email
FROM client
WHERE first_name LIKE '%Mar%' OR last_name LIKE '%Mar%';