-- Staff Allocation Update Migration
-- This script updates porter assignments based on the provided staff data
-- Run Date: 2025-10-03

USE rotascope;

-- Start transaction
START TRANSACTION;

-- Create a temporary table to hold the staff data
CREATE TEMPORARY TABLE temp_staff_data (
    name VARCHAR(100),
    shift_name VARCHAR(100),
    employment_type VARCHAR(50),
    department_name VARCHAR(100),
    service_name VARCHAR(100)
);

-- Insert the staff data
INSERT INTO temp_staff_data (name, shift_name, employment_type, department_name, service_name) VALUES
('AJ', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Alan Clark', 'PTS 8-8', 'Regular', 'Patient Transport Service', ''),
('Alan Kelly', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('Allen Butler', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Andrew Gibson', 'Weekdays', 'Regular', '', 'Blood Drivers'),
('Andrew Hassall', 'PTS 1-1', 'Regular', 'Patient Transport Service', ''),
('Andrew Trudgeon', 'Day Shift 10-10', 'Regular', 'Floor Staff', ''),
('Andy Clayton', 'Weekdays', 'Regular', 'Floor Staff', ''),
('Brian Cassidy', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('Carla Barton', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Charlotte Rimmer', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Chris Huckaby', 'Weekdays', 'Regular', '', 'Ad-Hoc Services'),
('Chris Roach', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Chris Wardle', 'Weekdays', 'Regular', '', 'Medical Records'),
('Colin Bromley', 'PTS 8-8', 'Regular', 'Patient Transport Service', ''),
('Craig Butler', 'Day Shift B', 'Regular', '', ''),
('Darren Flowers', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('Darren Milhench', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Darren Mycroft', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('David Sykes', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('Dean Pickering', 'Weekdays', 'Regular', 'MRI', ''),
('Duane Kulikowski', 'Weekends', 'Regular', 'X-ray (Lower Ground Floor)', ''),
('Edward Collier', 'Weekdays', 'Regular', 'CT Scan', ''),
('Eloisa Andrew', 'Weekdays', 'Regular', '', 'Post'),
('Gary Booth', 'PTS 8-8', 'Regular', 'Patient Transport Service', ''),
('Gary Bromley', 'Weekdays', 'Regular', '', 'Post'),
('Gavin Marsden', 'PTS 8-8', 'Regular', 'Patient Transport Service', ''),
('Ian Moss', 'PTS 1-1', 'Regular', 'Patient Transport Service', ''),
('Ian Speakes', 'Weekdays', 'Regular', '', 'District Drivers'),
('Jake Moran', 'Weekdays', 'Regular', 'Floor Staff', ''),
('James Bennett', 'Weekdays', 'Regular', 'Floor Staff', ''),
('James Mitchell', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('Jason Newton', 'Weekdays', 'Regular', '', 'Blood Drivers'),
('Jeff Robinson', 'Weekdays', 'Regular', 'Floor Staff', ''),
('Joe Redfearn', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('John Evans', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Jordon Fish', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Julie Greenough', 'Weekdays', 'Regular', 'CT Scan', ''),
('Karen Blackett', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('Kevin Gaskell', 'Day Shift 10-10', 'Regular', 'Floor Staff', ''),
('Kevin Tomlinson', 'Weekdays', 'Regular', 'Floor Staff', ''),
('Kyle Blackshaw', 'Weekdays', 'Relief', 'Floor Staff', ''),
('Kyle Sanderson', 'Weekdays', 'Regular', 'Floor Staff', ''),
('Lee Stafford', 'Weekdays', 'Regular', 'ED - Emergency Department', ''),
('Lewis Yearsley', 'Night Shift B', 'Regular', 'Floor Staff', ''),
('Lucy Redfearn', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Lynne Warner', 'PTS 12-8', 'Regular', 'Patient Transport Service', ''),
('Mark Dickinson', 'Weekdays', 'Regular', '', 'District Drivers'),
('Mark Haughton', 'Weekdays', 'Regular', '', 'External Waste'),
('Mark Lloyd', 'Weekdays', 'Regular', 'X-ray (Ground Floor)', ''),
('Mark Walton', 'Weekdays', 'Regular', 'Floor Staff', ''),
('Martin Hobson', 'Night Shift B', 'Regular', 'Floor Staff', ''),
('Martin Kenyon', 'Night Shift B', 'Regular', 'Floor Staff', ''),
('Matthew Bennett', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Matthew Cope', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Matthew Rushton', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Merv Permalloo', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Michael Shaw', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Mike Brennan', 'Weekdays', 'Regular', 'Floor Staff', ''),
('Nicola Benger', 'Weekdays', 'Regular', 'ED - Emergency Department', ''),
('Nigel Beesley', 'Weekdays', 'Regular', '', 'Blood Drivers'),
('Paul Berry', 'Weekdays', 'Regular', '', 'Blood Drivers'),
('Paul Fisher', 'PTS 8-8', 'Regular', 'Patient Transport Service', ''),
('Paul Flowers', 'Weekdays', 'Regular', '', 'Laundry'),
('Peter Moss', 'Weekdays', 'Regular', '', 'Medical Records'),
('Phil Hollinshead', 'Weekdays', 'Regular', 'X-ray (Lower Ground Floor)', ''),
('Regan Stringer', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Rob Mcpartland', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Robert Frost', 'Weekdays', 'Regular', '', 'Blood Drivers'),
('Roy Harris', 'PTS 12-8', 'Regular', 'Patient Transport Service', ''),
('Scott Cartledge', 'Night Shift B', 'Regular', 'Floor Staff', ''),
('Simon Collins', 'Weekdays', 'Regular', 'Floor Staff', ''),
('Soloman Offei', '', 'Relief', 'Floor Staff', ''),
('Stepen Bowater', 'PTS 1-1', 'Regular', 'Patient Transport Service', ''),
('Stephen Burke', 'Weekdays', 'Regular', 'X-ray (Ground Floor)', ''),
('Stephen Cooper', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Stephen Kirk', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('Stephen Scarsbrook', 'Day Shift B', 'Regular', 'Floor Staff', ''),
('Steven Richardson', 'Day Shift A', 'Regular', 'Floor Staff', ''),
('Stuart Ford', 'Weekdays', 'Regular', 'ED - Emergency Department', ''),
('Stuart Lomas', 'Weekdays', 'Regular', 'Pharmacy', ''),
('Tomas Konkol', 'Night Shift A', 'Regular', 'Floor Staff', ''),
('Tony Batters', 'Night Shift B', 'Regular', 'Floor Staff', '');

-- Create missing departments if they don't exist
INSERT IGNORE INTO departments (name, code, is_24_7, porters_required_day, porters_required_night, is_active)
VALUES
('Floor Staff', 'FLOORSTAFF', TRUE, 8, 4, TRUE);

-- Note: Other departments already exist in the database

-- All required services already exist in the database

-- Update porter assignments based on the staff data
-- First, let's update existing porters with their shift and department/service assignments

UPDATE porters p
JOIN temp_staff_data tsd ON p.name = tsd.name
LEFT JOIN shifts s ON s.name = tsd.shift_name
LEFT JOIN departments d ON d.name = CASE
    WHEN tsd.department_name = 'Floor Staff' THEN 'Floor Staff'
    WHEN tsd.department_name = 'Patient Transport Service' THEN 'Patient Transport Service'
    WHEN tsd.department_name = 'ED - Emergency Department' THEN 'ED - Emergency Department (A&E)'
    WHEN tsd.department_name = 'CT Scan' THEN 'CT Scan'
    WHEN tsd.department_name = 'X-ray (Ground Floor)' THEN 'X-ray (Ground Floor)'
    WHEN tsd.department_name = 'X-ray (Lower Ground Floor)' THEN 'X-ray (Lower Ground Floor)'
    WHEN tsd.department_name = 'Pharmacy' THEN 'Pharmacy'
    ELSE tsd.department_name
END
LEFT JOIN services sv ON sv.name = tsd.service_name
SET
    p.shift_id = s.id,
    p.regular_department_id = CASE WHEN tsd.department_name != '' AND tsd.department_name IS NOT NULL THEN d.id ELSE NULL END,
    p.regular_service_id = CASE WHEN tsd.service_name != '' AND tsd.service_name IS NOT NULL THEN sv.id ELSE NULL END,
    p.porter_type = CASE
        WHEN tsd.employment_type = 'Relief' THEN 'PORTER'
        WHEN p.name = 'Rob Mcpartland' THEN 'SUPERVISOR'
        WHEN p.name IN ('Lee Stafford', 'Nicola Benger') THEN 'SENIOR_PORTER'
        ELSE 'PORTER'
    END,
    p.updated_at = NOW()
WHERE tsd.name IS NOT NULL;

-- Insert any new porters that don't exist in the database
INSERT INTO porters (name, porter_type, shift_id, regular_department_id, regular_service_id, is_active, created_at, updated_at)
SELECT DISTINCT
    tsd.name,
    CASE
        WHEN tsd.employment_type = 'Relief' THEN 'PORTER'
        WHEN tsd.name = 'Rob Mcpartland' THEN 'SUPERVISOR'
        WHEN tsd.name IN ('Lee Stafford', 'Nicola Benger') THEN 'SENIOR_PORTER'
        ELSE 'PORTER'
    END as porter_type,
    s.id as shift_id,
    CASE WHEN tsd.department_name != '' THEN d.id ELSE NULL END as regular_department_id,
    CASE WHEN tsd.service_name != '' THEN sv.id ELSE NULL END as regular_service_id,
    TRUE as is_active,
    NOW() as created_at,
    NOW() as updated_at
FROM temp_staff_data tsd
LEFT JOIN shifts s ON s.name = tsd.shift_name
LEFT JOIN departments d ON d.name = CASE
    WHEN tsd.department_name = 'Floor Staff' THEN 'Floor Staff'
    WHEN tsd.department_name = 'Patient Transport Service' THEN 'Patient Transport Service'
    WHEN tsd.department_name = 'ED - Emergency Department' THEN 'ED - Emergency Department (A&E)'
    WHEN tsd.department_name = 'CT Scan' THEN 'CT Scan'
    WHEN tsd.department_name = 'X-ray (Ground Floor)' THEN 'X-ray (Ground Floor)'
    WHEN tsd.department_name = 'X-ray (Lower Ground Floor)' THEN 'X-ray (Lower Ground Floor)'
    WHEN tsd.department_name = 'Pharmacy' THEN 'Pharmacy'
    ELSE tsd.department_name
END
LEFT JOIN services sv ON sv.name = tsd.service_name
LEFT JOIN porters p ON p.name = tsd.name
WHERE p.id IS NULL;

-- Clean up temporary table
DROP TEMPORARY TABLE temp_staff_data;

-- Display summary of changes
SELECT 'Staff allocation update completed' as status;

SELECT
    COUNT(*) as total_porters,
    SUM(CASE WHEN shift_id IS NOT NULL THEN 1 ELSE 0 END) as porters_with_shifts,
    SUM(CASE WHEN regular_department_id IS NOT NULL THEN 1 ELSE 0 END) as porters_with_departments,
    SUM(CASE WHEN regular_service_id IS NOT NULL THEN 1 ELSE 0 END) as porters_with_services
FROM porters
WHERE is_active = 1;

COMMIT;
