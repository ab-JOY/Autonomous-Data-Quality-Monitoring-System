package com.adqms.adqms_core.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RuleViolation implements Serializable {
    private String ruleName;
    private String columnName;
    private String severity;
    private Long violationCount;
    private String details;
}
