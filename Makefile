install:
	uv pip install -r requirements-dev.txt

compile:
	uv pip compile pyproject.toml --output-file=requirements.txt
	uv pip compile pyproject.toml --extra dev --output-file=requirements-dev.txt

.PHONY: lint fix format run

lint:
	ruff check .

fix:
	ruff check . --fix

format:
	black .

run:
	uvicorn app.main:app --reload

run-dev:
	fastapi dev app/main.py
