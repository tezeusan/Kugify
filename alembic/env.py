import os
from logging.config import fileConfig

from dotenv import load_dotenv
from sqlalchemy import pool
from sqlalchemy.ext.asyncio import create_async_engine

from alembic import context
from app.database import Base

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# load .env variables
load_dotenv()
database_url = os.getenv("DATABASE_URL")
if not database_url:
    raise RuntimeError("DATABASE_URL is not set in .env")

# override sqlalchemy.url from alembic.ini with our env var
config.set_main_option("sqlalchemy.url", database_url)

# set up Python logging according to the config file
if config.config_file_name:
    fileConfig(config.config_file_name)
else:
    raise RuntimeError("Alembic config file name is not set.")

# set target_metadata for 'autogenerate'
target_metadata = Base.metadata


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode with an async engine."""
    sqlalchemy_url = config.get_main_option("sqlalchemy.url")
    if sqlalchemy_url is None:
        raise RuntimeError("sqlalchemy.url is not set in Alembic config.")
    connectable = create_async_engine(
        sqlalchemy_url,
        poolclass=pool.NullPool,
        future=True,
    )

    async def do_migrations():
        async with connectable.connect() as conn:
            # configure context with a synchronous connection
            await conn.run_sync(lambda sync_conn: context.configure(
                connection=sync_conn,
                target_metadata=target_metadata
            ))
            async with conn.begin():
                await conn.run_sync(lambda sync_conn: context.run_migrations())

    # run the async migration routine
    import asyncio
    asyncio.run(do_migrations())


# decide which mode to run
if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
