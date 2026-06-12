# AgriViz
A real-time, interactive data visualization dashboard for plantation and estate performance.

⚠️ This project is a conceptual demo based on a real-world application I built while working at a Former Company. All data has been anonymized or simulated. This version does not reflect any proprietary or confidential information.

## Overview

**AgriViz** is a dynamic web-based analytics platform designed to help plantation and estate managers explore and analyze key agricultural, operational, and financial performance metrics in real time. Users can interactively simulate different cost and yield scenarios through intuitive graphs and dashboards, enabling faster, more informed decision-making.

---

## Key Features

### Divisional View (Estate-Level)
Visualize performance at the division level within a selected estate using:
- Bar Charts: 
  - Plucked Hectare (ha)
  - Made-Tea Yield Per Hectare (YPH)
  - Made-Tea Cost of Production (Labor)
- Benchmark Lines: Estate-wide averages for easy comparison.
- Color-coded legends for quick visual parsing.

### Plantation View (Estate-Level Comparison)
Aggregate and compare estate-level data across a plantation:
- Same metric breakdown as the divisional view.
- Plantation-wide benchmark lines.
- Clear visual indicators to spot top/bottom performers.

### Real-Time Controls
- Adjust input values for wage rates, kilo rates, and yield percentages.
- View instant updates across graphs and detailed metric panels.
- Reset all inputs and explore "what-if" scenarios live.

---

## Core Metrics Calculated
- Made-Tea Yield (YPH)
- Cost of Production (Labor)
- Plucking Average
- Derived from field, factory, and labor datasets.

---

## Tech Stack
- Frontend: React, Chart.js / D3.js
- Backend: Node.js (with mock API/data for demo)

<img width="903" height="444" alt="image" src="https://github.com/user-attachments/assets/05a04322-76d6-4913-b409-9d91425cf696" />
