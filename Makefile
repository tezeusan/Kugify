.DEFAULT_GOAL := help

.PHONY: help run run-dev install compile lint check-lint sort check-sort format check-format test alembic-init alembic-revision alembic-upgrade alembic-downgrade

help:
	@echo "Available targets:"
	@echo "  run                 Start Uvicorn server"
	@echo "  run-dev             Start via fastapi-cli"
	@echo "  install             Install dev dependencies"
	@echo "  compile             Rebuild requirements*.txt"
	@echo "  lint                Run Ruff linting (fixes issues)"
	@echo "  check-lint          Run Ruff in check mode (CI)"
	@echo "  sort                Sort imports with isort (fixes)"
	@echo "  check-sort          Check import sorting (CI)"
	@echo "  format              Format code with Black (fixes)"
	@echo "  check-format        Check code formatting (CI)"
	@echo "  test                Run tests with pytest"
	@echo "  alembic-init        Scaffold Alembic environment"
	@echo "  alembic-revision    Create new migration (autogenerate)"
	@echo "  alembic-upgrade     Apply migrations to latest"
	@echo "  alembic-downgrade   Roll back last migration"

run:
	uvicorn app.main:app --reload

run-dev:
	fastapi dev app/main.py

install:
	pip install -r requirements-dev.txt

compile:
	pip-compile pyproject.toml --output-file=requirements.txt
	pip-compile pyproject.toml --extra dev --output-file=requirements-dev.txt

lint:
	ruff check .

check-lint:
	ruff --exit-zero --select ALL . || (echo 'Lint errors detected. Run make lint to fix.' && exit 1)

sort:
	isort ./app

check-sort:
	isort --check-only ./app

format:
	black ./app

check-format:
	black --check ./app

test:
	pytest --maxfail=1 --disable-warnings -q

alembic-init:
	alembic init alembic

alembic-revision:
	alembic revision --autogenerate -m "$(msg)"

alembic-upgrade:
	alembic upgrade head

alembic-downgrade:
	alembic downgrade -1