-- Migration: Implement Shift Types System
-- Date: 2025-09-27
-- Description: Replace shift_type and shift_identifier with flexible shift_types table

USE rotascope;

-- ============================================================================
-- STEP 1: CREATE SHIFT_TYPES TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS shift_types (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    starts_at TIME NOT NULL,
    ends_at TIME NOT NULL,
    display_type ENUM('DAY', 'NIGHT') NOT NULL DEFAULT 'DAY',
    color VARCHAR(7) NULL, -- Hex color code #FF5733
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_shift_type_name_length CHECK (CHAR_LENGTH(name) >= 3),
    CONSTRAINT chk_shift_type_times CHECK (starts_at != ends_at),
    CONSTRAINT chk_shift_type_color CHECK (color IS NULL OR color REGEXP '^#[0-9A-Fa-f]{6}$'),
    
    -- Indexes
    UNIQUE KEY uk_shift_type_name (name),
    INDEX idx_shift_type_display (display_type),
    INDEX idx_shift_type_active (is_active)
);

-- ============================================================================
-- STEP 2: POPULATE SHIFT_TYPES FROM EXISTING DATA
-- ============================================================================

INSERT INTO shift_types (name, starts_at, ends_at, display_type, color) VALUES
('Day Shift A', '08:00:00', '20:00:00', 'DAY', '#4CAF50'),
('Day Shift B', '08:00:00', '20:00:00', 'DAY', '#8BC34A'),
('Night Shift A', '20:00:00', '08:00:00', 'NIGHT', '#3F51B5'),
('Night Shift B', '20:00:00', '08:00:00', 'NIGHT', '#673AB7');

-- ============================================================================
-- STEP 3: ADD SHIFT_TYPE_ID COLUMN TO SHIFTS TABLE
-- ============================================================================

-- Add the new column
ALTER TABLE shifts 
ADD COLUMN shift_type_id INT UNSIGNED NULL AFTER name;

-- ============================================================================
-- STEP 4: POPULATE SHIFT_TYPE_ID BASED ON EXISTING DATA
-- ============================================================================

-- Update existing shifts to reference the new shift types
UPDATE shifts s 
JOIN shift_types st ON s.name = st.name 
SET s.shift_type_id = st.id;

-- ============================================================================
-- STEP 5: REMOVE OLD COLUMNS AND CONSTRAINTS
-- ============================================================================

-- Drop old constraints first
ALTER TABLE shifts DROP CONSTRAINT chk_shift_identifier;
ALTER TABLE shifts DROP CONSTRAINT uk_shift_type_identifier;

-- Drop old indexes
ALTER TABLE shifts DROP INDEX idx_shift_type;

-- Drop old columns
ALTER TABLE shifts DROP COLUMN shift_type;
ALTER TABLE shifts DROP COLUMN shift_identifier;

-- ============================================================================
-- STEP 6: ADD NEW FOREIGN KEY CONSTRAINT AND INDEX
-- ============================================================================

-- Add foreign key constraint
ALTER TABLE shifts 
ADD CONSTRAINT fk_shift_type FOREIGN KEY (shift_type_id) REFERENCES shift_types(id) ON DELETE SET NULL;

-- Add index for performance
ALTER TABLE shifts 
ADD INDEX idx_shift_type_id (shift_type_id);

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify shift types were created
SELECT 'Shift Types Created:' as status;
SELECT id, name, display_type, color FROM shift_types ORDER BY id;

-- Verify shifts were updated
SELECT 'Shifts Updated:' as status;
SELECT s.id, s.name, s.shift_type_id, st.name as shift_type_name, st.display_type 
FROM shifts s 
LEFT JOIN shift_types st ON s.shift_type_id = st.id 
ORDER BY s.id;

-- Verify foreign key constraint
SELECT 'Foreign Key Constraint:' as status;
SELECT 
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'rotascope' 
AND TABLE_NAME = 'shifts' 
AND CONSTRAINT_NAME = 'fk_shift_type';
