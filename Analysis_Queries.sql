use banking_risk_analytics;

select count(*) from customers;
select count(*) from loans;
select count(*) from loan_payments;

-- 1. Portfolio Overview
select count(*) as total_loans,
sum(loan_amount) as total_loan_value,
avg(loan_amount) as avg_loan_amount
from loans
where approval_status = 'Approved';

-- 2. Default rate
select round(100 * sum(loan_status = 'Defaulted') / count(*) , 2 ) as Default_rate
from loans
where approval_status = 'Approved';

-- 3. Loan protfolio by type
select loan_type,
count(*) as loans,
sum(loan_amount) as total_amount,
avg(loan_amount) as avg_amount
from loans
where approval_status = 'Approved'
group by loan_type
order by total_amount desc;

-- 4. Risk by credit score band
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

-- 5. Depth-To-Income (DTI) Risk
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

-- 6. Branch Performance
select b.branch_name,
count(l.loan_id) as loans,
sum(l.loan_amount) as portfolio_value,
round(100 * sum(l.loan_status = 'Defaulted') / count(l.loan_id) , 2) as defaulte_rate
from branches b
join loans l on b.branch_id = l.branch_id
where l.approval_status = 'Approved'
group by b.branch_name
order by defaulte_rate desc;

-- 7. Customers with multiple loans
select c.customer_id, c.customer_name,
count(l.loan_id) as active_or_approve_loans,
sum(l.loan_amount) as total_exposure
from customers c
join loans l on c.customer_id= l.customer_id
where l.approval_status = 'Approved'
group by c.customer_id, c.customer_name
having count(l.loan_id) > 1
order by total_exposure desc;

