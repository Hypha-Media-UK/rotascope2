-- Create separate services table for future expansion
-- Created: 2025-09-26

USE rotascope;

-- Create services table (similar structure to departments but separate for future expansion)
CREATE TABLE services (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  is_24_7 BOOLEAN DEFAULT FALSE,
  porters_required INT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_services_name (name)
);

-- Create service_hours table (similar to department_hours)
CREATE TABLE service_hours (
  id INT PRIMARY KEY AUTO_INCREMENT,
  service_id INT NOT NULL,
  day_of_week INT NOT NULL, -- 0=Sunday, 1=Monday, etc.
  opens_at TIME NOT NULL,
  closes_at TIME NOT NULL,
  porters_required INT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
  INDEX idx_service_hours_service_day (service_id, day_of_week),
  UNIQUE KEY unique_service_day (service_id, day_of_week)
);

-- Move existing services from departments table to services table
INSERT INTO services (name, is_24_7, porters_required, created_at, updated_at)
SELECT name, is_24_7, porters_required, created_at, updated_at 
FROM departments 
WHERE department_type = 'SERVICE';

-- Move service hours from department_hours to service_hours
INSERT INTO service_hours (service_id, day_of_week, opens_at, closes_at, porters_required, created_at, updated_at)
SELECT 
  s.id as service_id,
  dh.day_of_week,
  dh.opens_at,
  dh.closes_at,
  dh.porters_required,
  dh.created_at,
  dh.updated_at
FROM departments d
JOIN services s ON d.name = s.name
JOIN department_hours dh ON d.id = dh.department_id
WHERE d.department_type = 'SERVICE';

-- Remove services from departments table
DELETE dh FROM department_hours dh
JOIN departments d ON dh.department_id = d.id
WHERE d.department_type = 'SERVICE';

DELETE FROM departments WHERE department_type = 'SERVICE';

-- Remove the department_type column since we now have separate tables
ALTER TABLE departments DROP COLUMN department_type;

-- Update porter_assignments table to handle both departments and services
-- Add service_id column (nullable, either department_id OR service_id should be set)
ALTER TABLE porter_assignments ADD COLUMN service_id INT NULL AFTER department_id;
ALTER TABLE porter_assignments ADD FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE;

-- Add constraint to ensure either department_id OR service_id is set, but not both
ALTER TABLE porter_assignments ADD CONSTRAINT chk_assignment_type 
CHECK ((department_id IS NOT NULL AND service_id IS NULL) OR (department_id IS NULL AND service_id IS NOT NULL));
