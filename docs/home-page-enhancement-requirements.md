# Home Page Enhancement Requirements

## Overview
This document outlines the requirements for enhancing the Porter Tracking System home page with advanced shift management, 3-week navigation, and comprehensive porter assignment functionality.

## Key Requirements

### 1. Week Navigation Enhancement
- **Current**: Shows 6 days only
- **Required**: 3-week tab navigation showing:
  - w/c 29/09/25 (week commencing Monday)
  - w/c 06/10/25
  - w/c 13/10/25
- **Behavior**: At 07:59am on 06/10/25, advance to show w/c 20/10/25
- **Navigation**: Previous/Next buttons for viewing older/future shifts

### 2. Data Freezing System
- **Trigger**: Automatic at 07:59am on the day following each shift day
- **Purpose**: Capture night shift alterations
- **Implementation**: Scheduled background job
- **Scope**: Creates snapshot of allocations for that specific day only
- **Independence**: No impact on past/future dates or configure screen settings

### 3. Shift Cards Integration
- **Location**: Within existing Departments section (not separate)
- **Cards**: Day Shift and Night Shift cards alongside department cards
- **Content**: Show porters currently assigned to each shift
- **Porter Offsets**: Individual porters can have offsets relative to their assigned shift
- **Straddling**: Porters with offsets may appear across multiple shifts

### 4. Porter Assignment System
- **UI Location**: Enhanced Porter modal in Configure screen
- **Structure**: Separate tab within porter modal
- **Capabilities**:
  - Assign porter to shift AND department/service
  - Temporary assignments override shift assignments
  - From/to date fields for temporary assignments
  - Porter offset management

### 5. Assignment Priority Logic
- **Shift Assignment**: Base assignment (shows on shift cards)
- **Temporary Assignment**: Overrides shift for specific period
- **Display**: Porter shows on shift card (lighter) + assigned department/service
- **Duration**: Temporary assignments have start/end dates

### 6. Porter Type Simplification
- **Current**: PORTER, SUPERVISOR, SENIOR_PORTER
- **Required**: REGULAR, RELIEF only
- **Migration**: Update existing data appropriately

## Database Schema Changes

### Porter Table Additions
```sql
-- Add porter offset field
ALTER TABLE porters ADD COLUMN porter_offset TINYINT UNSIGNED DEFAULT 0 AFTER shift_id;

-- Add temporary assignment fields
ALTER TABLE porters ADD COLUMN temp_department_id INT UNSIGNED NULL AFTER regular_department_id;
ALTER TABLE porters ADD COLUMN temp_service_id INT UNSIGNED NULL AFTER temp_department_id;
ALTER TABLE porters ADD COLUMN temp_assignment_start DATE NULL AFTER temp_service_id;
ALTER TABLE porters ADD COLUMN temp_assignment_end DATE NULL AFTER temp_assignment_start;
```

### Assignment Type Updates
```sql
-- Simplify assignment types
ALTER TABLE porter_assignments MODIFY assignment_type ENUM('REGULAR', 'RELIEF') NOT NULL;

-- Update porter types
ALTER TABLE porters MODIFY porter_type ENUM('REGULAR', 'RELIEF') NOT NULL DEFAULT 'REGULAR';
```

## Shift Calculation Logic

### Core Algorithm
```typescript
function calculateActiveShift(date: Date, shift: Shift): boolean {
  const groundZero = new Date(shift.ground_zero_date);
  const daysDiff = Math.floor((date.getTime() - groundZero.getTime()) / (1000 * 60 * 60 * 24));
  const adjustedDays = daysDiff + shift.shift_offset;
  const cycleLength = shift.days_on + shift.days_off;
  const cyclePosition = adjustedDays % cycleLength;
  return cyclePosition >= 0 && cyclePosition < shift.days_on;
}
```

### Porter Offset Calculation
```typescript
function calculatePorterActiveShift(date: Date, porter: Porter, shift: Shift): boolean {
  const porterGroundZero = new Date(shift.ground_zero_date);
  porterGroundZero.setDate(porterGroundZero.getDate() + (porter.porter_offset || 0));
  
  const daysDiff = Math.floor((date.getTime() - porterGroundZero.getTime()) / (1000 * 60 * 60 * 24));
  const cycleLength = shift.days_on + shift.days_off;
  const cyclePosition = daysDiff % cycleLength;
  return cyclePosition >= 0 && cyclePosition < shift.days_on;
}
```

## Example Scenarios

### Porter Offset Example
- Porter A assigned to Day Shift A (4 on, 4 off)
- Porter A has 2-day offset
- Day Shift A active: Days 1-4
- Porter A active: Days 3-6 (straddles into Day Shift B period)
- Porter A shows on Day Shift A (days 3-4) and Day Shift B (days 1-2)

### Temporary Assignment Example
- Porter B assigned to Day Shift A
- Temporarily assigned to Pharmacy (01/10/25 - 07/10/25)
- Result: Porter B shows on Day Shift A card (lighter) + "Assigned to Pharmacy"

## Current Database State
- **Porters**: 50 total (8 shift-based, 42 relief, 3 part-time, 2 senior)
- **Departments**: 8 (ED, AMU, CT, X-ray GF, X-ray LGF, MRI, PTS, Pharmacy)
- **Services**: 9 (Post, Medical Records, Sharps, Blood, Laundry, District, Ad-Hoc, Waste, Helpdesk)
- **Shifts**: 4 (Day A, Day B, Night A, Night B)

## Implementation Phases
1. **Database Migration**: Schema updates and data migration
2. **Backend API**: New endpoints for shift calculations and assignments
3. **Frontend Types**: Updated TypeScript interfaces
4. **Porter Modal**: Enhanced with assignment tab
5. **Home Page**: 3-week navigation and shift cards
6. **Background Jobs**: Data freezing system

## Technical Notes
- Maintain DRY principles throughout implementation
- Reuse existing components and patterns where possible
- Ensure consistent styling with current modal system
- Implement proper validation for date ranges and assignments
- Consider performance implications of shift calculations
