USE gaseosas_del_valle;

SELECT p.id_product, p.name AS product_name,
    lo.office_name, s.current_stock, 
    s.minimum_stock_level
FROM stock s
    JOIN product p ON s.id_product = p.id_product
    JOIN location_office lo 
        ON s.id_loc_office = lo.id_loc_office
WHERE s.current_stock < s.minimum_stock_level;