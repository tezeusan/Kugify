.PHONY: install compile lint sort format run run-dev 

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

style:
	ruff check .
	isort ./app
	black ./app