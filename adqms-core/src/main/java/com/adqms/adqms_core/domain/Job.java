package com.adqms.adqms_core.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "jobs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Job {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dataset_id", nullable = false)
    private Dataset dataset;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    private JobType type;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private JobStatus status;
    
    @Column(name = "progress")
    private Integer progress;
    
    @Column(name = "error_message", length = 2000)
    private String errorMessage;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "started_at")
    private LocalDateTime startedAt;
    
    @Column(name = "completed_at")
    private LocalDateTime completedAt;
    
    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (status == null) {
            status = JobStatus.QUEUED;
        }
        if (progress == null) {
            progress = 0;
        }
    }
}
