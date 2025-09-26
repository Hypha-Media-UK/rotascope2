-- Porter Tracking System - Seed Data
-- Version: 2.0
-- Created: 2025-09-26

USE rotascope;

-- ============================================================================
-- SYSTEM CONFIGURATION
-- ============================================================================

INSERT INTO system_config (config_key, config_value, config_type, description, is_system) VALUES
('app.name', 'Porter Tracking System', 'STRING', 'Application name', TRUE),
('app.version', '2.0.0', 'STRING', 'Application version', TRUE),
('shifts.day_start', '08:00:00', 'STRING', 'Day shift start time', FALSE),
('shifts.day_end', '20:00:00', 'STRING', 'Day shift end time', FALSE),
('shifts.night_start', '20:00:00', 'STRING', 'Night shift start time', FALSE),
('shifts.night_end', '08:00:00', 'STRING', 'Night shift end time', FALSE),
('leave.max_days_per_request', '28', 'INTEGER', 'Maximum days per leave request', FALSE),
('leave.advance_notice_days', '14', 'INTEGER', 'Minimum advance notice for leave requests', FALSE),
('sickness.self_cert_max_days', '7', 'INTEGER', 'Maximum self-certified sickness days', FALSE),
('staffing.min_porters_per_department', '1', 'INTEGER', 'Minimum porters required per department', FALSE);

-- ============================================================================
-- DEPARTMENTS
-- ============================================================================

INSERT INTO departments (name, code, is_24_7, porters_required_day, porters_required_night, is_active) VALUES
('Emergency Department (A&E)', 'ED', TRUE, 2, 2, TRUE),
('Acute Medical Unit', 'AMU', TRUE, 1, 1, TRUE),
('CT Scan', 'CT', FALSE, 1, 1, TRUE),
('X-ray (Ground Floor)', 'XR-GF', FALSE, 1, 1, TRUE),
('X-ray (Lower Ground Floor)', 'XR-LGF', FALSE, 1, 1, TRUE),
('MRI', 'MRI', FALSE, 1, 1, TRUE),
('Patient Transport Service', 'PTS', FALSE, 2, 1, TRUE),
('Pharmacy', 'PHARM', FALSE, 1, 1, TRUE);

-- ============================================================================
-- SERVICES
-- ============================================================================

INSERT INTO services (name, code, is_24_7, porters_required_day, porters_required_night, is_active) VALUES
('Post', 'POST', FALSE, 1, 1, TRUE),
('Medical Records', 'MR', FALSE, 1, 1, TRUE),
('Sharps Collection', 'SHARPS', FALSE, 1, 1, TRUE),
('Blood Drivers', 'BLOOD', FALSE, 1, 1, TRUE),
('Laundry', 'LAUND', FALSE, 1, 1, TRUE),
('District Drivers', 'DIST', FALSE, 1, 1, TRUE),
('Ad-Hoc Services', 'ADHOC', FALSE, 1, 1, TRUE),
('External Waste', 'WASTE', FALSE, 1, 1, TRUE),
('Helpdesk', 'HELP', FALSE, 1, 1, TRUE);

-- ============================================================================
-- DEPARTMENT HOURS (1=Monday, 7=Sunday)
-- ============================================================================

-- CT Scan (Monday-Friday 8:00-18:00, Saturday 8:00-16:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(3, 1, '08:00:00', '18:00:00', 1), -- Monday
(3, 2, '08:00:00', '18:00:00', 1), -- Tuesday
(3, 3, '08:00:00', '18:00:00', 1), -- Wednesday
(3, 4, '08:00:00', '18:00:00', 1), -- Thursday
(3, 5, '08:00:00', '18:00:00', 1), -- Friday
(3, 6, '08:00:00', '16:00:00', 1); -- Saturday

-- X-ray Ground Floor (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(4, 1, '08:00:00', '17:00:00', 1), -- Monday
(4, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(4, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(4, 4, '08:00:00', '17:00:00', 1), -- Thursday
(4, 5, '08:00:00', '17:00:00', 1); -- Friday

-- X-ray Lower Ground Floor (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(5, 1, '08:00:00', '17:00:00', 1), -- Monday
(5, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(5, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(5, 4, '08:00:00', '17:00:00', 1), -- Thursday
(5, 5, '08:00:00', '17:00:00', 1); -- Friday

-- MRI (Monday-Friday 8:00-20:00, Saturday 8:00-16:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(6, 1, '08:00:00', '20:00:00', 1), -- Monday
(6, 2, '08:00:00', '20:00:00', 1), -- Tuesday
(6, 3, '08:00:00', '20:00:00', 1), -- Wednesday
(6, 4, '08:00:00', '20:00:00', 1), -- Thursday
(6, 5, '08:00:00', '20:00:00', 1), -- Friday
(6, 6, '08:00:00', '16:00:00', 1); -- Saturday

-- PTS (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(7, 1, '08:00:00', '17:00:00', 2), -- Monday
(7, 2, '08:00:00', '17:00:00', 2), -- Tuesday
(7, 3, '08:00:00', '17:00:00', 2), -- Wednesday
(7, 4, '08:00:00', '17:00:00', 2), -- Thursday
(7, 5, '08:00:00', '17:00:00', 2); -- Friday

-- Pharmacy (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(8, 1, '08:00:00', '17:00:00', 1), -- Monday
(8, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(8, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(8, 4, '08:00:00', '17:00:00', 1), -- Thursday
(8, 5, '08:00:00', '17:00:00', 1); -- Friday

-- ============================================================================
-- SERVICE HOURS (1=Monday, 7=Sunday)
-- ============================================================================

-- Most services operate Monday-Friday 8:00-17:00
INSERT INTO service_hours (service_id, day_of_week, opens_at, closes_at, porters_required) VALUES
-- Post
(1, 1, '08:00:00', '17:00:00', 1), (1, 2, '08:00:00', '17:00:00', 1), (1, 3, '08:00:00', '17:00:00', 1), (1, 4, '08:00:00', '17:00:00', 1), (1, 5, '08:00:00', '17:00:00', 1),
-- Medical Records
(2, 1, '08:00:00', '17:00:00', 1), (2, 2, '08:00:00', '17:00:00', 1), (2, 3, '08:00:00', '17:00:00', 1), (2, 4, '08:00:00', '17:00:00', 1), (2, 5, '08:00:00', '17:00:00', 1),
-- Blood Drivers
(4, 1, '08:00:00', '17:00:00', 1), (4, 2, '08:00:00', '17:00:00', 1), (4, 3, '08:00:00', '17:00:00', 1), (4, 4, '08:00:00', '17:00:00', 1), (4, 5, '08:00:00', '17:00:00', 1),
-- Laundry
(5, 1, '08:00:00', '17:00:00', 1), (5, 2, '08:00:00', '17:00:00', 1), (5, 3, '08:00:00', '17:00:00', 1), (5, 4, '08:00:00', '17:00:00', 1), (5, 5, '08:00:00', '17:00:00', 1),
-- District Drivers
(6, 1, '08:00:00', '17:00:00', 1), (6, 2, '08:00:00', '17:00:00', 1), (6, 3, '08:00:00', '17:00:00', 1), (6, 4, '08:00:00', '17:00:00', 1), (6, 5, '08:00:00', '17:00:00', 1),
-- Ad-Hoc
(7, 1, '08:00:00', '17:00:00', 1), (7, 2, '08:00:00', '17:00:00', 1), (7, 3, '08:00:00', '17:00:00', 1), (7, 4, '08:00:00', '17:00:00', 1), (7, 5, '08:00:00', '17:00:00', 1),
-- External Waste
(8, 1, '08:00:00', '17:00:00', 1), (8, 2, '08:00:00', '17:00:00', 1), (8, 3, '08:00:00', '17:00:00', 1), (8, 4, '08:00:00', '17:00:00', 1), (8, 5, '08:00:00', '17:00:00', 1),
-- Helpdesk
(9, 1, '08:00:00', '17:00:00', 1), (9, 2, '08:00:00', '17:00:00', 1), (9, 3, '08:00:00', '17:00:00', 1), (9, 4, '08:00:00', '17:00:00', 1), (9, 5, '08:00:00', '17:00:00', 1);

-- Sharps Collection (Monday-Friday 9:00-16:00)
INSERT INTO service_hours (service_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(3, 1, '09:00:00', '16:00:00', 1), -- Monday
(3, 2, '09:00:00', '16:00:00', 1), -- Tuesday
(3, 3, '09:00:00', '16:00:00', 1), -- Wednesday
(3, 4, '09:00:00', '16:00:00', 1), -- Thursday
(3, 5, '09:00:00', '16:00:00', 1); -- Friday

-- ============================================================================
-- SHIFTS
-- ============================================================================

INSERT INTO shifts (name, shift_type, shift_identifier, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero_date, is_active) VALUES
('Day Shift A', 'DAY', 'A', '08:00:00', '20:00:00', 4, 4, 0, '2025-01-01', TRUE),
('Day Shift B', 'DAY', 'B', '08:00:00', '20:00:00', 4, 4, 4, '2025-01-01', TRUE),
('Night Shift A', 'NIGHT', 'A', '20:00:00', '08:00:00', 4, 4, 0, '2025-01-01', TRUE),
('Night Shift B', 'NIGHT', 'B', '20:00:00', '08:00:00', 4, 4, 4, '2025-01-01', TRUE);
