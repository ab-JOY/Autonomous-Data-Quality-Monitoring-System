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
@Table(name = "data_quality_results")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DataQualityResult {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dataset_version_id", nullable = false)
    private DatasetVersion datasetVersion;
    
    @Column(name = "rule_score")
    private Double ruleScore;
    
    @Column(name = "completeness_score")
    private Double completenessScore;
    
    @Column(name = "freshness_score")
    private Double freshnessScore;
    
    @Column(name = "quality_score")
    private Double qualityScore;
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "rule_violations", columnDefinition = "jsonb")
    private List<RuleViolation> ruleViolations;
    
    @Column(name = "timestamp", nullable = false)
    private LocalDateTime timestamp;
    
    @PrePersist
    protected void onCreate() {
        if (timestamp == null) {
            timestamp = LocalDateTime.now();
        }
    }
}
