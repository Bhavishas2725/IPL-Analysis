# IPL Performance Analysis Dashboard (2008–2024)

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)

---

## Project Overview

An end-to-end Data Analytics project analyzing **16 seasons of IPL cricket data (2008–2024)** covering over **260,000 ball-by-ball deliveries** across **1,095 matches**. This project uncovers batting performance trends, bowling efficiency, team win patterns, venue insights, and season-wise evolution of the IPL — presented through an interactive 5-page Power BI dashboard.

---

## Business Questions Answered

| # | Question |
|---|---|
| 1 | Which teams have the most consistent win records across seasons? |
| 2 | Who are the all-time top run scorers and wicket takers? |
| 3 | Does winning the toss actually help win the match? |
| 4 | Which venues favor batting teams vs bowling teams? |
| 5 | How has IPL scoring patterns evolved from 2008 to 2024? |
| 6 | Which over phase (Powerplay/Middle/Death) produces the most sixes? |
| 7 | Which players win the most Player of the Match awards? |
| 8 | How do top batsmen perform across different seasons? |

---

## Dataset

| File | Rows | Description |
|---|---|---|
| `matches.csv` | 1,095 | Match-level data — teams, venue, toss, winner, result |
| `deliveries.csv` | 260,920 | Ball-by-ball data — runs, wickets, batsman, bowler |

**Source:** [IPL Complete Dataset 2008–2024 — Kaggle](https://www.kaggle.com)

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Python (Pandas) | Data cleaning, feature engineering |
| MySQL | Database storage, business SQL queries |
| Power BI | Interactive dashboard, DAX measures |
| Jupyter Notebook | Exploratory data analysis |
| GitHub | Version control, project hosting |

---

## Project Architecture

```
Raw CSV Files (Kaggle)
        ↓
Python / Pandas (Cleaning + Feature Engineering)
        ↓
MySQL Database (ipl_analysis)
        ↓
10 Business SQL Queries
        ↓
Power BI Dashboard (5 Pages)
        ↓
GitHub + LinkedIn
```

---

##  Data Cleaning & Feature Engineering

**Steps performed in Python:**

- Converted all date/timestamp columns to proper datetime format
- Handled missing values in `winner`, `player_of_match`, `city` columns
- Merged match-level information (season, venue, teams) into deliveries dataset
- Created new features:
  - `is_four` → 1 if batsman scored 4, else 0
  - `is_six` → 1 if batsman scored 6, else 0
  - `over_phase` → categorized each over into Powerplay (1–6), Middle (7–16), Death (17–20)
  - `is_wicket_clean` → cleaned wicket flag excluding run outs

**Final cleaned dataset:** 260,920 rows × 30 columns

---

## SQL Analysis

**10 Business Queries written and executed in MySQL:**

```sql
-- Sample Query: Rank top 3 run scorers per season
SELECT season, batter, season_runs, rnk
FROM (
    SELECT season, batter,
           SUM(batsman_runs) AS season_runs,
           DENSE_RANK() OVER (PARTITION BY season 
                              ORDER BY SUM(batsman_runs) DESC) AS rnk
    FROM deliveries
    GROUP BY season, batter
) AS ranked
WHERE rnk <= 3
ORDER BY season, rnk;
```

**Other queries cover:**
- Team win counts and win percentage
- Toss decision impact on match results
- Top 10 run scorers and wicket takers all-time
- Best economy bowlers in death overs
- Highest scoring venues (avg runs per match)
- Season-wise total runs and sixes trend
- Player of the Match award leaders

---

##  Power BI Dashboard

**5-Page Interactive Dashboard:**

### Page 1: Tournament Overview
- KPI Cards: Total Matches, Total Runs, Total Sixes, Total Fours, Total Wickets
- Line Chart: Season-wise runs trend (2008–2024)
- Column Chart: Most winning teams
- Donut Chart: Toss decision split (bat vs field)
- Slicers: Season, Team

### Page 2: Batting Analysis
- Bar Chart: Top 10 all-time run scorers
- Column Chart: Runs by over phase (Powerplay/Middle/Death)
- Matrix Table: Batsman → Runs, Sixes, Fours
- Slicers: Season, Batting Team

### Page 3: Bowling Analysis
- Bar Chart: Top 10 all-time wicket takers
- Column Chart: Wickets by over phase
- Matrix Table: Bowler → Wickets, Matches
- KPI Card: Total Wickets
- Slicers: Season, Bowling Team

### Page 4: Venue & Insights
- Map Visual: Matches by city (bubble size = match count)
- Bar Chart: Highest scoring venues (avg runs/match)
- Column Chart: Matches per season trend
- KPI Card: Toss Win %
- Slicers: Season, Venue

### Page 5: Team Details (Drillthrough)
- Right-click any team → Drillthrough → Team Details
- Cards: Total Wins, Matches Played
- Column Chart: Season-wise win trend for selected team

---

##  Key Insights

> *(Based on IPL 2008–2024 data)*

- **Mumbai Indians** lead all-time wins with the most consistent performance across seasons
- Teams choosing to **field first after winning the toss** win approximately **52%** of matches — marginal advantage
- **Death overs (17–20)** produce the highest number of sixes compared to Powerplay and Middle overs
- **Virat Kohli** holds the record for most runs in a single IPL season
- Venues in **Mumbai and Bangalore** consistently produce the highest average runs per match — batsman-friendly pitches
- **CH Gayle and AB de Villiers** dominate the all-time six-hitting leaderboard
- Season-wise analysis shows a clear **upward trend in total runs** from 2008 to 2024 — indicating more aggressive batting strategies over the years

---

##  Repository Structure

```
ipl-performance-analysis/
│
├── data/
│   ├── matches.csv                  # Raw matches data
│   ├── deliveries.csv               # Raw deliveries data
│   ├── matches_cleaned.csv          # Cleaned matches
│   └── deliveries_cleaned.csv       # Cleaned deliveries
│
├── notebooks/
│   └── ipl_cleaning.ipynb           # Python data cleaning notebook
│
├── sql/
│   └── ipl_queries.sql              # 10 business SQL queries
│
├── dashboard/
│   └── IPL_Dashboard.pbix           # Power BI dashboard file
│
├── screenshots/
│   ├── overview.png                 # Dashboard screenshots
│   ├── batting.png
│   ├── bowling.png
│   └── venue.png
│
└── README.md
```

---

##  How to Run This Project

**1. Clone the repository:**
```bash
git clone https://github.com/Bhavishas2725/ipl-performance-analysis.git
cd ipl-performance-analysis
```

**2. Install Python dependencies:**
```bash
pip install pandas numpy matplotlib jupyter
```

**3. Run the cleaning notebook:**
```bash
jupyter notebook notebooks/ipl_cleaning.ipynb
```

**4. Set up MySQL database:**
```sql
CREATE DATABASE ipl_analysis;
USE ipl_analysis;
-- Run CREATE TABLE statements from ipl_queries.sql
-- Load cleaned CSVs using LOAD DATA INFILE or Import Wizard
```

**5. Open Power BI dashboard:**
- Open `dashboard/IPL_Dashboard.pbix` in Power BI Desktop
- Refresh data source to point to your local CSV files

---

##  Dashboard Screenshots


| Page | Preview |
|---|---|
| Overview | ![Overview]() |
| Batting | ![Batting](screenshots/batting.png) |
| Bowling | ![Bowling](screenshots/bowling.png) |
| Venue | ![Venue](screenshots/venue.png) |

---

## Author

**Bhavisha S**
- 💼 Aspiring Data Analyst
- 🎓 B.E. Computer Science (AI & ML) — AMET University, Chennai
- 📧 bhavishasiva272@gmail.com
- 🔗 [LinkedIn](https://linkedin.com/in/bhavishasiva)
- 🐙 [GitHub](https://github.com/Bhavishas2725)
- 🌐 [Portfolio](https://bhavishass.netlify.app)

---

##  License

This project is open source and available under the [MIT License](LICENSE).

---

⭐ **If you found this project helpful, please give it a star!**
