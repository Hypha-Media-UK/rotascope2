# Porter Tracking App - Initial Requirements

## Date: 2025-09-26

## User Request Summary
Create a web app for tracking workers (Porters) on various shifts using:
- Vue3, Vite, Express.js, TypeScript, Modern CSS, MySQL with Docker
- Clean HTML, minimal nesting
- Modern CSS with Grid, Sub Grid, Layers, Container Queries
- No authentication required

## Core Functionality

### Shifts
- 24-hour operation with day (08:00-20:00) and night (20:00-08:00) shifts
- App opens showing current day's shifts
- Shifts have departments with operational days/hours
- Porters have contracted days/hours

### Staffing Logic
- Each department has minimum porter requirements
- "Low Staffing" alerts when porter hours don't align with department operational hours
- Cross-reference porter availability with department needs

### Configure Screen (3 tabs)

#### 1. Departments
- Add/Edit via modal
- Fields: Name, Operational Days/Hours (24/7 or custom), Porters Required
- Custom schedule: days of week with open/close times and porter counts

#### 2. Porters
- Add/Edit via modal
- Fields: Name, Contracted Hours (Shift Type/Custom/Relief), Shift Offset, Regular Department, Annual Leave, Sickness, Absence, Porter Type (Porter/Supervisor)

#### 3. Create Shifts
- Add/Edit shifts
- Fields: Name, Operational Hours, Type (Day/Night), Ident (A/B/C/D), Cycle (days on/off), Offset, Ground Zero date

### Home Screen
- Display all departments/shifts for current day (08:00-07:59)
- Department tables showing assigned porters and time allocations
- Weekday navigation buttons
- 6-week advance view
- Add porters to departments "on the fly"

## Design Requirements
- Clean design, no icons, minimal colors
- Reference: https://app.augmentcode.com/account/subscription
