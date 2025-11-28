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
@Table(name = "alerts")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Alert {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dataset_id", nullable = false)
    private Dataset dataset;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    private AlertType type;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "severity", nullable = false)
    private AlertSeverity severity;
    
    @Column(name = "message", nullable = false, length = 2000)
    private String message;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private AlertStatus status;
    
    @Column(name = "first_seen_at", nullable = false)
    private LocalDateTime firstSeenAt;
    
    @Column(name = "last_seen_at", nullable = false)
    private LocalDateTime lastSeenAt;
    
    @Column(name = "occurrence_count", nullable = false)
    private Integer occurrenceCount;
    
    @Column(name = "resolved_at")
    private LocalDateTime resolvedAt;
    
    @Column(name = "resolved_by")
    private String resolvedBy;
    
    @Column(name = "acknowledged_by")
    private String acknowledgedBy;
    
    @Column(name = "acknowledged_at")
    private LocalDateTime acknowledgedAt;
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "metadata", columnDefinition = "jsonb")
    private Map<String, Object> metadata;
    
    @PrePersist
    protected void onCreate() {
        if (firstSeenAt == null) {
            firstSeenAt = LocalDateTime.now();
        }
        if (lastSeenAt == null) {
            lastSeenAt = LocalDateTime.now();
        }
        if (status == null) {
            status = AlertStatus.NEW;
        }
        if (occurrenceCount == null) {
            occurrenceCount = 1;
        }
    }
}
