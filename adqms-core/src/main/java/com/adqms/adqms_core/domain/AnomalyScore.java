package com.adqms.adqms_core.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "anomaly_scores")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AnomalyScore {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dataset_version_id", nullable = false)
    private DatasetVersion datasetVersion;
    
    @Column(name = "anomaly_score", nullable = false)
    private Double anomalyScore;
    
    @Column(name = "is_anomalous", nullable = false)
    private Boolean isAnomalous;
    
    @Column(name = "method", nullable = false)
    private String method;
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "anomalous_rows", columnDefinition = "jsonb")
    private List<Integer> anomalousRows;
    
    @Column(name = "timestamp", nullable = false)
    private LocalDateTime timestamp;
    
    @PrePersist
    protected void onCreate() {
        if (timestamp == null) {
            timestamp = LocalDateTime.now();
        }
    }
}
