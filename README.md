# Library Borrowing (PL/SQL)

A small Oracle SQL/PLSQL project for modeling and querying a library borrowing system.

## Repository Contents

- `tables.sql` – schema creation (tables, constraints) and sample seed data.
- `queryes.sql` – practice queries, updates, deletes, PL/SQL functions, and triggers.

## Data Model

The schema includes four core tables:

- `authors`
- `readers`
- `books`
- `loans`

Relationships are enforced with primary keys, unique constraints, and foreign keys.

## How to Run

1. Execute `tables.sql` in an Oracle environment to create the schema and insert sample data.
2. Execute sections from `queryes.sql` to test queries and PL/SQL logic.

## Notes

- The scripts are educational and include multiple query examples for joins, filtering, aggregation, updates, deletes, functions, and triggers.
- You can run sections independently, but some parts assume prior objects already exist.
