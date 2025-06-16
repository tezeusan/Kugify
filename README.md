# Kugify

A FastAPI backend project with SQLAlchemy, Alembic, and async support.

## Installation

```bash
# Create and activate virtual environment
uv venv .venv && source .venv/bin/activate

# Install all dev dependencies
make install
````

## Compile Dependencies

```bash
# Generate requirements.txt (prod) and requirements-dev.txt (prod + dev)
make compile
```

## Development

```bash
# Start Uvicorn
make run

# Or via fastapi-cli
make run-dev
```

## Database Migrations (Alembic)

```bash
# Initialize Alembic once
make alembic-init

# Create new migration (autogenerate)
make alembic-revision msg="describe your changes"

# Apply all migrations
make alembic-upgrade

# Roll back the last migration
make alembic-downgrade
```

## Useful Commands

```bash
make format         # Format code with Black
make sort           # Sort imports with isort
make lint           # Lint code with Ruff
make test           # Run tests with pytest
make help           # Show all available make targets
```

---

> **Note:**
>
> * Ensure your `.env` contains a valid `DATABASE_URL`.
> * `requirements.txt` is your production dependencies, and `requirements-dev.txt` includes dev tools (linters, test frameworks, Alembic, etc.).
> * The `make` targets assume `uv`, `fastapi-cli`, `alembic`, `ruff`, `black`, and `isort` are all installed in your virtual environment.
> * Run `make help` at any time to see a full list of available commands.
