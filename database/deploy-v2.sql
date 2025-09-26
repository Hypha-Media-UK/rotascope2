-- Porter Tracking System - Database Deployment Script v2.0
-- This script will drop the existing database and recreate it with the new schema
-- 
-- WARNING: This will destroy all existing data!
-- Make sure you have a backup before running this script.

-- Drop existing database
DROP DATABASE IF EXISTS rotascope;

-- Source all schema files in order
SOURCE schema/01-core-schema.sql;
SOURCE schema/02-absence-management.sql;
SOURCE schema/03-seed-data.sql;
SOURCE schema/04-porter-data.sql;

-- Verify deployment
USE rotascope;

-- Show table counts
SELECT 'departments' as table_name, COUNT(*) as record_count FROM departments
UNION ALL
SELECT 'services' as table_name, COUNT(*) as record_count FROM services
UNION ALL
SELECT 'department_hours' as table_name, COUNT(*) as record_count FROM department_hours
UNION ALL
SELECT 'service_hours' as table_name, COUNT(*) as record_count FROM service_hours
UNION ALL
SELECT 'shifts' as table_name, COUNT(*) as record_count FROM shifts
UNION ALL
SELECT 'porters' as table_name, COUNT(*) as record_count FROM porters
UNION ALL
SELECT 'porter_custom_hours' as table_name, COUNT(*) as record_count FROM porter_custom_hours
UNION ALL
SELECT 'porter_assignments' as table_name, COUNT(*) as record_count FROM porter_assignments
UNION ALL
SELECT 'system_config' as table_name, COUNT(*) as record_count FROM system_config;

-- Show database info
SELECT 
    'Database deployment completed successfully' as status,
    NOW() as deployed_at,
    '2.0.0' as version;
