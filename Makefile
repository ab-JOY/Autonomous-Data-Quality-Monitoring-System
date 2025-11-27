.PHONY: help build up down logs clean test

help:
	@echo "ADQMS Development Commands"
	@echo "=========================="
	@echo "make build       - Build all Docker images"
	@echo "make up          - Start all services"
	@echo "make up-dev      - Start all services in development mode"
	@echo "make down        - Stop all services"
	@echo "make logs        - View logs from all services"
	@echo "make clean       - Stop services and remove volumes"
	@echo "make test-java   - Run Java tests"
	@echo "make test-python - Run Python tests"
	@echo "make db-shell    - Connect to PostgreSQL shell"

build:
	docker-compose build

up:
	docker-compose up -d

up-dev:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

clean:
	docker-compose down -v

test-java:
	cd adqms-core && ./gradlew test

test-python:
	cd adqms-ml && pytest

db-shell:
	docker exec -it adqms-postgres psql -U adqms_user -d adqms
