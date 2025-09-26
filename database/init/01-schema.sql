-- Porter Tracking System Database Schema
-- Created: 2025-09-26

-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS rotascope;
USE rotascope;

-- Departments table
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    is_24_7 BOOLEAN DEFAULT FALSE,
    porters_required INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_name (name)
);

-- Department operational hours (for non-24/7 departments)
CREATE TABLE department_hours (
    id INT PRIMARY KEY AUTO_INCREMENT,
    department_id INT NOT NULL,
    day_of_week TINYINT NOT NULL, -- 0=Sunday, 1=Monday, ..., 6=Saturday
    opens_at TIME NOT NULL,
    closes_at TIME NOT NULL,
    porters_required INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    UNIQUE KEY unique_dept_day (department_id, day_of_week),
    INDEX idx_department_day (department_id, day_of_week)
);

-- Shifts table
CREATE TABLE shifts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    shift_type ENUM('DAY', 'NIGHT') NOT NULL,
    shift_ident ENUM('A', 'B', 'C', 'D') NOT NULL,
    starts_at TIME NOT NULL,
    ends_at TIME NOT NULL,
    days_on INT NOT NULL DEFAULT 1,
    days_off INT NOT NULL DEFAULT 1,
    shift_offset INT NOT NULL DEFAULT 0, -- Days offset from other shifts
    ground_zero DATE NOT NULL, -- Reference date for cycle calculation
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_type_ident (shift_type, shift_ident),
    INDEX idx_shift_type (shift_type),
    INDEX idx_shift_ident (shift_ident)
);

-- Porters table
CREATE TABLE porters (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    porter_type ENUM('PORTER', 'SUPERVISOR') DEFAULT 'PORTER',
    contracted_hours_type ENUM('SHIFT', 'CUSTOM', 'RELIEF') NOT NULL,
    shift_id INT NULL, -- NULL for custom/relief porters
    shift_offset INT DEFAULT 0, -- Individual porter offset from shift cycle
    regular_department_id INT NULL, -- NULL for floor staff
    is_floor_staff BOOLEAN DEFAULT FALSE,
    weekly_hours DECIMAL(4,2) DEFAULT 37.5, -- For relief porters
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (shift_id) REFERENCES shifts(id) ON DELETE SET NULL,
    FOREIGN KEY (regular_department_id) REFERENCES departments(id) ON DELETE SET NULL,
    INDEX idx_name (name),
    INDEX idx_porter_type (porter_type),
    INDEX idx_contracted_type (contracted_hours_type),
    INDEX idx_shift (shift_id),
    INDEX idx_department (regular_department_id)
);

-- Porter custom hours (for porters with custom schedules)
CREATE TABLE porter_hours (
    id INT PRIMARY KEY AUTO_INCREMENT,
    porter_id INT NOT NULL,
    day_of_week TINYINT NOT NULL, -- 0=Sunday, 1=Monday, ..., 6=Saturday
    starts_at TIME NOT NULL,
    ends_at TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    UNIQUE KEY unique_porter_day (porter_id, day_of_week),
    INDEX idx_porter_day (porter_id, day_of_week)
);

-- Porter annual leave
CREATE TABLE porter_annual_leave (
    id INT PRIMARY KEY AUTO_INCREMENT,
    porter_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    INDEX idx_porter_dates (porter_id, start_date, end_date)
);

-- Porter sickness
CREATE TABLE porter_sickness (
    id INT PRIMARY KEY AUTO_INCREMENT,
    porter_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL, -- NULL for ongoing sickness
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    INDEX idx_porter_dates (porter_id, start_date, end_date)
);

-- Porter absences (short-term, appointments, etc.)
CREATE TABLE porter_absences (
    id INT PRIMARY KEY AUTO_INCREMENT,
    porter_id INT NOT NULL,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME NOT NULL,
    reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    INDEX idx_porter_datetime (porter_id, start_datetime, end_datetime)
);

-- Porter assignments (including temporary/relief assignments)
CREATE TABLE porter_assignments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    porter_id INT NOT NULL,
    department_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL, -- NULL for permanent assignments
    assignment_type ENUM('PERMANENT', 'TEMPORARY', 'RELIEF') DEFAULT 'PERMANENT',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    INDEX idx_porter_dates (porter_id, start_date, end_date),
    INDEX idx_department_dates (department_id, start_date, end_date),
    INDEX idx_assignment_type (assignment_type)
);
