			/*----Banking Loan & Risk Analytics ----*/
/*=======================================================================
							Create Database 
 ========================================================================*/
create database if not exists banking_risk_analytics;
use banking_risk_analytics;

/*=======================================================================
							Create Tables 
 ========================================================================*/
create table branches (
branch_id int PRIMARY KEY,
branch_name VARCHAR(100) NOT NULL,
city VARCHAR(50) NOT NULL,
region VARCHAR(50) NOT NULL
);

create table customers (
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100) NOT NULL,
age INT NOT NULL,
annual_income DECIMAL(14,2) NOT NULL,
city VARCHAR(50),
occupation VARCHAR(50),
credit_score INT,
existing_loans INT DEFAULT 0
);

create table loans (
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

create table loan_payments (
payment_id INT PRIMARY KEY,
loan_id INT NOT NULL,
installment_no INT NOT NULL,
due_amount DECIMAL(14,2) NOT NULL,
paid_amount DECIMAL(14,2) NOT NULL,
days_late INT DEFAULT 0,
payment_status ENUM('On Time','Late') NOT NULL,
FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

/*========================================================================
							Count all Tables
==========================================================================*/
select count(*) from customers;
select count(*) from loans;
select count(*) from loan_payments;

/*========================================================================
						Check Bank Loan Overview  
==========================================================================*/
 
select count(*) as total_loans,
sum(loan_amount) as total_loan_value,
avg(loan_amount) as avg_loan_amount
from loans
where approval_status = 'Approved';

/*========================================================================
						Check Default Rate 
==========================================================================*/

select round(100 * sum(loan_status = 'Defaulted') / count(*) , 2 ) as Default_rate
from loans
where approval_status = 'Approved';

/*========================================================================
						Types of loan Portfolio  
==========================================================================*/

select loan_type,
count(*) as loans,
sum(loan_amount) as total_amount,
avg(loan_amount) as avg_amount
from loans
where approval_status = 'Approved'
group by loan_type
order by total_amount desc;

/*========================================================================
						 Check Risk by Credit Score  
==========================================================================*/

select case
when c.credit_score < 600 then 'Poor'
when c.credit_score < 680 then 'Fair'
when c.credit_score < 750 then 'Good'
else 'Excelent'
end as credit_band,
count(distinct l.loan_id) as loans,
round(100 * sum(l.loan_status= 'Defaulted') / count(*) , 2) as Defaulte_rate
from customers c
join loans l on c.customer_id = l.customer_id
where l.approval_status = 'Approved'
group by credit_band
order by Defaulte_rate desc; 

/*========================================================================
						Depth-To-Income (DTI) Risk  
==========================================================================*/

select case
when DTI > 0.50 then 'High DTI'
when DTI > 0.35 then 'Medium DTI'
else 'Low DTI'
end as DTI_bands,
count(*) as loans,
round(avg(DTI), 3) as Avg_DTI,
round(100 * sum(loan_status = 'Defaulted')/ count(*) ,3)  as Defaulte_rate
from loans
where approval_status = 'Approved'
group by DTI_bands
order by Defaulte_rate desc;

/*========================================================================
						Branch Performance  
==========================================================================*/

select b.branch_name,
count(l.loan_id) as loans,
sum(l.loan_amount) as loan_value,
round(100 * sum(l.loan_status = 'Defaulted') / count(l.loan_id) , 2) as defaulte_rate
from branches b
join loans l on b.branch_id = l.branch_id
where l.approval_status = 'Approved'
group by b.branch_name
order by defaulte_rate desc;

/*========================================================================
					Check Customer with multiple loans 
==========================================================================*/

select c.customer_id, c.customer_name,
count(l.loan_id) as active_or_approve_loans,
sum(l.loan_amount) as total_exposure
from customers c
join loans l on c.customer_id= l.customer_id
where l.approval_status = 'Approved'
group by c.customer_id, c.customer_name
having count(l.loan_id) > 1
order by total_exposure desc;

/*=============================================================================
								Bussiness Questions
===============================================================================*/
-- 1. What is the total approved loan and average loan size
select
count(*) as approved_loan_count,
sum(loan_amount) as total_approved_loan,
avg(loan_amount) as average_loan_size
from loans
where approval_status = 'Approved';

-- 2. What percentage of approved loans are defaulted
select
count(case
when approval_status = 'Approved' then 1
end) as approved_loans,
count(case
when approval_status = 'Approved'
and loan_status = 'Defaulted' then 1
end) as defaulted_loans,
round( 100.0 * count(
case
when approval_status = 'Approved'
and loan_status = 'Defaulted' then 1
end) / nullif(count(
case
when approval_status = 'Approved' then 1
end), 0),2) as default_rate_pct
from loans;

-- 3. Which loan types have the highest loan exposure
select loan_type,
count(*) as total_loans,
sum(loan_amount) as total_exposure,
round(avg(loan_amount), 2) as average_loan_size,
round( 100.0 * sum(loan_amount) / nullif(
(
select sum(loan_amount)
from loans
where approval_status = 'Approved'
), 0),2
) as exposure_percentage
from loans
where approval_status = 'Approved'
group by loan_type
order by total_exposure desc;

-- 4. How does default rate vary by credit-score band
select case
when c.credit_score < 600 then 'Poor'
when c.credit_score < 680 then 'Fair'
when c.credit_score < 750 then 'Good'
else 'Excelent'
end as credit_band,
count(distinct l.loan_id) as loans,
round(100 * sum(l.loan_status= 'Defaulted') / count(*) , 2) as Defaulte_rate
from customers c
join loans l on c.customer_id = l.customer_id
where l.approval_status = 'Approved'
group by credit_band
order by Defaulte_rate desc; 

-- 5. Does higher DTI correspond to higher repayment risk
select
case
when dti < 20 then 'Low DTI: Below 20%'
when dti < 36 then 'Moderate DTI: 20-35%'
else 'High DTI: 36% +'
end as dti_band,
count(*) as total_loans,
sum(
case
when loan_status = 'Defaulted' then 1
else 0
end
) as defaulted_loans,
round( 100.0 * sum(
case
when loan_status = 'Defaulted' then 1
else 0
end) / nullif(count(*), 0), 2) as default_rate_pct
from loans
where approval_status = 'Approved'
group by dti_band
order by default_rate_pct desc;

-- 6. Which branches have relatively high default rates
select b.branch_name,
count(l.loan_id) as loans,
sum(l.loan_amount) as portfolio_value,
round(100 * sum(l.loan_status = 'Defaulted') / count(l.loan_id) , 2) as defaulte_rate
from branches b
join loans l on b.branch_id = l.branch_id
where l.approval_status = 'Approved'
group by b.branch_name
order by defaulte_rate desc;

-- 7. Which customers have multiple loans and high total exposure
select customer_id,
count(*) as total_loans,
sum(loan_amount) as total_loan_exposure,
round(avg(loan_amount), 2) as average_loan_size,
sum(
case
when loan_status = 'Defaulted' then 1
else 0
end) as defaulted_loans
from loans
where approval_status = 'Approved'
group by customer_id
having count(*) > 1
order by total_loan_exposure desc;

-- 8. Which customers or loans should be prioritized for risk review
select loan_id, customer_id, loan_amount, dti, loan_status,
case
when loan_status = 'Defaulted' then 'High Priority - Existing Default'
when dti >= 36 then 'Review - High DTI'
else 'Standard Monitoring'
end as risk_review_priority
from loans
where approval_status = 'Approved'
order by
case
when loan_status = 'Defaulted' then 1
when dti >= 36 then 3
else 5
end, loan_amount desc;


    
    
