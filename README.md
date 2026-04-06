# Fintech Onboarding Funnel Analysis with NLP

## Overview
This project analyzes a simulated fintech onboarding funnel to identify where users drop off during account verification and activation. In addition to structured user and event data, the project incorporates user feedback text to examine how onboarding sentiment and complaint themes relate to KYC completion outcomes.

The goal of this project is to simulate how a data analyst might investigate onboarding friction, conversion loss, and user experience issues in a fintech product.

---

## Business Problem
Fintech platforms depend on users successfully completing onboarding steps such as phone verification, identity verification (KYC), bank linking, and first transaction activity.

A high drop-off rate at any stage can reduce:
- account activation
- first deposits
- payment usage
- long-term customer value

This project investigates:
- where users drop off in the onboarding funnel
- whether certain user segments perform worse
- whether user feedback sentiment is associated with lower completion rates
- what complaint themes appear most often among users who fail onboarding

---

## Project Objectives
This analysis answers the following questions:

1. What are the major drop-off points in the onboarding funnel?
2. Which user segments have lower KYC approval rates?
3. How does user sentiment relate to onboarding completion?
4. What complaint themes appear in negative user feedback?
5. What product or operational improvements might reduce onboarding friction?

---

## Dataset
This project uses **synthetic data** generated in Python to simulate a realistic fintech onboarding workflow.

### Files included:
- `users.csv` — user-level demographic and acquisition data
- `kyc_events.csv` — onboarding event log (account creation, KYC steps, bank linking)
- `transactions.csv` — simulated deposits and payment activity
- `user_feedback.csv` — short user feedback text with sentiment labels

### Example user attributes:
- device type
- acquisition channel
- region
- age group

### Example onboarding events:
- `account_created`
- `phone_verified`
- `kyc_started`
- `kyc_approved`
- `bank_linked`

---

## Tools Used
- **Python**
- **Pandas**
- **Matplotlib**
- **Seaborn**
- **Jupyter Notebook**
- **Basic NLP / Text Analysis**
- **SQL** (included for funnel and segmentation analysis)

---

## Analysis Performed

### 1. Funnel Analysis
Built an onboarding funnel to measure how many users progressed through:
- account creation
- phone verification
- KYC start
- KYC approval
- bank linking
- first deposit
- first transaction

### 2. Segmentation Analysis
Compared onboarding outcomes across:
- device type
- acquisition channel
- region
- age group

### 3. Activation Analysis
Examined post-onboarding activation behaviors such as:
- first deposit
- first payment

### 4. NLP Feedback Analysis
Used text feedback data to explore:
- sentiment distribution
- KYC approval rate by sentiment
- common complaint words in negative feedback
- complaint patterns among users who did not complete KYC

---

## Key Insights
Some sample findings from this analysis include:

- The largest onboarding drop-off occurred between **KYC start** and **KYC approval**, suggesting identity verification friction.
- Users with **negative onboarding feedback** had lower KYC approval rates than users with neutral or positive feedback.
- The most common complaint terms among non-approved users included:
  - `verification`
  - `upload`
  - `bank`
  - `unclear`
- Certain acquisition or device segments may show lower conversion performance, suggesting opportunities for targeted UX improvements.

---

## Potential Business Recommendations
Based on this analysis, a fintech product or operations team could consider:

- simplifying KYC document upload instructions
- improving messaging during verification delays
- optimizing onboarding for high-friction user segments
- investigating bank-linking usability issues
- prioritizing complaint themes associated with failed onboarding
---

## SQL Analysis Included

This project includes SQL scripts for:

- schema creation
- funnel stage counts
- conversion rate analysis
- segment-based KYC performance
- time-to-activation analysis

SQL files are organized in the `sql/` directory for reproducibility and modular analysis.

---

## Repository Structure
```bash
kyc-funnel-analysis/
├── data/
│   └── raw/
├── notebooks/
│   └── kyc_funnel_analysis.ipynb
├── outputs/
│   └── charts/
├── scripts/
│   └── generate_data.py
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_load_data_notes.sql
│   ├── 03_funnel_metrics.sql
│   ├── 04_segment_analysis.sql
│   └── 05_time_to_activation.sql
├── README.md
├── requirements.txt
└── .gitignore


## How to Run This Project

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/kyc-funnel-analysis.git
cd kyc-funnel-analysis
```

### 2. Create a virtual environment
```bash
python -m venv venv
```

### 3. Activate the virtual environment

**Windows (PowerShell):**
```powershell
venv\Scripts\Activate.ps1
```

**Windows (Command Prompt):**
```cmd
venv\Scripts\activate.bat
```

**macOS / Linux:**
```bash
source venv/bin/activate
```

### 4. Install required packages
```bash
pip install -r requirements.txt
```

### 5. Generate the synthetic data
Run the script below to generate synthetic onboarding, transaction, and feedback data:

```bash
python scripts/generate_data.py
```

This will populate:

- `data/raw/users.csv`
- `data/raw/kyc_events.csv`
- `data/raw/transactions.csv`
- `data/raw/user_feedback.csv`

### 6. Open and run the notebook
Open the notebook below in Jupyter or VS Code and run all cells:

```bash
notebooks/kyc_funnel_analysis.ipynb
```

The notebook includes:
- onboarding funnel analysis
- drop-off metrics
- user segment comparisons
- NLP feedback sentiment analysis
- complaint theme exploration

### 7. (Optional) Run SQL analysis
SQL scripts are included in the `sql/` folder for reproducibility and database-style analysis.

Included SQL files:
- `01_create_tables.sql`
- `02_load_data_notes.sql`
- `03_funnel_metrics.sql`
- `04_segment_analysis.sql`
- `05_time_to_activation.sql`

You can run them in:
- SQLite
- PyCharm Database Console
- DB Browser for SQLite
- VS Code SQL extensions

### 8. Review saved outputs
Charts and exported visuals can be saved to:

```bash
outputs/charts/
```

---

## Project Notes

- This project uses **synthetic data** for demonstration and portfolio purposes.
- The workflow is designed to simulate a real fintech onboarding / KYC analytics case study.
- SQL and Python are both used to demonstrate reproducible analysis and business reporting.

---

## Future Improvements

Potential future enhancements include:

- dashboarding in Tableau or Power BI
- predictive modeling for KYC approval
- text classification of onboarding complaints
- cohort analysis of activation behavior
- A/B test simulation for onboarding UX changes
