-- Sample data for Porter Tracking System
-- Created: 2025-09-26

USE rotascope;

-- Insert sample departments
INSERT INTO departments (name, is_24_7, porters_required) VALUES
('Emergency Department', TRUE, 3),
('Outpatients', FALSE, 2),
('Wards', TRUE, 4),
('Theatres', FALSE, 2),
('Radiology', FALSE, 1);

-- Insert department hours for non-24/7 departments
-- Outpatients (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(2, 1, '08:00:00', '17:00:00', 2), -- Monday
(2, 2, '08:00:00', '17:00:00', 2), -- Tuesday
(2, 3, '08:00:00', '17:00:00', 2), -- Wednesday
(2, 4, '08:00:00', '17:00:00', 2), -- Thursday
(2, 5, '08:00:00', '17:00:00', 2); -- Friday

-- Theatres (Monday-Friday 7:00-19:00, Saturday 8:00-16:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(4, 1, '07:00:00', '19:00:00', 2), -- Monday
(4, 2, '07:00:00', '19:00:00', 2), -- Tuesday
(4, 3, '07:00:00', '19:00:00', 2), -- Wednesday
(4, 4, '07:00:00', '19:00:00', 2), -- Thursday
(4, 5, '07:00:00', '19:00:00', 2), -- Friday
(4, 6, '08:00:00', '16:00:00', 1); -- Saturday

-- Radiology (Monday-Friday 9:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(5, 1, '09:00:00', '17:00:00', 1), -- Monday
(5, 2, '09:00:00', '17:00:00', 1), -- Tuesday
(5, 3, '09:00:00', '17:00:00', 1), -- Wednesday
(5, 4, '09:00:00', '17:00:00', 1), -- Thursday
(5, 5, '09:00:00', '17:00:00', 1); -- Friday

-- Insert sample shifts
INSERT INTO shifts (name, shift_type, shift_ident, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero) VALUES
('Day Shift A', 'DAY', 'A', '08:00:00', '20:00:00', 4, 4, 0, '2025-01-01'),
('Day Shift B', 'DAY', 'B', '08:00:00', '20:00:00', 4, 4, 4, '2025-01-01'),
('Night Shift A', 'NIGHT', 'A', '20:00:00', '08:00:00', 4, 4, 0, '2025-01-01'),
('Night Shift B', 'NIGHT', 'B', '20:00:00', '08:00:00', 4, 4, 4, '2025-01-01');

-- Insert sample porters
INSERT INTO porters (name, porter_type, contracted_hours_type, shift_id, regular_department_id, is_floor_staff) VALUES
('John Smith', 'PORTER', 'SHIFT', 1, 1, FALSE),      -- Day Shift A, Emergency
('Sarah Jones', 'PORTER', 'SHIFT', 1, 2, FALSE),     -- Day Shift A, Outpatients
('Mike Wilson', 'SUPERVISOR', 'SHIFT', 1, NULL, TRUE), -- Day Shift A, Floor Staff
('Emma Brown', 'PORTER', 'SHIFT', 2, 3, FALSE),      -- Day Shift B, Wards
('David Lee', 'PORTER', 'SHIFT', 3, 1, FALSE),       -- Night Shift A, Emergency
('Lisa Taylor', 'PORTER', 'SHIFT', 3, 3, FALSE),     -- Night Shift A, Wards
('Tom Anderson', 'PORTER', 'RELIEF', NULL, NULL, TRUE), -- Relief Porter
('Kate Miller', 'PORTER', 'CUSTOM', NULL, 4, FALSE); -- Custom hours, Theatres

-- Insert custom hours for Kate Miller (part-time, Monday-Wednesday 9:00-15:00)
INSERT INTO porter_hours (porter_id, day_of_week, starts_at, ends_at) VALUES
(8, 1, '09:00:00', '15:00:00'), -- Monday
(8, 2, '09:00:00', '15:00:00'), -- Tuesday
(8, 3, '09:00:00', '15:00:00'); -- Wednesday

-- Insert some sample annual leave
INSERT INTO porter_annual_leave (porter_id, start_date, end_date, notes) VALUES
(1, '2025-10-15', '2025-10-22', 'Family holiday'),
(4, '2025-11-01', '2025-11-08', 'Annual leave');

-- Insert permanent assignments for regular department porters
INSERT INTO porter_assignments (porter_id, department_id, start_date, assignment_type) VALUES
(1, 1, '2025-01-01', 'PERMANENT'), -- John to Emergency
(2, 2, '2025-01-01', 'PERMANENT'), -- Sarah to Outpatients
(4, 3, '2025-01-01', 'PERMANENT'), -- Emma to Wards
(5, 1, '2025-01-01', 'PERMANENT'), -- David to Emergency
(6, 3, '2025-01-01', 'PERMANENT'), -- Lisa to Wards
(8, 4, '2025-01-01', 'PERMANENT'); -- Kate to Theatres

-- Insert a temporary relief assignment
INSERT INTO porter_assignments (porter_id, department_id, start_date, end_date, assignment_type, notes) VALUES
(7, 2, '2025-10-15', '2025-10-22', 'RELIEF', 'Covering for Sarah during annual leave');
