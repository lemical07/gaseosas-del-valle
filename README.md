# Gaseosas del Valle S.A. — Database Project

Relational database in MySQL for Gaseosas del Valle S.A., a beverage
distribution company based in Guatemala City, with branch offices in
Quetzaltenango, Escuintla, and Cobán.

## Project Structure
````
gaseosas-del-valle/
├── analysis/
│ └── requirements.md Business requirements, entities, rules, assumptions
├── ddl/
│ └── ddl.sql Table definitions, PK/FK, CHECK constraints
├── dml/
│ └── dml.sql Sample data (Guatemala-based)
├── docs/
│ ├── eer-diagram.png EER diagram (MySQL Workbench reverse engineering)
│ └── er-diagram.drawio.png ER diagram (draw.io)
├── dql/
│ ├── views.sql Required and extra views
│ └── queries.sql 8 required queries
├── functions/
│ └── functions.sql Stored functions
├── triggers/
│ └── triggers.sql Triggers
├── evidence/
│ ├── img/ Screenshots referenced in results.md
│ └── results.md Test evidence with real execution results
└── README.md
````
## How to Run

Run the scripts in this order against a MySQL instance:

```sql
SOURCE ddl/ddl.sql;
SOURCE dml/dml.sql;
SOURCE functions/functions.sql;
SOURCE triggers/triggers.sql;
SOURCE dql/views.sql;
SOURCE dql/queries.sql;
```

## Entities (9 tables)

`client`, `category`, `product`, `location_office`, `in_charge`, `stock`,
`orders`, `order_details`, `price_audit`.

## Key Design Decisions

- **unit_price** is stored per line in `order_details`, freezing the
  price at the moment of sale — later changes to `product.price` do not
  retroactively affect past orders.
- **Order totals** (subtotal and total with IVA) are not stored as
  columns; they are computed on demand via
  `fn_calculate_total_with_iva(id_order)`.
- **Stock** is tracked per product + office combination (`id_product`,
  `id_loc_office`), not globally.
- **Order cancellation** changes the `status` column
  (`pending` / `completed` / `cancelled`); orders are never physically
  deleted.
- **Every office** must have at least one `in_charge` assigned.

## Automation (Functions & Triggers)

- `fn_calculate_total_with_iva(id_order)` — calculates an order's total
  including IVA.
- `fn_validate_stock(id_product, id_loc_office, quantity)` — checks
  stock availability.
- `tr_update_stock` — decrements stock automatically after an order
  detail is inserted.
- `tr_audit_price_change` — logs price changes to `price_audit`, only
  when the price actually changes.
- `tr_validate_stock_before_sale` *(extra)* — rejects an order insert
  before it happens if there isn't enough stock, preventing negative
  stock rather than just correcting it after the fact.

## Views

**Required:**
- `v_products_below_min_stock` — products with stock below their
  minimum level.
- `v_order_summary_by_office` — order count and total sales aggregated
  per office.
- `v_active_clients` — clients with at least one registered order.

**Extra:**
- `v_order_summary` — per-order detail (client, office, date, status,
  total with IVA). Complements `v_order_summary_by_office`: the latter
  gives the aggregate per office, this one gives the transactional
  detail behind it.

## Queries

8 required queries in `dql/queries.sql`, covering: stock below minimum,
date range filtering (`BETWEEN`), best-selling products
(`JOIN` + `GROUP BY`), clients and their order counts, partial name
search (`LIKE`), category filtering (`IN`), client with the most orders
(subquery), and totals grouped by office.

All results are documented with real query output in
`evidence/results.md`.