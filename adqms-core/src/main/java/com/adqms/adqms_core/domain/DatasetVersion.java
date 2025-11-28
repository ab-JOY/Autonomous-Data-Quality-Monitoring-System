package com.adqms.adqms_core.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.UUID;

@Entity
@Table(name = "dataset_versions", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"dataset_id", "version_number"}))
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DatasetVersion {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dataset_id", nullable = false)
    private Dataset dataset;
    
    @Column(name = "version_number", nullable = false)
    private Integer versionNumber;
    
    @Column(name = "ingested_at", nullable = false)
    private LocalDateTime ingestedAt;
    
    @Column(name = "row_count", nullable = false)
    private Long rowCount;
    
    @Column(name = "column_count", nullable = false)
    private Integer columnCount;
    
    @Column(name = "schema_hash", nullable = false)
    private String schemaHash;
    
    @Column(name = "is_baseline", nullable = false)
    private Boolean isBaseline;
    
    @Column(name = "baseline_established_at")
    private LocalDateTime baselineEstablishedAt;
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "statistical_summary", columnDefinition = "jsonb")
    private Map<String, Object> statisticalSummary;
    
    @PrePersist
    protected void onCreate() {
        if (ingestedAt == null) {
            ingestedAt = LocalDateTime.now();
        }
        if (isBaseline == null) {
            isBaseline = false;
        }
    }
}
