from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional

class DriftRequest(BaseModel):
    """Request model for drift detection"""
    column_name: str
    column_type: str  # 'continuous' or 'categorical'
    current_stats: Dict[str, Any]
    baseline_stats: Dict[str, Any]

class DriftResponse(BaseModel):
    """Response model for drift detection"""
    drift_score: float = Field(..., ge=0.0, le=1.0)
    drift_detected: bool
    method: str
    p_value: Optional[float] = None
    confidence: float = Field(..., ge=0.0, le=1.0)

class AnomalyRequest(BaseModel):
    """Request model for anomaly detection"""
    dataset_stats: Dict[str, Any]
    row_count: int
    column_types: Dict[str, str]

class AnomalyResponse(BaseModel):
    """Response model for anomaly detection"""
    anomaly_score: float = Field(..., ge=0.0, le=1.0)
    is_anomalous: bool
    method: str
    anomalous_rows: List[int] = []
