-- Migration: Remove hire_date from porters table
-- Date: 2025-09-27
-- Description: Remove hire_date field as it's not needed for the application

-- Remove hire_date column from porters table
ALTER TABLE porters DROP COLUMN hire_date;
