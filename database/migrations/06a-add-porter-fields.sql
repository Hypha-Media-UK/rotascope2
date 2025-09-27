-- Migration: Add Porter Fields for Home Page Enhancements
-- Date: 2025-09-27
-- Description: Add porter offset and temporary assignment fields

USE rotascope;

-- Add porter offset field for shift straddling
ALTER TABLE porters 
ADD COLUMN porter_offset TINYINT UNSIGNED DEFAULT 0 AFTER shift_id;

-- Add constraint for porter offset
ALTER TABLE porters 
ADD CONSTRAINT chk_porter_offset CHECK (porter_offset <= 13);

-- Add temporary assignment fields to porters table
ALTER TABLE porters 
ADD COLUMN temp_department_id INT UNSIGNED NULL AFTER regular_department_id,
ADD COLUMN temp_service_id INT UNSIGNED NULL AFTER temp_department_id,
ADD COLUMN temp_assignment_start DATE NULL AFTER temp_service_id,
ADD COLUMN temp_assignment_end DATE NULL AFTER temp_assignment_start;

-- Add foreign key constraints for temporary assignments
ALTER TABLE porters 
ADD CONSTRAINT fk_porter_temp_dept FOREIGN KEY (temp_department_id) REFERENCES departments(id) ON DELETE SET NULL;

ALTER TABLE porters 
ADD CONSTRAINT fk_porter_temp_service FOREIGN KEY (temp_service_id) REFERENCES services(id) ON DELETE SET NULL;

-- Add constraint to ensure temp assignment dates are logical
ALTER TABLE porters 
ADD CONSTRAINT chk_temp_assignment_dates 
CHECK (temp_assignment_start IS NULL OR temp_assignment_end IS NULL OR temp_assignment_start <= temp_assignment_end);

-- Add constraint to ensure only one temp assignment type at a time
ALTER TABLE porters 
ADD CONSTRAINT chk_temp_assignment_exclusive 
CHECK (NOT (temp_department_id IS NOT NULL AND temp_service_id IS NOT NULL));

-- Add indexes for performance
CREATE INDEX idx_porter_offset ON porters(porter_offset);
CREATE INDEX idx_porter_temp_dept ON porters(temp_department_id);
CREATE INDEX idx_porter_temp_service ON porters(temp_service_id);
CREATE INDEX idx_porter_temp_dates ON porters(temp_assignment_start, temp_assignment_end);

SELECT 'Porter fields added successfully' as status;
