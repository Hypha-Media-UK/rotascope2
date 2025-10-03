-- Migration: Change temporary assignment fields from DATE to TIME
-- Purpose: Support shift-based temporary assignments with start/end times instead of dates
-- Date: 2025-10-03

USE rotascope;

-- Drop existing temporary assignment data (since we're changing the data type)
UPDATE porters SET 
    temp_assignment_start = NULL,
    temp_assignment_end = NULL
WHERE temp_assignment_start IS NOT NULL OR temp_assignment_end IS NOT NULL;

-- Change temp_assignment_start from DATE to TIME
ALTER TABLE porters 
    MODIFY COLUMN temp_assignment_start TIME NULL 
    COMMENT 'Start time for temporary assignment within current shift';

-- Change temp_assignment_end from DATE to TIME  
ALTER TABLE porters 
    MODIFY COLUMN temp_assignment_end TIME NULL 
    COMMENT 'End time for temporary assignment within current shift';

-- Add constraint to ensure end time is after start time (when both are set)
-- Note: This constraint will be checked at the application level since MySQL TIME constraints are complex

-- Update any existing temporary assignments to use current shift times as defaults
-- (This is mainly for future reference - current data was cleared above)

-- Verify the changes
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'rotascope' 
    AND TABLE_NAME = 'porters' 
    AND COLUMN_NAME IN ('temp_assignment_start', 'temp_assignment_end');
