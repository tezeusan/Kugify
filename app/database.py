import os
from typing import AsyncGenerator

from dotenv import load_dotenv
from sqlalchemy import MetaData
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.ext.declarative import DeclarativeMeta
from sqlalchemy.orm import declarative_base

# Load environment variables from .env file
load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

if DATABASE_URL is None:
    raise ValueError("DATABASE_URL environment variable is not set.")

# Naming convention for Alembic migrations (if you use Alembic)
naming_convention = {
    "ix": "ix_%(column_0_label)s",
    "uq": "uq_%(table_name)s_%(column_0_name)s",
    "ck": "ck_%(table_name)s_%(constraint_name)s",
    "fk": "fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s",
    "pk": "pk_%(table_name)s",
}
metadata = MetaData(naming_convention=naming_convention)

# Declarative base with metadata for models
Base: DeclarativeMeta = declarative_base(metadata=metadata)

# Async engine for PostgreSQL connection
engine = create_async_engine(DATABASE_URL, echo=False)

# Async session factory
async_session = async_sessionmaker(
    bind=engine,
    expire_on_commit=False,
    autoflush=False,
)


# Dependency for FastAPI to get DB session per request


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with async_session() as session:
        yield session
