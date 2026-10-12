-- Banking Loan & Risk Analytics
CREATE DATABASE IF NOT EXISTS banking_risk_analytics;
USE banking_risk_analytics;

DROP TABLE IF EXISTS loan_payments;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    annual_income DECIMAL(14,2) NOT NULL,
    city VARCHAR(50),
    occupation VARCHAR(50),
    credit_score INT,
    existing_loans INT DEFAULT 0
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    purpose VARCHAR(100),
    loan_amount DECIMAL(14,2) NOT NULL,
    tenure_months INT NOT NULL,
    interest_rate DECIMAL(5,2),
    dti DECIMAL(6,3),
    loan_status ENUM('Active','Closed','Defaulted') NOT NULL,
    approval_status ENUM('Approved','Rejected') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE loan_payments (
    payment_id INT PRIMARY KEY,
    loan_id INT NOT NULL,
    installment_no INT NOT NULL,
    due_amount DECIMAL(14,2) NOT NULL,
    paid_amount DECIMAL(14,2) NOT NULL,
    days_late INT DEFAULT 0,
    payment_status ENUM('On Time','Late') NOT NULL,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

