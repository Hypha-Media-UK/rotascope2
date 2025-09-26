-- Add support for Services vs Departments distinction
-- Created: 2025-09-26

USE rotascope;

-- Add a type field to distinguish between departments and services
ALTER TABLE departments ADD COLUMN department_type ENUM('DEPARTMENT', 'SERVICE') DEFAULT 'DEPARTMENT' AFTER name;

-- Update existing records to mark services
UPDATE departments SET department_type = 'SERVICE' WHERE name IN (
    'Post',
    'Medical Records', 
    'Sharps',
    'Blood Drivers',
    'Laundry',
    'District Drivers',
    'Ad-Hoc',
    'External Waste',
    'Helpdesk'
);
