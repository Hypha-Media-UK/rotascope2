-- Migration: Create Data Freezing Tables
-- Date: 2025-09-27
-- Description: Create tables to store frozen schedule data for 07:59am snapshots

USE rotascope;

-- Table to store frozen schedule snapshots
CREATE TABLE IF NOT EXISTS frozen_schedules (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    schedule_data JSON NOT NULL,
    frozen_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_date (date),
    INDEX idx_frozen_at (frozen_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table to store individual frozen porter assignments for easier querying
CREATE TABLE IF NOT EXISTS frozen_porter_assignments (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    frozen_schedule_id INT UNSIGNED NOT NULL,
    porter_id INT UNSIGNED NOT NULL,
    shift_id INT UNSIGNED NOT NULL,
    is_active_today BOOLEAN NOT NULL DEFAULT FALSE,
    is_temporarily_assigned BOOLEAN NOT NULL DEFAULT FALSE,
    temp_assignment_location VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (frozen_schedule_id) REFERENCES frozen_schedules(id) ON DELETE CASCADE,
    FOREIGN KEY (porter_id) REFERENCES porters(id) ON DELETE CASCADE,
    FOREIGN KEY (shift_id) REFERENCES shifts(id) ON DELETE CASCADE,
    
    INDEX idx_frozen_schedule (frozen_schedule_id),
    INDEX idx_porter (porter_id),
    INDEX idx_shift (shift_id),
    INDEX idx_active_today (is_active_today),
    INDEX idx_temp_assigned (is_temporarily_assigned)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add a column to track if a day's data has been frozen (for UI indicators)
ALTER TABLE porters ADD COLUMN last_frozen_date DATE NULL AFTER temp_assignment_end;

-- Create an index for performance
CREATE INDEX idx_last_frozen_date ON porters(last_frozen_date);

-- Verify tables were created
SHOW TABLES LIKE 'frozen%';
DESCRIBE frozen_schedules;
DESCRIBE frozen_porter_assignments;
