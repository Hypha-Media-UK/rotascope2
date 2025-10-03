-- Porter Tracking System - Production Database Schema
-- Version: 2.0
-- Created: 2025-09-26
-- 
-- This schema implements proper constraints, indexes, and business rules
-- for a production-ready porter management system.

SET FOREIGN_KEY_CHECKS = 1;
SET sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS rotascope CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE rotascope;

-- ============================================================================
-- CORE ENTITIES
-- ============================================================================

-- Departments table with proper constraints
CREATE TABLE departments (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL, -- Short code for departments (e.g., 'ED', 'AMU')
    is_24_7 BOOLEAN NOT NULL DEFAULT FALSE,
    porters_required_day INT UNSIGNED NOT NULL DEFAULT 1,
    porters_required_night INT UNSIGNED NOT NULL DEFAULT 1,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_dept_name_length CHECK (CHAR_LENGTH(name) >= 2),
    CONSTRAINT chk_dept_code_length CHECK (CHAR_LENGTH(code) >= 2),
    CONSTRAINT chk_dept_porters_day CHECK (porters_required_day > 0),
    CONSTRAINT chk_dept_porters_night CHECK (porters_required_night > 0),
    
    -- Indexes
    UNIQUE KEY uk_dept_name (name),
    UNIQUE KEY uk_dept_code (code),
    INDEX idx_dept_active (is_active),
    INDEX idx_dept_24_7 (is_24_7)
);

-- Services table (separate from departments for future expansion)
CREATE TABLE services (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL,
    is_24_7 BOOLEAN NOT NULL DEFAULT FALSE,
    porters_required_day INT UNSIGNED NOT NULL DEFAULT 1,
    porters_required_night INT UNSIGNED NOT NULL DEFAULT 1,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_svc_name_length CHECK (CHAR_LENGTH(name) >= 2),
    CONSTRAINT chk_svc_code_length CHECK (CHAR_LENGTH(code) >= 2),
    CONSTRAINT chk_svc_porters_day CHECK (porters_required_day > 0),
    CONSTRAINT chk_svc_porters_night CHECK (porters_required_night > 0),
    
    -- Indexes
    UNIQUE KEY uk_svc_name (name),
    UNIQUE KEY uk_svc_code (code),
    INDEX idx_svc_active (is_active),
    INDEX idx_svc_24_7 (is_24_7)
);

-- Operating hours for departments (standardized day numbering: 1=Monday, 7=Sunday)
CREATE TABLE department_hours (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    department_id INT UNSIGNED NOT NULL,
    day_of_week TINYINT UNSIGNED NOT NULL, -- 1=Monday, 2=Tuesday, ..., 7=Sunday
    opens_at TIME NOT NULL,
    closes_at TIME NOT NULL,
    porters_required INT UNSIGNED NOT NULL DEFAULT 1,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_dept_hours_day CHECK (day_of_week BETWEEN 1 AND 7),
    CONSTRAINT chk_dept_hours_porters CHECK (porters_required > 0),
    CONSTRAINT chk_dept_hours_times CHECK (opens_at < closes_at),
    
    -- Foreign keys
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    
    -- Indexes
    UNIQUE KEY uk_dept_hours_day (department_id, day_of_week),
    INDEX idx_dept_hours_day (day_of_week),
    INDEX idx_dept_hours_active (is_active)
);

-- Operating hours for services
CREATE TABLE service_hours (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    service_id INT UNSIGNED NOT NULL,
    day_of_week TINYINT UNSIGNED NOT NULL, -- 1=Monday, 2=Tuesday, ..., 7=Sunday
    opens_at TIME NOT NULL,
    closes_at TIME NOT NULL,
    porters_required INT UNSIGNED NOT NULL DEFAULT 1,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_svc_hours_day CHECK (day_of_week BETWEEN 1 AND 7),
    CONSTRAINT chk_svc_hours_porters CHECK (porters_required > 0),
    CONSTRAINT chk_svc_hours_times CHECK (opens_at < closes_at),
    
    -- Foreign keys
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
    
    -- Indexes
    UNIQUE KEY uk_svc_hours_day (service_id, day_of_week),
    INDEX idx_svc_hours_day (day_of_week),
    INDEX idx_svc_hours_active (is_active)
);

-- Shift types table for flexible shift categorization
CREATE TABLE shift_types (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    starts_at TIME NOT NULL,
    ends_at TIME NOT NULL,
    display_type ENUM('DAY', 'NIGHT') NOT NULL DEFAULT 'DAY',
    color VARCHAR(7) NULL, -- Hex color code #FF5733
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_shift_type_name_length CHECK (CHAR_LENGTH(name) >= 3),
    CONSTRAINT chk_shift_type_times CHECK (starts_at != ends_at),
    CONSTRAINT chk_shift_type_color CHECK (color IS NULL OR color REGEXP '^#[0-9A-Fa-f]{6}$'),

    -- Indexes
    UNIQUE KEY uk_shift_type_name (name),
    INDEX idx_shift_type_display (display_type),
    INDEX idx_shift_type_active (is_active)
);

-- Shifts table with proper validation
CREATE TABLE shifts (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    shift_type_id INT UNSIGNED NULL,
    starts_at TIME NOT NULL,
    ends_at TIME NOT NULL,
    days_on TINYINT UNSIGNED NOT NULL DEFAULT 1,
    days_off TINYINT UNSIGNED NOT NULL DEFAULT 1,
    shift_offset TINYINT UNSIGNED NOT NULL DEFAULT 0,
    ground_zero_date DATE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_shift_name_length CHECK (CHAR_LENGTH(name) >= 3),
    CONSTRAINT chk_shift_days_on CHECK (days_on BETWEEN 1 AND 14),
    CONSTRAINT chk_shift_days_off CHECK (days_off BETWEEN 1 AND 14),
    CONSTRAINT chk_shift_offset CHECK (shift_offset <= 13),

    -- Foreign keys
    FOREIGN KEY (shift_type_id) REFERENCES shift_types(id) ON DELETE SET NULL,

    -- Indexes
    UNIQUE KEY uk_shift_name (name),
    INDEX idx_shift_type_id (shift_type_id),
    INDEX idx_shift_active (is_active)
);

-- ============================================================================
-- PORTER MANAGEMENT
-- ============================================================================

-- Porters table with comprehensive validation
CREATE TABLE porters (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    employee_id VARCHAR(20) NULL, -- External employee ID
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NULL,
    phone VARCHAR(20) NULL,
    porter_type ENUM('PORTER', 'SUPERVISOR', 'SENIOR_PORTER') NOT NULL DEFAULT 'PORTER',
    weekly_contracted_hours DECIMAL(4,2) NOT NULL DEFAULT 37.50,
    has_custom_hours BOOLEAN NOT NULL DEFAULT FALSE,
    shift_id INT UNSIGNED NULL, -- For shift-based porters
    regular_department_id INT UNSIGNED NULL, -- Primary department assignment
    is_floor_staff BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_porter_name_length CHECK (CHAR_LENGTH(name) >= 2),
    CONSTRAINT chk_porter_email_format CHECK (email IS NULL OR email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_porter_hours CHECK (weekly_contracted_hours BETWEEN 0.00 AND 60.00),

    -- Foreign keys
    FOREIGN KEY (shift_id) REFERENCES shifts(id) ON DELETE SET NULL,
    FOREIGN KEY (regular_department_id) REFERENCES departments(id) ON DELETE SET NULL,

    -- Indexes
    UNIQUE KEY uk_porter_employee_id (employee_id),
    UNIQUE KEY uk_porter_email (email),
    INDEX idx_porter_name (name),
    INDEX idx_porter_type (porter_type),
    INDEX idx_porter_custom_hours (has_custom_hours),
    INDEX idx_porter_active (is_active),
    INDEX idx_porter_shift (shift_id),
    INDEX idx_porter_department (regular_department_id)
);

-- Custom hours for porters with non-standard schedules
CREATE TABLE porter_custom_hours (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    porter_id INT UNSIGNED NOT NULL,
    day_of_week TINYINT UNSIGNED NOT NULL, -- 1=Monday, 2=Tuesday, ..., 7=Sunday
    starts_at TIME NOT NULL,
    ends_at TIME NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_custom_hours_day CHECK (day_of_week BETWEEN 1 AND 7),
    CONSTRAINT chk_custom_hours_times CHECK (starts_at < ends_at),

    -- Foreign keys
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,

    -- Indexes
    UNIQUE KEY uk_porter_custom_day (porter_id, day_of_week),
    INDEX idx_custom_hours_day (day_of_week),
    INDEX idx_custom_hours_active (is_active)
);

-- ============================================================================
-- ASSIGNMENTS AND SCHEDULING
-- ============================================================================

-- Porter assignments (both permanent and temporary)
CREATE TABLE porter_assignments (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    porter_id INT UNSIGNED NOT NULL,
    department_id INT UNSIGNED NULL,
    service_id INT UNSIGNED NULL,
    assignment_type ENUM('PERMANENT', 'TEMPORARY', 'RELIEF', 'OVERTIME') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL, -- NULL for permanent assignments
    priority TINYINT UNSIGNED NOT NULL DEFAULT 1, -- 1=highest, 5=lowest
    notes TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by VARCHAR(100) NULL, -- User who created the assignment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_assignment_dates CHECK (end_date IS NULL OR start_date <= end_date),
    CONSTRAINT chk_assignment_target CHECK (
        (department_id IS NOT NULL AND service_id IS NULL) OR
        (department_id IS NULL AND service_id IS NOT NULL)
    ),
    CONSTRAINT chk_assignment_priority CHECK (priority BETWEEN 1 AND 5),

    -- Foreign keys
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,

    -- Indexes
    INDEX idx_assignment_porter (porter_id),
    INDEX idx_assignment_department (department_id),
    INDEX idx_assignment_service (service_id),
    INDEX idx_assignment_dates (start_date, end_date),
    INDEX idx_assignment_type (assignment_type),
    INDEX idx_assignment_active (is_active)
);
