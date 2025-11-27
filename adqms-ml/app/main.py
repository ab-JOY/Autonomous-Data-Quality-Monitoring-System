from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import logging
from pythonjsonlogger import jsonlogger

# Configure structured JSON logging
logger = logging.getLogger()
logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter(
    fmt='%(asctime)s %(levelname)s %(name)s %(message)s'
)
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)
logger.setLevel(logging.INFO)

app = FastAPI(
    title="ADQMS ML Service",
    description="Machine Learning service for drift detection and anomaly detection",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "adqms-ml"
    }

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "ADQMS ML Service",
        "version": "1.0.0"
    }
