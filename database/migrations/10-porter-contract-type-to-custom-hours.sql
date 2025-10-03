-- Migration: Replace Contract Type with Custom Hours Checkbox
-- Date: 2025-10-02
-- Description: Remove confusing contracted_hours_type field and replace with has_custom_hours boolean
--              Also add SUPERVISOR option to porter_type enum

USE rotascope;

-- Create backup of current data
CREATE TABLE porters_backup_20251002 AS SELECT * FROM porters;

-- Step 1: Add new has_custom_hours column
ALTER TABLE porters 
ADD COLUMN has_custom_hours BOOLEAN NOT NULL DEFAULT FALSE AFTER weekly_contracted_hours;

-- Step 2: Migrate existing data - set has_custom_hours to TRUE for porters with CUSTOM contract type
UPDATE porters 
SET has_custom_hours = TRUE 
WHERE contracted_hours_type = 'CUSTOM';

-- Step 3: Update porter_type enum to include SUPERVISOR
-- First, check current porter_type values and update any that need to be SUPERVISOR
UPDATE porters 
SET porter_type = 'SUPERVISOR' 
WHERE porter_type = 'PORTER' AND name IN (
    'Rob Mcpartland',  -- Known supervisor from seed data
    'John Smith'       -- Add other known supervisors here
);

-- Step 4: Modify the porter_type enum to include SUPERVISOR
ALTER TABLE porters 
MODIFY COLUMN porter_type ENUM('PORTER', 'SUPERVISOR', 'SENIOR_PORTER', 'REGULAR', 'RELIEF') NOT NULL DEFAULT 'PORTER';

-- Step 5: Update existing REGULAR/RELIEF values to new structure
-- Map REGULAR -> PORTER and RELIEF -> PORTER (they'll be distinguished by other fields)
UPDATE porters 
SET porter_type = 'PORTER' 
WHERE porter_type IN ('REGULAR', 'RELIEF');

-- Step 6: Clean up the enum to only have the three main types
ALTER TABLE porters 
MODIFY COLUMN porter_type ENUM('PORTER', 'SUPERVISOR', 'SENIOR_PORTER') NOT NULL DEFAULT 'PORTER';

-- Step 7: Drop the contracted_hours_type column (after backing up the data)
ALTER TABLE porters 
DROP COLUMN contracted_hours_type;

-- Step 8: Update indexes
DROP INDEX idx_porter_contract_type ON porters;
CREATE INDEX idx_porter_custom_hours ON porters(has_custom_hours);

-- Step 9: Add constraint for custom hours logic
-- Porters with custom hours should have custom_hours records
-- This will be enforced at application level

-- Verification queries (run these to check the migration)
-- SELECT porter_type, COUNT(*) FROM porters GROUP BY porter_type;
-- SELECT has_custom_hours, COUNT(*) FROM porters GROUP BY has_custom_hours;
-- SELECT p.name, p.porter_type, p.has_custom_hours, COUNT(pch.id) as custom_hours_count
-- FROM porters p 
-- LEFT JOIN porter_custom_hours pch ON p.id = pch.porter_id 
-- GROUP BY p.id, p.name, p.porter_type, p.has_custom_hours;
