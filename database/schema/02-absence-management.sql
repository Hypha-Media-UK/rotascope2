-- Porter Tracking System - Absence Management Schema
-- Version: 2.0
-- Created: 2025-09-26

USE rotascope;

-- ============================================================================
-- ABSENCE MANAGEMENT
-- ============================================================================

-- Annual leave tracking
CREATE TABLE porter_annual_leave (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    porter_id INT UNSIGNED NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested DECIMAL(3,1) NOT NULL, -- Allow half days
    days_approved DECIMAL(3,1) NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    request_date DATE NOT NULL,
    approved_date DATE NULL,
    approved_by VARCHAR(100) NULL,
    notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_leave_dates CHECK (start_date <= end_date),
    CONSTRAINT chk_leave_days_requested CHECK (days_requested > 0 AND days_requested <= 365),
    CONSTRAINT chk_leave_days_approved CHECK (days_approved IS NULL OR (days_approved > 0 AND days_approved <= days_requested)),
    CONSTRAINT chk_leave_request_date CHECK (request_date <= start_date),
    
    -- Foreign keys
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_leave_porter (porter_id),
    INDEX idx_leave_dates (start_date, end_date),
    INDEX idx_leave_status (status),
    INDEX idx_leave_request_date (request_date)
);

-- Sickness absence tracking
CREATE TABLE porter_sickness (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    porter_id INT UNSIGNED NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL, -- NULL for ongoing sickness
    days_count DECIMAL(3,1) NULL, -- Calculated when end_date is set
    sickness_type ENUM('SELF_CERTIFIED', 'MEDICAL_CERTIFICATE', 'OCCUPATIONAL_HEALTH') NOT NULL,
    return_to_work_interview BOOLEAN NOT NULL DEFAULT FALSE,
    fit_note_required BOOLEAN NOT NULL DEFAULT FALSE,
    fit_note_received BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_sickness_dates CHECK (end_date IS NULL OR start_date <= end_date),
    CONSTRAINT chk_sickness_days CHECK (days_count IS NULL OR days_count > 0),
    
    -- Foreign keys
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_sickness_porter (porter_id),
    INDEX idx_sickness_dates (start_date, end_date),
    INDEX idx_sickness_type (sickness_type),
    INDEX idx_sickness_ongoing (end_date) -- For finding ongoing sickness
);

-- Other absences (training, meetings, etc.)
CREATE TABLE porter_other_absences (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    porter_id INT UNSIGNED NOT NULL,
    absence_type ENUM('TRAINING', 'MEETING', 'DISCIPLINARY', 'SUSPENSION', 'OTHER') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    start_time TIME NULL, -- For partial day absences
    end_time TIME NULL,
    is_paid BOOLEAN NOT NULL DEFAULT TRUE,
    description VARCHAR(255) NOT NULL,
    notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_other_absence_dates CHECK (start_date <= end_date),
    CONSTRAINT chk_other_absence_times CHECK (
        (start_time IS NULL AND end_time IS NULL) OR 
        (start_time IS NOT NULL AND end_time IS NOT NULL AND start_time < end_time)
    ),
    CONSTRAINT chk_other_absence_description CHECK (CHAR_LENGTH(description) >= 3),
    
    -- Foreign keys
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_other_absence_porter (porter_id),
    INDEX idx_other_absence_dates (start_date, end_date),
    INDEX idx_other_absence_type (absence_type)
);

-- ============================================================================
-- SHIFT PATTERNS AND CALCULATIONS
-- ============================================================================

-- Shift pattern exceptions (bank holidays, special events)
CREATE TABLE shift_exceptions (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    exception_date DATE NOT NULL,
    exception_type ENUM('BANK_HOLIDAY', 'SPECIAL_EVENT', 'MAINTENANCE', 'EMERGENCY') NOT NULL,
    description VARCHAR(255) NOT NULL,
    affects_day_shift BOOLEAN NOT NULL DEFAULT TRUE,
    affects_night_shift BOOLEAN NOT NULL DEFAULT TRUE,
    staffing_multiplier DECIMAL(3,2) NOT NULL DEFAULT 1.00, -- 1.5 for increased staffing, 0.5 for reduced
    notes TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_exception_description CHECK (CHAR_LENGTH(description) >= 3),
    CONSTRAINT chk_exception_multiplier CHECK (staffing_multiplier BETWEEN 0.1 AND 5.0),
    
    -- Indexes
    UNIQUE KEY uk_exception_date_type (exception_date, exception_type),
    INDEX idx_exception_date (exception_date),
    INDEX idx_exception_type (exception_type),
    INDEX idx_exception_active (is_active)
);

-- ============================================================================
-- AUDIT AND LOGGING
-- ============================================================================

-- Audit trail for all changes
CREATE TABLE audit_log (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(64) NOT NULL,
    record_id INT UNSIGNED NOT NULL,
    action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_values JSON NULL,
    new_values JSON NULL,
    changed_by VARCHAR(100) NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    
    -- Indexes
    INDEX idx_audit_table_record (table_name, record_id),
    INDEX idx_audit_action (action),
    INDEX idx_audit_changed_at (changed_at),
    INDEX idx_audit_changed_by (changed_by)
);

-- System configuration
CREATE TABLE system_config (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    config_key VARCHAR(100) NOT NULL,
    config_value TEXT NOT NULL,
    config_type ENUM('STRING', 'INTEGER', 'DECIMAL', 'BOOLEAN', 'JSON') NOT NULL DEFAULT 'STRING',
    description TEXT NULL,
    is_system BOOLEAN NOT NULL DEFAULT FALSE, -- System configs cannot be deleted
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_config_key_length CHECK (CHAR_LENGTH(config_key) >= 3),
    
    -- Indexes
    UNIQUE KEY uk_config_key (config_key),
    INDEX idx_config_type (config_type),
    INDEX idx_config_system (is_system)
);
