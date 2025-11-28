package com.adqms.adqms_core.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "drift_scores")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DriftScore {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dataset_version_id", nullable = false)
    private DatasetVersion datasetVersion;
    
    @Column(name = "column_name", nullable = false)
    private String columnName;
    
    @Column(name = "drift_score", nullable = false)
    private Double driftScore;
    
    @Column(name = "drift_detected", nullable = false)
    private Boolean driftDetected;
    
    @Column(name = "method", nullable = false)
    private String method;
    
    @Column(name = "p_value")
    private Double pValue;
    
    @Column(name = "confidence_level")
    private Double confidenceLevel;
    
    @Column(name = "timestamp", nullable = false)
    private LocalDateTime timestamp;
    
    @PrePersist
    protected void onCreate() {
        if (timestamp == null) {
            timestamp = LocalDateTime.now();
        }
    }
}
