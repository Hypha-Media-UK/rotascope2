-- Migration: Simplify Porter Types to REGULAR and RELIEF
-- Date: 2025-09-27
-- Description: Update porter_type enum to only include REGULAR and RELIEF as requested

USE rotascope;

-- First, let's see current porter types
SELECT porter_type, COUNT(*) as count FROM porters GROUP BY porter_type;

-- Update existing porter types to new simplified system
-- PORTER -> REGULAR
-- SENIOR_PORTER -> REGULAR  
-- SUPERVISOR -> REGULAR (assuming supervisors are regular staff)

UPDATE porters SET porter_type = 'REGULAR' WHERE porter_type IN ('PORTER', 'SENIOR_PORTER', 'SUPERVISOR');

-- Verify the update
SELECT porter_type, COUNT(*) as count FROM porters GROUP BY porter_type;

-- Now update the enum constraint
-- We need to drop and recreate the column with new enum values
ALTER TABLE porters ADD COLUMN porter_type_new ENUM('REGULAR', 'RELIEF') NOT NULL DEFAULT 'REGULAR';

-- Copy data to new column
UPDATE porters SET porter_type_new = 'REGULAR' WHERE porter_type IN ('PORTER', 'SENIOR_PORTER', 'SUPERVISOR');
UPDATE porters SET porter_type_new = 'RELIEF' WHERE porter_type = 'RELIEF';

-- Drop old column and rename new one
ALTER TABLE porters DROP COLUMN porter_type;
ALTER TABLE porters CHANGE COLUMN porter_type_new porter_type ENUM('REGULAR', 'RELIEF') NOT NULL DEFAULT 'REGULAR';

-- Verify final result
SELECT porter_type, COUNT(*) as count FROM porters GROUP BY porter_type;

-- Also update assignment_type enum if it exists and needs simplification
-- Check current assignment types
SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rotascope' 
AND TABLE_NAME = 'porter_assignments' 
AND COLUMN_NAME = 'assignment_type';

-- Update assignment types to match (if the table exists)
-- This will only run if the table exists
SET @sql = (
    SELECT IF(
        COUNT(*) > 0,
        'ALTER TABLE porter_assignments MODIFY COLUMN assignment_type ENUM(''REGULAR'', ''RELIEF'') NOT NULL DEFAULT ''REGULAR'';',
        'SELECT ''porter_assignments table does not exist or assignment_type column not found'' as message;'
    )
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'rotascope' 
    AND TABLE_NAME = 'porter_assignments' 
    AND COLUMN_NAME = 'assignment_type'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Final verification
DESCRIBE porters;
SELECT porter_type, COUNT(*) as count FROM porters GROUP BY porter_type;
