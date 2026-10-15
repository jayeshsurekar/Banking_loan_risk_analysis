# Banking Loan & Risk Analytics
Tech stack: MySQL | Python | Pandas | Power BI

## Objective
Analyze a bank's loan portfolio to understand lending volume, customer risk, defaults, repayment behavior, and branch/loan-type performance.

## Folder
- Banking_risk_analytics.sql - database and table definitions
- Bank_loan_risk_analysis.ipynb - cleaning, feature engineering, analysis and Power BI export
- branches.csv
- customers.csv
- loans.csv
- loan_payments.csv
- Banking Loan & Risk Analytics Documentation.docx
- Banking Loan & Risk Analytics Report.docx
- ERR Diagram.png
- defualt_rate_by_credit_band.png
- powerbi_loan_risk.csv
- powerbi_payments.csv

## Execution order
1. Install MySQL 8.0 and MySQL Workbench.
2. Run Banking_risk_analytics.sql.
3. Import the four CSV files into their matching tables.
4. Install Python packages: pandas, numpy, matplotlib.
5. Run Bank_Loan_Risk_analysis.ipynb.
7. Open Power BI Desktop and load powerbi_loan_risk.csv and powerbi_payments.csv.
8. Build the dashboard using the measures and layout in the report.

## Power BI pages
1. Executive Overview
2. Credit Risk Analysis
3. Loan Portfolio Analysis
4. Repayment & Collections
5. Branch & Customer Risk

## Core KPIs
Total Loan Value, Approved Loans, Average Loan Amount, Default Rate, High-Risk Loans, Average Credit Score, Average DTI, Late Payment Rate.
