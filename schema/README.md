# Schema

| File | What it is |
| --- | --- |
| [`schema.sql`](schema.sql) | Postgres DDL for the core tables |
| [`categories.seed.json`](categories.seed.json) | The category tree from [docs/04](../docs/04-category-tree.md), ready to seed |

The schema is the first thing to build. Everything else depends on the shape of
`guides`, `guide_steps`, `diagrams`, and `vehicle_fitment`.
