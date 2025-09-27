-- Migration: Home Page Enhancements - Porter Assignment System
-- Date: 2025-09-27
-- Description: Add porter offset, temporary assignments, and update porter/assignment types
-- 
-- This migration implements the requirements for:
-- 1. Individual porter offsets for shift straddling
-- 2. Temporary department/service assignments
-- 3. Simplified porter types (REGULAR/RELIEF)
-- 4. Updated assignment types (REGULAR/RELIEF)

USE rotascope;

-- ============================================================================
-- BACKUP EXISTING DATA
-- ============================================================================

-- Create backup tables before making changes
CREATE TABLE porters_backup_20250927 AS SELECT * FROM porters;
CREATE TABLE porter_assignments_backup_20250927 AS SELECT * FROM porter_assignments;

-- ============================================================================
-- SCHEMA MODIFICATIONS
-- ============================================================================

-- Add porter offset field for shift straddling
ALTER TABLE porters 
ADD COLUMN porter_offset TINYINT UNSIGNED DEFAULT 0 AFTER shift_id,
ADD CONSTRAINT chk_porter_offset CHECK (porter_offset <= 13);

-- Add temporary assignment fields to porters table
ALTER TABLE porters 
ADD COLUMN temp_department_id INT UNSIGNED NULL AFTER regular_department_id,
ADD COLUMN temp_service_id INT UNSIGNED NULL AFTER temp_department_id,
ADD COLUMN temp_assignment_start DATE NULL AFTER temp_service_id,
ADD COLUMN temp_assignment_end DATE NULL AFTER temp_assignment_start;

-- Add foreign key constraints for temporary assignments
ALTER TABLE porters 
ADD CONSTRAINT fk_porter_temp_dept FOREIGN KEY (temp_department_id) REFERENCES departments(id) ON DELETE SET NULL,
ADD CONSTRAINT fk_porter_temp_service FOREIGN KEY (temp_service_id) REFERENCES services(id) ON DELETE SET NULL;

-- Add constraint to ensure temp assignment dates are logical
ALTER TABLE porters 
ADD CONSTRAINT chk_temp_assignment_dates 
CHECK (temp_assignment_start IS NULL OR temp_assignment_end IS NULL OR temp_assignment_start <= temp_assignment_end);

-- Add constraint to ensure only one temp assignment type at a time
ALTER TABLE porters 
ADD CONSTRAINT chk_temp_assignment_exclusive 
CHECK (NOT (temp_department_id IS NOT NULL AND temp_service_id IS NOT NULL));

-- ============================================================================
-- UPDATE PORTER TYPES
-- ============================================================================

-- Step 1: Add new porter_type_new column with correct enum
ALTER TABLE porters ADD COLUMN porter_type_new ENUM('REGULAR', 'RELIEF') NOT NULL DEFAULT 'REGULAR';

-- Step 2: Populate new column based on contracted_hours_type logic
UPDATE porters SET porter_type_new = 'RELIEF' WHERE contracted_hours_type = 'RELIEF';
UPDATE porters SET porter_type_new = 'REGULAR' WHERE contracted_hours_type IN ('SHIFT', 'CUSTOM', 'PART_TIME');

-- Step 3: Drop old column and rename new one
ALTER TABLE porters DROP COLUMN porter_type;
ALTER TABLE porters CHANGE porter_type_new porter_type ENUM('REGULAR', 'RELIEF') NOT NULL DEFAULT 'REGULAR';

-- ============================================================================
-- UPDATE ASSIGNMENT TYPES
-- ============================================================================

-- Step 1: Add new assignment_type_new column with correct enum
ALTER TABLE porter_assignments ADD COLUMN assignment_type_new ENUM('REGULAR', 'RELIEF') NOT NULL DEFAULT 'REGULAR';

-- Step 2: Populate new column
UPDATE porter_assignments SET assignment_type_new = 'REGULAR' WHERE assignment_type IN ('PERMANENT', 'TEMPORARY', 'OVERTIME');
UPDATE porter_assignments SET assignment_type_new = 'RELIEF' WHERE assignment_type = 'RELIEF';

-- Step 3: Drop old column and rename new one
ALTER TABLE porter_assignments DROP COLUMN assignment_type;
ALTER TABLE porter_assignments CHANGE assignment_type_new assignment_type ENUM('REGULAR', 'RELIEF') NOT NULL DEFAULT 'REGULAR';

-- ============================================================================
-- RANDOM ASSIGNMENT GENERATION FOR TESTING
-- ============================================================================

-- Randomly assign porter offsets (0-3 days) to shift-based porters for testing
UPDATE porters 
SET porter_offset = FLOOR(RAND() * 4) 
WHERE shift_id IS NOT NULL AND contracted_hours_type = 'SHIFT';

-- Create some temporary assignments for testing (next 30 days)
-- Assign some shift porters temporarily to different departments

-- Rob Mcpartland (ID 1) temporarily to Pharmacy for 1 week
UPDATE porters 
SET temp_department_id = 8, 
    temp_assignment_start = CURDATE() + INTERVAL 2 DAY,
    temp_assignment_end = CURDATE() + INTERVAL 8 DAY
WHERE id = 1;

-- John Evans (ID 2) temporarily to PTS for 5 days  
UPDATE porters 
SET temp_department_id = 7,
    temp_assignment_start = CURDATE() + INTERVAL 5 DAY,
    temp_assignment_end = CURDATE() + INTERVAL 9 DAY
WHERE id = 2;

-- Charlotte Rimmer (ID 3) temporarily to Post service for 3 days
UPDATE porters 
SET temp_service_id = 1,
    temp_assignment_start = CURDATE() + INTERVAL 1 DAY,
    temp_assignment_end = CURDATE() + INTERVAL 3 DAY
WHERE id = 3;

-- Carla Barton (ID 4) temporarily to Medical Records for 1 week
UPDATE porters 
SET temp_service_id = 2,
    temp_assignment_start = CURDATE() + INTERVAL 7 DAY,
    temp_assignment_end = CURDATE() + INTERVAL 13 DAY
WHERE id = 4;

-- Andrew Trudgeon (ID 5) temporarily to X-ray GF for 4 days
UPDATE porters 
SET temp_department_id = 4,
    temp_assignment_start = CURDATE() + INTERVAL 3 DAY,
    temp_assignment_end = CURDATE() + INTERVAL 6 DAY
WHERE id = 5;

-- ============================================================================
-- ASSIGN UNASSIGNED PORTERS TO SHIFTS AND DEPARTMENTS
-- ============================================================================

-- Randomly assign some relief porters to shifts for testing
-- This gives us more porters to work with in the shift cards

-- Assign relief porters to shifts (randomly distributed)
UPDATE porters 
SET shift_id = (FLOOR(RAND() * 4) + 1),
    regular_department_id = (FLOOR(RAND() * 8) + 1),
    porter_offset = FLOOR(RAND() * 3)
WHERE contracted_hours_type = 'RELIEF' 
AND id BETWEEN 9 AND 20  -- First 12 relief porters
AND shift_id IS NULL;

-- Assign some more relief porters to departments without shifts (for department-only assignments)
UPDATE porters 
SET regular_department_id = (FLOOR(RAND() * 8) + 1)
WHERE contracted_hours_type = 'RELIEF' 
AND id BETWEEN 21 AND 30  -- Next 10 relief porters
AND regular_department_id IS NULL;

-- ============================================================================
-- CREATE ADDITIONAL PORTER ASSIGNMENTS FOR TESTING
-- ============================================================================

-- Create some additional porter assignments in the porter_assignments table
-- These represent historical or additional assignments

INSERT INTO porter_assignments (porter_id, department_id, assignment_type, start_date, priority, notes, is_active) VALUES
-- Additional assignments for shift porters
(9, 2, 'REGULAR', '2025-01-01', 2, 'Relief porter assigned to AMU', TRUE),
(10, 3, 'REGULAR', '2025-01-01', 2, 'Relief porter assigned to CT Scan', TRUE),
(11, 4, 'REGULAR', '2025-01-01', 2, 'Relief porter assigned to X-ray GF', TRUE),
(12, 5, 'REGULAR', '2025-01-01', 2, 'Relief porter assigned to X-ray LGF', TRUE),
(13, 6, 'REGULAR', '2025-01-01', 2, 'Relief porter assigned to MRI', TRUE),
(14, 7, 'REGULAR', '2025-01-01', 2, 'Relief porter assigned to PTS', TRUE),
(15, 8, 'REGULAR', '2025-01-01', 2, 'Relief porter assigned to Pharmacy', TRUE),
(16, 1, 'REGULAR', '2025-01-01', 2, 'Relief porter assigned to ED', TRUE);

-- Create some service assignments
INSERT INTO porter_assignments (porter_id, service_id, assignment_type, start_date, priority, notes, is_active) VALUES
(17, 1, 'REGULAR', '2025-01-01', 3, 'Relief porter assigned to Post service', TRUE),
(18, 2, 'REGULAR', '2025-01-01', 3, 'Relief porter assigned to Medical Records', TRUE),
(19, 3, 'REGULAR', '2025-01-01', 3, 'Relief porter assigned to Sharps Collection', TRUE),
(20, 4, 'REGULAR', '2025-01-01', 3, 'Relief porter assigned to Blood Drivers', TRUE);

-- ============================================================================
-- ADD INDEXES FOR PERFORMANCE
-- ============================================================================

-- Add indexes for the new fields to improve query performance
CREATE INDEX idx_porter_offset ON porters(porter_offset);
CREATE INDEX idx_porter_temp_dept ON porters(temp_department_id);
CREATE INDEX idx_porter_temp_service ON porters(temp_service_id);
CREATE INDEX idx_porter_temp_dates ON porters(temp_assignment_start, temp_assignment_end);

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Show summary of changes
SELECT 
    'Total Porters' as metric,
    COUNT(*) as count
FROM porters
WHERE is_active = 1

UNION ALL

SELECT 
    'Porters with Shifts' as metric,
    COUNT(*) as count
FROM porters 
WHERE shift_id IS NOT NULL AND is_active = 1

UNION ALL

SELECT 
    'Porters with Offsets' as metric,
    COUNT(*) as count
FROM porters 
WHERE porter_offset > 0 AND is_active = 1

UNION ALL

SELECT 
    'Porters with Temp Assignments' as metric,
    COUNT(*) as count
FROM porters 
WHERE (temp_department_id IS NOT NULL OR temp_service_id IS NOT NULL) AND is_active = 1

UNION ALL

SELECT 
    'Regular Porters' as metric,
    COUNT(*) as count
FROM porters 
WHERE porter_type = 'REGULAR' AND is_active = 1

UNION ALL

SELECT 
    'Relief Porters' as metric,
    COUNT(*) as count
FROM porters 
WHERE porter_type = 'RELIEF' AND is_active = 1;

-- Show sample of porters with their assignments
SELECT 
    p.id,
    p.name,
    p.porter_type,
    p.contracted_hours_type,
    s.name as shift_name,
    p.porter_offset,
    d1.name as regular_department,
    d2.name as temp_department,
    sv.name as temp_service,
    p.temp_assignment_start,
    p.temp_assignment_end
FROM porters p
LEFT JOIN shifts s ON p.shift_id = s.id
LEFT JOIN departments d1 ON p.regular_department_id = d1.id
LEFT JOIN departments d2 ON p.temp_department_id = d2.id
LEFT JOIN services sv ON p.temp_service_id = sv.id
WHERE p.is_active = 1
ORDER BY p.id
LIMIT 20;

-- Migration completed successfully
SELECT 'Migration 06-home-page-enhancements.sql completed successfully' as status;
