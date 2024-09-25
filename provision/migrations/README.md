# Database Management with Alembic

## Creating Migrations

After making changes to the SQLAlchemy schema, run the follwing:

```bash
alembic revision -m "<migration description>" --autogenerate
```

For autogenerate to work, make sure that your changes are imported from
the top-level of the application.


## Applying Migrations

```bash
alembic upgrade head
```
