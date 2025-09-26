-- Porter Tracking System - Porter Data
-- Version: 2.0
-- Created: 2025-09-26

USE rotascope;

-- ============================================================================
-- PORTER DATA
-- ============================================================================

INSERT INTO porters (employee_id, name, email, porter_type, contracted_hours_type, weekly_contracted_hours, shift_id, regular_department_id, is_floor_staff, hire_date, is_active) VALUES
-- Shift-based porters
('EMP001', 'Rob Mcpartland', 'rob.mcpartland@hospital.nhs.uk', 'SUPERVISOR', 'SHIFT', 37.50, 1, 1, TRUE, '2020-01-15', TRUE),
('EMP002', 'John Evans', 'john.evans@hospital.nhs.uk', 'PORTER', 'SHIFT', 37.50, 1, 1, FALSE, '2019-03-20', TRUE),
('EMP003', 'Charlotte Rimmer', 'charlotte.rimmer@hospital.nhs.uk', 'PORTER', 'SHIFT', 37.50, 2, 2, FALSE, '2021-06-10', TRUE),
('EMP004', 'Carla Barton', 'carla.barton@hospital.nhs.uk', 'PORTER', 'SHIFT', 37.50, 2, 3, FALSE, '2020-09-05', TRUE),
('EMP005', 'Andrew Trudgeon', 'andrew.trudgeon@hospital.nhs.uk', 'PORTER', 'SHIFT', 37.50, 3, 1, FALSE, '2018-11-12', TRUE),
('EMP006', 'Stephen Bowater', 'stephen.bowater@hospital.nhs.uk', 'PORTER', 'SHIFT', 37.50, 3, 2, FALSE, '2019-07-08', TRUE),
('EMP007', 'Matthew Bennett', 'matthew.bennett@hospital.nhs.uk', 'PORTER', 'SHIFT', 37.50, 4, 1, FALSE, '2020-02-14', TRUE),
('EMP008', 'Stephen Scarsbrook', 'stephen.scarsbrook@hospital.nhs.uk', 'PORTER', 'SHIFT', 37.50, 4, 3, FALSE, '2021-01-20', TRUE),

-- Relief porters (no fixed shift or department)
('EMP009', 'Jordon Fish', 'jordon.fish@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-05-15', TRUE),
('EMP010', 'Steven Richardson', 'steven.richardson@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-08-22', TRUE),
('EMP011', 'Chris Roach', 'chris.roach@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-12-03', TRUE),
('EMP012', 'Simon Collins', 'simon.collins@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-04-18', TRUE),
('EMP013', 'Mark Walton', 'mark.walton@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-10-07', TRUE),
('EMP014', 'Allen Butler', 'allen.butler@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-06-25', TRUE),
('EMP015', 'Darren Flowers', 'darren.flowers@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-09-14', TRUE),
('EMP016', 'Brian Cassidy', 'brian.cassidy@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-02-28', TRUE),
('EMP017', 'Karen Blackett', 'karen.blackett@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-11-30', TRUE),
('EMP018', 'James Mitchell', 'james.mitchell@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-03-16', TRUE),
('EMP019', 'Alan Kelly', 'alan.kelly@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-07-09', TRUE),
('EMP020', 'Tomas Konkol', 'tomas.konkol@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-05-12', TRUE),

-- Part-time porters with custom hours
('EMP021', 'Kyle Blackshaw', 'kyle.blackshaw@hospital.nhs.uk', 'PORTER', 'PART_TIME', 20.00, NULL, 4, FALSE, '2020-10-05', TRUE),
('EMP022', 'David Sykes', 'david.sykes@hospital.nhs.uk', 'PORTER', 'PART_TIME', 25.00, NULL, 5, FALSE, '2019-08-18', TRUE),
('EMP023', 'Stuart Ford', 'stuart.ford@hospital.nhs.uk', 'PORTER', 'PART_TIME', 30.00, NULL, 6, FALSE, '2021-03-22', TRUE),

-- Senior porters
('EMP024', 'Lee Stafford', 'lee.stafford@hospital.nhs.uk', 'SENIOR_PORTER', 'SHIFT', 37.50, 1, 7, FALSE, '2017-05-10', TRUE),
('EMP025', 'Nicola Benger', 'nicola.benger@hospital.nhs.uk', 'SENIOR_PORTER', 'SHIFT', 37.50, 2, 8, FALSE, '2018-01-25', TRUE),

-- Additional regular porters
('EMP026', 'Jeff Robinson', 'jeff.robinson@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-07-14', TRUE),
('EMP027', 'Dean Pickering', 'dean.pickering@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-12-08', TRUE),
('EMP028', 'Colin Bromley', 'colin.bromley@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-06-30', TRUE),
('EMP029', 'Gary Booth', 'gary.booth@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-04-12', TRUE),
('EMP030', 'Ian Moss', 'ian.moss@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-11-18', TRUE),
('EMP031', 'Paul Fisher', 'paul.fisher@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-02-26', TRUE),
('EMP032', 'Stephen Kirk', 'stephen.kirk@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-08-15', TRUE),
('EMP033', 'Ian Speakes', 'ian.speakes@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-10-03', TRUE),
('EMP034', 'Stuart Lomas', 'stuart.lomas@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-05-20', TRUE),
('EMP035', 'Stephen Cooper', 'stephen.cooper@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-09-11', TRUE),
('EMP036', 'Darren Milhench', 'darren.milhench@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-01-07', TRUE),
('EMP037', 'Darren Mycroft', 'darren.mycroft@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-06-28', TRUE),
('EMP038', 'Kevin Gaskell', 'kevin.gaskell@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-12-14', TRUE),
('EMP039', 'Merv Permalloo', 'merv.permalloo@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-04-05', TRUE),
('EMP040', 'Regan Stringer', 'regan.stringer@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-07-19', TRUE),
('EMP041', 'Matthew Cope', 'matthew.cope@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-11-22', TRUE),
('EMP042', 'AJ', 'aj@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-08-09', TRUE),
('EMP043', 'Michael Shaw', 'michael.shaw@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-03-17', TRUE),
('EMP044', 'James Bennett', 'james.bennett@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-05-25', TRUE),
('EMP045', 'Martin Hobson', 'martin.hobson@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-12-11', TRUE),
('EMP046', 'Martin Kenyon', 'martin.kenyon@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-02-03', TRUE),
('EMP047', 'Scott Cartledge', 'scott.cartledge@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2019-07-28', TRUE),
('EMP048', 'Tony Batters', 'tony.batters@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2021-04-06', TRUE),
('EMP049', 'Lewis Yearsley', 'lewis.yearsley@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2018-09-19', TRUE),
('EMP050', 'Mark Lloyd', 'mark.lloyd@hospital.nhs.uk', 'PORTER', 'RELIEF', 37.50, NULL, NULL, TRUE, '2020-10-27', TRUE);

-- ============================================================================
-- CUSTOM HOURS FOR PART-TIME PORTERS
-- ============================================================================

-- Kyle Blackshaw - Monday, Wednesday, Friday mornings
INSERT INTO porter_custom_hours (porter_id, day_of_week, starts_at, ends_at) VALUES
(21, 1, '08:00:00', '12:00:00'), -- Monday
(21, 3, '08:00:00', '12:00:00'), -- Wednesday
(21, 5, '08:00:00', '12:00:00'); -- Friday

-- David Sykes - Tuesday, Thursday afternoons
INSERT INTO porter_custom_hours (porter_id, day_of_week, starts_at, ends_at) VALUES
(22, 2, '13:00:00', '18:00:00'), -- Tuesday
(22, 4, '13:00:00', '18:00:00'); -- Thursday

-- Stuart Ford - Monday to Wednesday
INSERT INTO porter_custom_hours (porter_id, day_of_week, starts_at, ends_at) VALUES
(23, 1, '09:00:00', '17:00:00'), -- Monday
(23, 2, '09:00:00', '17:00:00'), -- Tuesday
(23, 3, '09:00:00', '17:00:00'); -- Wednesday

-- ============================================================================
-- PERMANENT ASSIGNMENTS
-- ============================================================================

INSERT INTO porter_assignments (porter_id, department_id, assignment_type, start_date, priority, notes, is_active) VALUES
-- Shift-based porter assignments
(1, 1, 'PERMANENT', '2020-01-15', 1, 'Supervisor for ED day shift', TRUE),
(2, 1, 'PERMANENT', '2019-03-20', 2, 'ED day shift porter', TRUE),
(3, 2, 'PERMANENT', '2021-06-10', 2, 'AMU day shift porter', TRUE),
(4, 3, 'PERMANENT', '2020-09-05', 2, 'CT Scan day shift porter', TRUE),
(5, 1, 'PERMANENT', '2018-11-12', 2, 'ED night shift porter', TRUE),
(6, 2, 'PERMANENT', '2019-07-08', 2, 'AMU night shift porter', TRUE),
(7, 1, 'PERMANENT', '2020-02-14', 2, 'ED night shift porter', TRUE),
(8, 3, 'PERMANENT', '2021-01-20', 2, 'CT Scan night shift porter', TRUE),
(24, 7, 'PERMANENT', '2017-05-10', 1, 'Senior porter for PTS', TRUE),
(25, 8, 'PERMANENT', '2018-01-25', 1, 'Senior porter for Pharmacy', TRUE);

-- Part-time porter assignments
INSERT INTO porter_assignments (porter_id, department_id, assignment_type, start_date, priority, notes, is_active) VALUES
(21, 4, 'PERMANENT', '2020-10-05', 3, 'Part-time X-ray GF porter', TRUE),
(22, 5, 'PERMANENT', '2019-08-18', 3, 'Part-time X-ray LGF porter', TRUE),
(23, 6, 'PERMANENT', '2021-03-22', 3, 'Part-time MRI porter', TRUE);
