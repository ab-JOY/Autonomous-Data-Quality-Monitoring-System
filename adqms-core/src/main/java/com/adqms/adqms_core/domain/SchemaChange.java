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
@Table(name = "schema_changes")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SchemaChange {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dataset_id", nullable = false)
    private Dataset dataset;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "from_version_id")
    private DatasetVersion fromVersion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "to_version_id", nullable = false)
    private DatasetVersion toVersion;
    
    @Column(name = "change_type", nullable = false)
    private String changeType;
    
    @Column(name = "column_name")
    private String columnName;
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "details", columnDefinition = "jsonb")
    private Map<String, Object> details;
    
    @Column(name = "detected_at", nullable = false)
    private LocalDateTime detectedAt;
    
    @PrePersist
    protected void onCreate() {
        if (detectedAt == null) {
            detectedAt = LocalDateTime.now();
        }
    }
}
