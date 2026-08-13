# Requirement Analysis — Gaseosas del Valle S.A.

## Context

Gaseosas del Valle S.A. is a beverage distribution company headquartered in Guatemala
City, with branches in Quetzaltenango, Escuintla, and Cobán. It currently manages orders and
stock in spreadsheets, which causes recording errors, data loss, and a lack of
traceability. A relational database in MySQL is needed to centralize products,
clients, offices, and orders, with automated calculations and price-change auditing.

## Detected entities

| Entity | What it stores |
|---|---|
| `client` | Clients who place orders |
| `category` | Product catalog categories |
| `product` | Products (beverages) sold by the company |
| `location_office` | Distribution offices/branches |
| `in_charge` | Person(s) in charge of each office |
| `stock` | Stock of a product at a specific office |
| `orders` | Orders placed by a client |
| `order_details` | Line items (products) included in an order |
| `price_audit` | Price change history per product |

## Relationships and cardinality

- `client` 1:N `orders` — a client can place many orders.
- `orders` 1:N `order_details` — an order has many detail lines.
- `order_details` N:1 `product` — each detail line references one product.
- `product` N:1 `category` — each product belongs to one category.
- `product` 1:N `stock` — a product has one stock record per office.
- `location_office` 1:N `stock` — an office manages stock for several products.
- `orders` N:1 `location_office` — each order is dispatched from a single office.
- `location_office` 1:N `in_charge` — an office can have more than one person in charge.
- `product` 1:N `price_audit` — a product can have many audited price changes.

## Business rules

1. **Currency:** all prices are handled in Guatemalan Quetzales (GTQ).
2. **VAT:** an order's total including tax is calculated at 19% over the sum of
   `order_details` subtotals (via `fn_calculate_total_with_iva`), not stored as a
   fixed column.
3. **Frozen sale price:** `order_details.unit_price` stores the product's price at
   the moment of sale; if the product's price changes later, already-billed orders
   don't change value.
4. **Stock validation:** if available stock isn't enough to fulfill an order, the
   entire order is rejected (no negative stock, no partial backorders).
5. **Minimum stock:** `current_stock` should never fall below `minimum_stock_level`
   without an alert — the `low_stock_products_view` exists to monitor this.
6. **Order without products:** an order can't be created without at least one
   `order_details` line.
7. **Cancel, don't delete:** orders are never physically deleted; canceling an order
   changes its status and preserves history.
8. **Price auditing:** every `UPDATE` on `product.price` is logged in `price_audit`
   (date, old price, new price), even if the update doesn't change the value.
9. **Initial stock per office:** every product must have a `stock` row for each
   existing office as soon as it's created (not only once inventory arrives).
10. **Mandatory person in charge:** every `location_office` must have at least one
    `in_charge` assigned — it can't be left without a responsible person.
11. **Client identification:** `ident_doc` is unique per client; no two clients can
    share the same identification document.

## Assumptions

- An office can have more than one person in charge (`in_charge` is 1:N with respect
  to `location_office`, not 1:1).
- No graphical interface is required: everything is validated directly from SQL.
- The model is designed to scale to more offices without structural changes —
  `stock` and `orders` already depend on `location_office` as an open catalog.
- Current branches: Office Central (Guatemala City), Office Quetzaltenango,
  Office Escuintla, and Office Cobán.