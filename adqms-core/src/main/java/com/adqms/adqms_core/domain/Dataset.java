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
@Table(name = "datasets")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Dataset {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(nullable = false, unique = true)
    private String name;
    
    @Column(length = 1000)
    private String description;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "quality_profile", nullable = false)
    private QualityProfile qualityProfile;
    
    @Column(name = "expected_update_interval_hours")
    private Integer expectedUpdateIntervalHours;
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "alert_rules", columnDefinition = "jsonb")
    private Map<String, Object> alertRules;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (qualityProfile == null) {
            qualityProfile = QualityProfile.BALANCED;
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
