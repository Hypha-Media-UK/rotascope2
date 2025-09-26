# Porter Tracking App - Clarifications

## Date: 2025-09-26

## Clarifications Received:

### 1. Shift Offsets
- Yes, for porters who work same shift type but start cycle later than main group

### 2. Low Staffing Logic
- Floor staff can be manually assigned
- Low staffing triggered by: annual leave, sickness, absences
- Only considers porters specifically assigned to that department

### 3. Time Granularity
- Just start/end times for validation
- Must check porter contracted hours vs assignment times
- Example: Porter assigned until 17:00 but contracted until 16:00 = Low staffing flag remains

### 4. Relief Porters
- Cover holidays, sickness, absence
- Can be deployed anywhere
- Guaranteed 37.5 hours/week
- Sometimes overstaffed, sometimes critical

### 5. Database Structure
- Separate tables: Departments, Porters, Shifts, Assignments, Absences
- Many connected relationships for operational times, contracted hours, leave, absences

### 6. On-the-fly Assignments
- Relief/moved porters can be assigned with date ranges
- Not just single day assignments

## Implementation Notes:

### Authentication
- No login/auth required
- Only supervisors will edit
- Any supervisor can visit and make changes
- May change in future

### Validation Requirements
- Prevent double-booking porters
- Check porter availability against existing assignments
- Validate contracted hours vs assignment times
- Track relief porter 37.5 hour guarantee

### Architecture Considerations
- Build extensible foundation for future features
- Avoid creating "closed shops" that prevent layering
- Focus on relationship integrity between tables
