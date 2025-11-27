# ADQMS - Autonomous Data Quality Monitoring System

An asynchronous, microservice-based platform that automatically evaluates, scores, and monitors the quality of datasets flowing through data pipelines.

## Architecture

- **Java Spring Boot Backend**: Orchestrator service managing ingestion, rules, and coordination
- **Python ML Service**: FastAPI service performing drift detection and anomaly detection
- **PostgreSQL**: Database for storing datasets, versions, quality metrics, and alerts

## Prerequisites

- Docker and Docker Compose
- Java 17+ (for local development)
- Python 3.11+ (for local development)
- Gradle (for local development)

## Quick Start with Docker Compose

1. Start all services:
```bash
docker-compose up -d
```

2. Check service health:
```bash
# Java Backend
curl http://localhost:8080/actuator/health

# Python ML Service
curl http://localhost:8001/health

# PostgreSQL
docker exec -it adqms-postgres pg_isready -U adqms_user -d adqms
```

3. View logs:
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f adqms-core
docker-compose logs -f adqms-ml
docker-compose logs -f postgres
```

4. Stop all services:
```bash
docker-compose down
```

5. Stop and remove volumes:
```bash
docker-compose down -v
```

## Local Development

### Java Backend

1. Start PostgreSQL and Python ML service:
```bash
docker-compose up -d postgres adqms-ml
```

2. Run the Java application:
```bash
cd adqms-core
./gradlew bootRun
```

3. Run tests:
```bash
./gradlew test
```

### Python ML Service

1. Create virtual environment:
```bash
cd adqms-ml
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the service:
```bash
uvicorn app.main:app --reload --port 8001
```

4. Run tests:
```bash
pytest
```

## API Documentation

- **Java Backend API**: http://localhost:8080/swagger-ui.html (once implemented)
- **Python ML Service API**: http://localhost:8001/docs
- **Metrics**: http://localhost:8080/actuator/prometheus

## Configuration

### Java Backend

Configuration is in `adqms-core/src/main/resources/application.properties`

Key configurations:
- Database connection
- ML service URL
- Circuit breaker settings
- Retry policies
- Async thread pool

### Python ML Service

Environment variables:
- `LOG_LEVEL`: Logging level (default: INFO)

## Project Structure

```
.
├── adqms-core/              # Java Spring Boot backend
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   └── resources/
│   │   └── test/
│   ├── build.gradle
│   └── Dockerfile
├── adqms-ml/                # Python FastAPI ML service
│   ├── app/
│   │   ├── drift/          # Drift detection algorithms
│   │   ├── anomaly/        # Anomaly detection algorithms
│   │   ├── main.py
│   │   └── models.py
│   ├── requirements.txt
│   └── Dockerfile
├── docker-compose.yml
└── README.md
```

## Development Workflow

1. Create feature branch
2. Implement changes
3. Run tests locally
4. Build and test with Docker Compose
5. Submit pull request

## Troubleshooting

### Port conflicts
If ports 5432, 8080, or 8001 are already in use, modify the port mappings in `docker-compose.yml`

### Database connection issues
Ensure PostgreSQL is healthy:
```bash
docker-compose ps
docker-compose logs postgres
```

### ML Service connection issues
Check ML service logs:
```bash
docker-compose logs adqms-ml
```

## License

MIT
