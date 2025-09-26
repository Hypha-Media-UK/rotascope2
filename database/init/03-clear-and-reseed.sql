-- Clear existing data and reseed with real hospital data
-- Created: 2025-09-26

USE rotascope;

-- Clear existing data (in correct order due to foreign key constraints)
DELETE FROM porter_assignments;
DELETE FROM porter_absences;
DELETE FROM porter_sickness;
DELETE FROM porter_annual_leave;
DELETE FROM porter_hours;
DELETE FROM porters;
DELETE FROM department_hours;
DELETE FROM departments;
DELETE FROM shifts;

-- Reset auto increment counters
ALTER TABLE departments AUTO_INCREMENT = 1;
ALTER TABLE porters AUTO_INCREMENT = 1;
ALTER TABLE shifts AUTO_INCREMENT = 1;
ALTER TABLE porter_assignments AUTO_INCREMENT = 1;

-- Insert real departments
INSERT INTO departments (name, is_24_7, porters_required) VALUES
('ED (A+E)', TRUE, 2),
('AMU', TRUE, 1),
('CT Scan', FALSE, 1),
('Xray (Ground Floor)', FALSE, 1),
('Xray (Lower Ground Floor)', FALSE, 1),
('MRI', FALSE, 1),
('PTS (Patient Transport)', FALSE, 2),
('Pharmacy', FALSE, 1);

-- Insert services (using same table structure but we'll distinguish them in the UI)
INSERT INTO departments (name, is_24_7, porters_required) VALUES
('Post', FALSE, 1),
('Medical Records', FALSE, 1),
('Sharps', FALSE, 1),
('Blood Drivers', FALSE, 1),
('Laundry', FALSE, 1),
('District Drivers', FALSE, 1),
('Ad-Hoc', FALSE, 1),
('External Waste', FALSE, 1),
('Helpdesk', FALSE, 1);

-- Set operating hours for non-24/7 departments
-- CT Scan (Monday-Friday 8:00-18:00, Saturday 8:00-16:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(3, 1, '08:00:00', '18:00:00', 1), -- Monday
(3, 2, '08:00:00', '18:00:00', 1), -- Tuesday
(3, 3, '08:00:00', '18:00:00', 1), -- Wednesday
(3, 4, '08:00:00', '18:00:00', 1), -- Thursday
(3, 5, '08:00:00', '18:00:00', 1), -- Friday
(3, 6, '08:00:00', '16:00:00', 1); -- Saturday

-- Xray Ground Floor (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(4, 1, '08:00:00', '17:00:00', 1), -- Monday
(4, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(4, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(4, 4, '08:00:00', '17:00:00', 1), -- Thursday
(4, 5, '08:00:00', '17:00:00', 1); -- Friday

-- Xray Lower Ground Floor (Monday-Friday 8:00-17:00)
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

-- Services operating hours (most services Monday-Friday 8:00-17:00)
-- Post
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(9, 1, '08:00:00', '17:00:00', 1), -- Monday
(9, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(9, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(9, 4, '08:00:00', '17:00:00', 1), -- Thursday
(9, 5, '08:00:00', '17:00:00', 1); -- Friday

-- Medical Records
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(10, 1, '08:00:00', '17:00:00', 1), -- Monday
(10, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(10, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(10, 4, '08:00:00', '17:00:00', 1), -- Thursday
(10, 5, '08:00:00', '17:00:00', 1); -- Friday

-- Sharps (Monday-Friday 9:00-16:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(11, 1, '09:00:00', '16:00:00', 1), -- Monday
(11, 2, '09:00:00', '16:00:00', 1), -- Tuesday
(11, 3, '09:00:00', '16:00:00', 1), -- Wednesday
(11, 4, '09:00:00', '16:00:00', 1), -- Thursday
(11, 5, '09:00:00', '16:00:00', 1); -- Friday

-- Blood Drivers (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(12, 1, '08:00:00', '17:00:00', 1), -- Monday
(12, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(12, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(12, 4, '08:00:00', '17:00:00', 1), -- Thursday
(12, 5, '08:00:00', '17:00:00', 1); -- Friday

-- Laundry (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(13, 1, '08:00:00', '17:00:00', 1), -- Monday
(13, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(13, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(13, 4, '08:00:00', '17:00:00', 1), -- Thursday
(13, 5, '08:00:00', '17:00:00', 1); -- Friday

-- District Drivers (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(14, 1, '08:00:00', '17:00:00', 1), -- Monday
(14, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(14, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(14, 4, '08:00:00', '17:00:00', 1), -- Thursday
(14, 5, '08:00:00', '17:00:00', 1); -- Friday

-- Ad-Hoc (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(15, 1, '08:00:00', '17:00:00', 1), -- Monday
(15, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(15, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(15, 4, '08:00:00', '17:00:00', 1), -- Thursday
(15, 5, '08:00:00', '17:00:00', 1); -- Friday

-- External Waste (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(16, 1, '08:00:00', '17:00:00', 1), -- Monday
(16, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(16, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(16, 4, '08:00:00', '17:00:00', 1), -- Thursday
(16, 5, '08:00:00', '17:00:00', 1); -- Friday

-- Helpdesk (Monday-Friday 8:00-17:00)
INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES
(17, 1, '08:00:00', '17:00:00', 1), -- Monday
(17, 2, '08:00:00', '17:00:00', 1), -- Tuesday
(17, 3, '08:00:00', '17:00:00', 1), -- Wednesday
(17, 4, '08:00:00', '17:00:00', 1), -- Thursday
(17, 5, '08:00:00', '17:00:00', 1); -- Friday

-- Insert sample shifts (keeping the existing shift structure)
INSERT INTO shifts (name, shift_type, shift_ident, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero) VALUES
('Day Shift A', 'DAY', 'A', '08:00:00', '20:00:00', 4, 4, 0, '2025-01-01'),
('Day Shift B', 'DAY', 'B', '08:00:00', '20:00:00', 4, 4, 4, '2025-01-01'),
('Night Shift A', 'NIGHT', 'A', '20:00:00', '08:00:00', 4, 4, 0, '2025-01-01'),
('Night Shift B', 'NIGHT', 'B', '20:00:00', '08:00:00', 4, 4, 4, '2025-01-01');

-- Insert real porters (setting most as relief porters initially for flexibility)
INSERT INTO porters (name, porter_type, contracted_hours_type, shift_id, regular_department_id, is_floor_staff, weekly_hours) VALUES
('Rob Mcpartland', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('John Evans', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Charlotte Rimmer', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Carla Barton', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Andrew Trudgeon', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Stephen Bowater', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Matthew Bennett', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Stephen Scarsbrook', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Jordon Fish', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Steven Richardson', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Chris Roach', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Simon Collins', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Mark Walton', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Allen Butler', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Darren Flowers', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Brian Cassidy', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Karen Blackett', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('James Mitchell', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Alan Kelly', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Tomas Konkol', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Kyle Blackshaw', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('David Sykes', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Stuart Ford', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Lee Stafford', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Nicola Benger', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Jeff Robinson', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Dean Pickering', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Colin Bromley', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Gary Booth', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Ian Moss', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Paul Fisher', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Stephen Kirk', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Ian Speakes', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Stuart Lomas', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Stephen Cooper', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Darren Milhench', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Darren Mycroft', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Kevin Gaskell', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Merv Permalloo', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Regan Stringer', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Matthew Cope', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('AJ', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Michael Shaw', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('James Bennett', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Martin Hobson', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Martin Kenyon', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Scott Cartledge', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Tony Batters', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Lewis Yearsley', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Mark Lloyd', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Stephen Burke', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Julie Greenough', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Edward Collier', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Phil Hollinshead', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Kevin Tomlinson', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Soloman Offei', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Lynne Warner', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Roy Harris', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Kyle Sanderson', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Peter Moss', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Chris Wardle', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Eloisa Andrew', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Gary Bromley', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Mike Brennan', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Lucy Redfearn', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Mark Dickinson', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Paul Berry', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Robert Frost', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Andrew Gibson', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Nigel Beesley', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Andy Clayton', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Matthew Rushton', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Mark Haughton', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Graham Brown', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Chris Huckaby', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Jason Newton', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Joe Redfearn', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Paul Flowers', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Jake Moran', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Gavin Marsden', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Andrew Hassall', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Alan Clark', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Duane Kulikowski', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5),
('Craig Butler', 'PORTER', 'RELIEF', NULL, NULL, TRUE, 37.5);
