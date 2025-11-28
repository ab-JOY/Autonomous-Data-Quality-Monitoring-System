-- Insert sample datasets for testing
INSERT INTO datasets (id, name, description, quality_profile, expected_update_interval_hours, created_at, updated_at)
VALUES 
    ('550e8400-e29b-41d4-a716-446655440001', 'customer_data', 'Customer information dataset', 'BALANCED', 24, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('550e8400-e29b-41d4-a716-446655440002', 'sales_transactions', 'Daily sales transaction data', 'ML_READY', 12, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('550e8400-e29b-41d4-a716-446655440003', 'product_inventory', 'Product inventory levels', 'OPERATIONAL', 6, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert sample dataset versions
INSERT INTO dataset_versions (id, dataset_id, version_number, ingested_at, row_count, column_count, schema_hash, is_baseline, baseline_established_at, statistical_summary)
VALUES 
    ('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 1, CURRENT_TIMESTAMP - INTERVAL '7 days', 10000, 15, 'abc123def456', TRUE, CURRENT_TIMESTAMP - INTERVAL '7 days', '{"mean_age": 35.5, "median_income": 55000}'::jsonb),
    ('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 2, CURRENT_TIMESTAMP - INTERVAL '3 days', 10500, 15, 'abc123def456', FALSE, NULL, '{"mean_age": 36.2, "median_income": 56000}'::jsonb),
    ('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 1, CURRENT_TIMESTAMP - INTERVAL '5 days', 50000, 20, 'xyz789ghi012', TRUE, CURRENT_TIMESTAMP - INTERVAL '5 days', '{"total_amount": 1500000, "avg_transaction": 30}'::jsonb);

-- Insert sample jobs
INSERT INTO jobs (id, dataset_id, type, status, progress, created_at, started_at, completed_at)
VALUES 
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'INGESTION', 'COMPLETED', 100, CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '7 days'),
    ('770e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'INGESTION', 'COMPLETED', 100, CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days'),
    ('770e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'INGESTION', 'RUNNING', 75, CURRENT_TIMESTAMP - INTERVAL '1 hour', CURRENT_TIMESTAMP - INTERVAL '1 hour', NULL);

-- Insert sample data quality results
INSERT INTO data_quality_results (id, dataset_version_id, rule_score, completeness_score, freshness_score, quality_score, rule_violations, timestamp)
VALUES 
    ('880e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 95.0, 98.5, 100.0, 97.5, '[]'::jsonb, CURRENT_TIMESTAMP - INTERVAL '7 days'),
    ('880e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', 92.0, 97.0, 95.0, 94.5, '[{"ruleName": "null_check", "columnName": "email", "severity": "WARNING", "violationCount": 50}]'::jsonb, CURRENT_TIMESTAMP - INTERVAL '3 days');

-- Insert sample drift scores
INSERT INTO drift_scores (id, dataset_version_id, column_name, drift_score, drift_detected, method, p_value, confidence_level, timestamp)
VALUES 
    ('990e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440002', 'age', 0.15, FALSE, 'KS_TEST', 0.25, 0.95, CURRENT_TIMESTAMP - INTERVAL '3 days'),
    ('990e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', 'income', 0.45, TRUE, 'PSI', 0.02, 0.95, CURRENT_TIMESTAMP - INTERVAL '3 days');

-- Insert sample anomaly scores
INSERT INTO anomaly_scores (id, dataset_version_id, anomaly_score, is_anomalous, method, anomalous_rows, timestamp)
VALUES 
    ('aa0e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440002', 0.12, FALSE, 'ISOLATION_FOREST', '[]'::jsonb, CURRENT_TIMESTAMP - INTERVAL '3 days'),
    ('aa0e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440003', 0.78, TRUE, 'ISOLATION_FOREST', '[125, 456, 789]'::jsonb, CURRENT_TIMESTAMP - INTERVAL '5 days');

-- Insert sample alerts
INSERT INTO alerts (id, dataset_id, type, severity, message, status, first_seen_at, last_seen_at, occurrence_count, metadata)
VALUES 
    ('bb0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'DRIFT_DETECTED', 'WARNING', 'Significant drift detected in income column', 'NEW', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days', 1, '{"column": "income", "drift_score": 0.45}'::jsonb),
    ('bb0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'ANOMALY_DETECTED', 'ERROR', 'High anomaly score detected in sales data', 'ACKNOWLEDGED', CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '4 days', 2, '{"anomaly_score": 0.78}'::jsonb);

-- Insert sample schema changes
INSERT INTO schema_changes (id, dataset_id, from_version_id, to_version_id, change_type, column_name, details, detected_at)
VALUES 
    ('cc0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440002', 'COLUMN_ADDED', 'loyalty_points', '{"type": "INTEGER", "nullable": true}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '3 days');
