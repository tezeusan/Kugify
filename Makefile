.DEFAULT_GOAL := help

.PHONY: help run run-dev install compile lint sort format alembic-init alembic-revision alembic-upgrade alembic-downgrade

help:
	@echo "Available targets:"
	@echo "  run                 Start Uvicorn server"
	@echo "  run-dev             Start via fastapi-cli"
	@echo "  install             Install dev dependencies"
	@echo "  compile             Rebuild requirements*.txt"
	@echo "  lint                Run Ruff linting"
	@echo "  sort                Sort imports with isort"
	@echo "  format              Format code with Black"
	@echo "  alembic-init        Scaffold Alembic environment"
	@echo "  alembic-revision    Create new migration (autogenerate)"
	@echo "  alembic-upgrade     Apply migrations to latest"
	@echo "  alembic-downgrade   Roll back last migration"

run:
	uvicorn app.main:app --reload

run-dev:
	fastapi dev app/main.py

install:
	uv pip install -r requirements-dev.txt

compile:
	uv pip compile pyproject.toml --output-file=requirements.txt
	uv pip compile pyproject.toml --extra dev --output-file=requirements-dev.txt

lint:
	ruff check .

sort:
	isort ./app

format:
	black ./app

alembic-init:
	alembic init alembic

alembic-revision:
	alembic revision --autogenerate -m "$(msg)"

alembic-upgrade:
	alembic upgrade head

alembic-downgrade:
	alembic downgrade -1
