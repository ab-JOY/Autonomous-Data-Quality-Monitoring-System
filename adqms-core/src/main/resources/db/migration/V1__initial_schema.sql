-- Create datasets table
CREATE TABLE datasets (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    quality_profile VARCHAR(50) NOT NULL DEFAULT 'BALANCED',
    expected_update_interval_hours INTEGER,
    alert_rules JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create dataset_versions table
CREATE TABLE dataset_versions (
    id UUID PRIMARY KEY,
    dataset_id UUID NOT NULL REFERENCES datasets(id) ON DELETE CASCADE,
    version_number INTEGER NOT NULL,
    ingested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    row_count BIGINT NOT NULL,
    column_count INTEGER NOT NULL,
    schema_hash VARCHAR(64) NOT NULL,
    is_baseline BOOLEAN NOT NULL DEFAULT FALSE,
    baseline_established_at TIMESTAMP,
    statistical_summary JSONB,
    UNIQUE(dataset_id, version_number)
);

-- Create jobs table
CREATE TABLE jobs (
    id UUID PRIMARY KEY,
    dataset_id UUID REFERENCES datasets(id) ON DELETE SET NULL,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    progress INTEGER DEFAULT 0,
    error_message TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP
);

-- Create data_quality_results table
CREATE TABLE data_quality_results (
    id UUID PRIMARY KEY,
    dataset_version_id UUID NOT NULL REFERENCES dataset_versions(id) ON DELETE CASCADE,
    rule_score DOUBLE PRECISION,
    completeness_score DOUBLE PRECISION,
    freshness_score DOUBLE PRECISION,
    quality_score DOUBLE PRECISION NOT NULL,
    rule_violations JSONB,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create drift_scores table
CREATE TABLE drift_scores (
    id UUID PRIMARY KEY,
    dataset_version_id UUID NOT NULL REFERENCES dataset_versions(id) ON DELETE CASCADE,
    column_name VARCHAR(255) NOT NULL,
    drift_score DOUBLE PRECISION NOT NULL,
    drift_detected BOOLEAN NOT NULL,
    method VARCHAR(100) NOT NULL,
    p_value DOUBLE PRECISION,
    confidence_level DOUBLE PRECISION,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create anomaly_scores table
CREATE TABLE anomaly_scores (
    id UUID PRIMARY KEY,
    dataset_version_id UUID NOT NULL REFERENCES dataset_versions(id) ON DELETE CASCADE,
    anomaly_score DOUBLE PRECISION NOT NULL,
    is_anomalous BOOLEAN NOT NULL,
    method VARCHAR(100) NOT NULL,
    anomalous_rows JSONB,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create alerts table
CREATE TABLE alerts (
    id UUID PRIMARY KEY,
    dataset_id UUID NOT NULL REFERENCES datasets(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    severity VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'NEW',
    first_seen_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_seen_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    occurrence_count INTEGER NOT NULL DEFAULT 1,
    resolved_at TIMESTAMP,
    resolved_by VARCHAR(255),
    acknowledged_by VARCHAR(255),
    acknowledged_at TIMESTAMP,
    metadata JSONB
);

-- Create schema_changes table
CREATE TABLE schema_changes (
    id UUID PRIMARY KEY,
    dataset_id UUID NOT NULL REFERENCES datasets(id) ON DELETE CASCADE,
    from_version_id UUID REFERENCES dataset_versions(id) ON DELETE SET NULL,
    to_version_id UUID NOT NULL REFERENCES dataset_versions(id) ON DELETE CASCADE,
    change_type VARCHAR(50) NOT NULL,
    column_name VARCHAR(255),
    details JSONB,
    detected_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_dataset_versions_dataset ON dataset_versions(dataset_id, version_number DESC);
CREATE INDEX idx_dataset_baseline ON dataset_versions(dataset_id) WHERE is_baseline = TRUE;
CREATE INDEX idx_jobs_status ON jobs(dataset_id, status, created_at DESC);
CREATE INDEX idx_quality_dataset_time ON data_quality_results(dataset_version_id, timestamp DESC);
CREATE INDEX idx_drift_column ON drift_scores(dataset_version_id, column_name, timestamp DESC);
CREATE INDEX idx_anomaly_time ON anomaly_scores(dataset_version_id, timestamp DESC);
CREATE INDEX idx_alerts_active ON alerts(dataset_id, type, status) WHERE status IN ('NEW', 'ACKNOWLEDGED');
CREATE INDEX idx_schema_changes_dataset ON schema_changes(dataset_id, detected_at DESC);
CREATE INDEX idx_schema_changes_to_version ON schema_changes(to_version_id);
