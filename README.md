# Banking Loan & Risk Analytics
Tech stack: MySQL | Python | Pandas | Power BI

## Objective
Analyze a bank's loan portfolio to understand lending volume, customer risk, defaults, repayment behavior, and branch/loan-type performance.

## Folder
- Analysis_Queries.sql - database and table definitions
- Banking_risk_anakytics.sql - business SQL questions
- Bank_loan_risk_analysos.ipynb - cleaning, feature engineering, analysis and Power BI export
- branches.csv
- customers.csv
- loans.csv
- loan_payments.csv
- Banking_Loan_Risk_Analytics_Report.docx

## Execution order
1. Install MySQL 8.0 and MySQL Workbench.
2. Run 01_schema.sql.
3. Import the four CSV files into their matching tables.
4. Run 02_analysis_queries.sql.
5. Install Python packages: pandas, numpy, matplotlib.
6. Run 03_python_analysis.py.
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
