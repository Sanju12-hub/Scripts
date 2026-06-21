

/*
-- Cleaning Regional Manager Table
select * 
from [dbo].[DM.Regional_Manager]
alter table [dbo].[DM.Regional_Manager]
drop column column7, column8, column9, column10, column11

-- Cleaning Policy Type Table
     -- exec sp_rename '[dbo].[DM.Policy_Type].column2' ,'Policy_Type', 'COLUMN'
     -- alter table table_name drop column col4,col5,..

-- Cleaning Policy Plan table
select * from [dbo].[DM.Policy_Protection_Plan]
alter table [dbo].[DM.Policy_Protection_Plan]
drop column column5, column6, column7, column8, column9, column10, column11, column12;

-- Cleaning Insurance Agent Table
select * from [dbo].[DM.Insurance_Agent_Table]
alter table [dbo].[DM.Insurance_Agent_Table]
drop column column5, column6, column7, column8, column9, column10, column11, column12;

*/


--SECTION 1 - BASIC SELECT (1-20)
--Customer
--1.	Display all customers. Cleaned data by droping incorrect columns
alter table [dbo].[DM.Customer_Detail_Table]
drop column column12;
select * from [dbo].[DM.Customer_Detail_Table]

--2.	Display only female customers.
select *
from [dbo].[DM.Customer_Detail_Table] 
where Gender = 'Female';

--3.	Display customers above age 50.
select * 
from [dbo].[DM.Customer_Detail_Table]
where Age_at_Entry > 50;

--4.	Display customers from Maharashtra.
select * 
from [dbo].[DM.Customer_Detail_Table]
where State = 'Maharashtra';

--5.	Display distinct occupations.
select distinct Occupation
from [dbo].[DM.Customer_Detail_Table]

create clustered index idx_CustID on [dbo].[DM.Customer_Detail_Table] (Customer_id)

--6.	Display distinct states.
select distinct State
from [dbo].[DM.Customer_Detail_Table]

--7.	Count total customers.
select count(distinct Customer_ID)
from [dbo].[DM.Customer_Detail_Table]

--8.	Count customers by gender.
select count(*) as Count_Cust, 'Female_Cust' as gender_cust
from [dbo].[DM.Customer_Detail_Table] 
where Gender = 'Female'
union
select count(*) as Count_Cust, 'Male_Cust' as gender_cust
from [dbo].[DM.Customer_Detail_Table] 
where Gender = 'Male';

--9.	Count smokers and non-smokers.
select count(*) as Count_Cust, 'Smokers' as gender_cust
from [dbo].[DM.Customer_Detail_Table] 
where Smoker_status = 1
union
select count(*) as Count_Cust, 'Non_Smokers' as gender_cust
from [dbo].[DM.Customer_Detail_Table] 
where Smoker_status = 0;

--10.	Display customers whose occupation contains "Engineer".
select * 
from [dbo].[DM.Customer_Detail_Table]
where Occupation like 'Engineer%'
__ ______________________________________
-- Policy
-- 11.	Display all active policies.

select *,
case 
when Policy_Type = 'Endowment Policy' then 989
when Policy_Type = 'Whole' then 968
when Policy_Type = 'Universal' then 988
end Policy_Number
from [dbo].[DM.Policy_Type] 

select * 
from [dbo].[FCT.Insurance_Policy_Table]
where Policy_Status = 'Active';


-- 12.	Display all lapsed policies.
select *
from [dbo].[FCT.Insurance_Policy_Table]
where Policy_Status = 'Lapsed';

-- 13.	Display policies purchased in 2024.
select *
from [dbo].[FCT.Insurance_Policy_Table]
where year(Date_of_Purchase) = 2024;

-- 14.	Display policies with Premium Amount > 50000.
select * 
from [dbo].[FCT.Insurance_Policy_Table]
where Premium_Amount > 50000;

-- 15.	Display policies with Loan Eligible = 'Yes'.
select *
from [dbo].[FCT.Insurance_Policy_Table]
where Loan_Eligible =1;

-- 16.	Display policies with Sum Assured > 1000000.
select * 
from  [dbo].[FCT.Insurance_Policy_Table]
where Sum_Assured_INR_Coverage_Amount > 1000000;

-- 17.	Display distinct payment frequencies.
select distinct Payment_Frequency
from [dbo].[FCT.Insurance_Policy_Table]

-- 18.	Count total policies.
select count(Distinct Policy_Number) as Total_Polocies
from [dbo].[FCT.Insurance_Policy_Table]

-- 19.	Count active policies.
select count(*) 
from [dbo].[FCT.Insurance_Policy_Table]
where Policy_Status = 'Active';


-- 20.	Count policies by state.
select State, count(*) as Total_Policies 
from [dbo].[FCT.Insurance_Policy_Table]
group by State order by count(*) desc
-- _________________________________________________________________________________________________________________

--           SECTION 2 - AGGREGATIONS (21-40)

-- 21.	Total premium collected.
select sum(Premium_Amount) As Total_Prem_Amount
from [dbo].[FCT.Insurance_Policy_Table]

-- 22.	Average premium amount.
select avg(Premium_Amount) As Avg_Prem_Amount
from [dbo].[FCT.Insurance_Policy_Table]

-- 23.	Maximum premium amount.
select Max(Premium_Amount) As Max_Prem_Amount
from [dbo].[FCT.Insurance_Policy_Table]

-- 24.	Minimum premium amount.
select Min(Premium_Amount) As Min_Prem_Amount
from [dbo].[FCT.Insurance_Policy_Table]

-- 25.	Total sum assured.
select Sum(Sum_Assured_INR_Coverage_Amount) as Total_Sum_Assured
from [dbo].[FCT.Insurance_Policy_Table]

-- 26.	Average customer age.
select avg(Age_at_Entry) as Avg_Age
from [dbo].[DM.Customer_Detail_Table]

-- 27.	Total underwriting expenses.
select Sum(Underwriting_expenses) as Total_underwriting_expenses
from [dbo].[FCT.Insurance_Policy_Table];

-- 28.	Total loan amount allowed.
select Sum(Loan_Amount_Allowed) as Total_Loan_Amount_Allowed
from [dbo].[FCT.Insurance_Policy_Table];

-- 29.	Total claims raised.
select count(Claim_ID) as Total_Claims
from [dbo].[FCT.Insurance_Policy_Table];

-- 30.	Count policies per payment frequency.
select Payment_Frequency, count(*) as Total_Policies
from [dbo].[FCT.Insurance_Policy_Table]
group by Payment_Frequency order by count(*) desc;
-- ________________________________________

-- 31.	Total premium by state.
select State, sum(Premium_Amount) as Total_Premium 
from [dbo].[FCT.Insurance_Policy_Table]
group by State order by sum(Premium_Amount) desc

-- 32.	Total premium by year.
select year(Date_of_Purchase) as Year, sum(Premium_Amount) as Total_Premium 
from [dbo].[FCT.Insurance_Policy_Table]
group by year(Date_of_Purchase) order by sum(Premium_Amount) desc

-- 33.	Total premium by quarter.
select sum(Premium_Amount) As Total_Prem_Amount_Quarter
from [dbo].[FCT.Insurance_Policy_Table]
where Payment_frequency = 'Quarterly'

-- or 

select Datepart(Quarter,Date_of_Purchase) as Quarter, sum(Premium_Amount) as Total_Premium 
from [dbo].[FCT.Insurance_Policy_Table]
group by Datepart(Quarter,Date_of_Purchase) order by sum(Premium_Amount) desc


-- 34.	Total premium by month.
select sum(Premium_Amount) As Total_Prem_Amount_Quarter
from [dbo].[FCT.Insurance_Policy_Table]
where Payment_frequency = 'Monthly'

-- OR

select format(Date_of_Purchase,'MMMM') as Month, sum(Premium_Amount) as Total_Premium 
from [dbo].[FCT.Insurance_Policy_Table]
group by format(Date_of_Purchase,'MMMM') order by sum(Premium_Amount) desc

-- 35.	Average premium by state.
select State, Avg(Premium_Amount) as Avg_Premium 
from [dbo].[FCT.Insurance_Policy_Table]
group by State


-- 36.	Average tenure by state.
select State, Avg(Tenure_Years) as Avg_tenure 
from [dbo].[FCT.Insurance_Policy_Table]
group by State 

-- 37.	Maximum sum assured by state.
select state, Max(Sum_Assured_INR_Coverage_Amount) as Max_Sum_Assured
from [dbo].[FCT.Insurance_Policy_Table]
group by State

-- 38.	Total policies by policy status.
select Policy_Status, count(Policy_Number) as Total_Policies
from [dbo].[FCT.Insurance_Policy_Table]
group by Policy_Status

-- 39.	Total loan amount by policy type.
select Policy_Type_Code, sum(Loan_Amount_Allowed) as Total_Loan_Amount_Allowed
from [dbo].[FCT.Insurance_Policy_Table]
group by Policy_Type_Code;

-- 40.	Total premium by agent.
select Sales_Agent_Code, sum(Premium_Amount) as Total_Premium 
from [dbo].[FCT.Insurance_Policy_Table]
group by Sales_Agent_Code;

-- ____________________________________________________________________________________________________________


-- SECTION 3 - GROUP BY + HAVING (41-60)

-- 41.	States having more than 100 policies.
select State, count(Policy_Number) as Total_Policies
from [dbo].[FCT.Insurance_Policy_Table] 
group by State
having count(Policy_Number) > 100;

-- 42.	Agents selling more than 50 policies.
select Sales_Agent_Code, count(Policy_Number) as Total_Policies
from [dbo].[FCT.Insurance_Policy_Table] 
group by Sales_Agent_Code
having count(Policy_Number) > 50;

--43.	Policy types having premium > 10 lakh.
select Policy_Type_Code, sum(Premium_Amount) as Total_Premium
from [dbo].[FCT.Insurance_Policy_Table] 
group by Policy_Type_Code
having sum(Premium_Amount) > 1000000;

-- 44.	States with average premium > 50000.
select State, Avg(Premium_Amount) as Avg_Premium
from [dbo].[FCT.Insurance_Policy_Table] 
group by State
having Avg(Premium_Amount) > 50000;

-- 45.	Customers having more than 1 policy.
select Customer_ID, count(Policy_Number) as Total_Policies
from [dbo].[FCT.Insurance_Policy_Table] 
group by Customer_ID
having count(Policy_Number) > 1;

-- 46.	Customers paying premium > 1 lakh.
select Customer_ID, sum(Premium_Amount) as Total_Premium
from [dbo].[FCT.Insurance_Policy_Table] 
group by Customer_ID
having sum(Premium_Amount) > 100000;

-- 47.	Agents generating premium > 50 lakh.
select Sales_Agent_Code, sum(Premium_Amount) as Total_Premium
from [dbo].[FCT.Insurance_Policy_Table] 
group by Sales_Agent_Code
having sum(Premium_Amount) > 5000000 order by sum(Premium_Amount) desc ;

-- 48.	Regions having more than 500 policies.
select rm.Region, count(fct.Policy_Number) as Total_Policies
from [dbo].[FCT.Insurance_Policy_Table] fct
left join [dbo].[DM.Regional_Manager] rm
on fct.RM_ID = rm.Regional_Manager_ID
group by rm.Region
having count(fct.Policy_Number) > 500;

-- 49.	Policy plans having more than 1000 customers.
select pp.Policy_name, count(c.Customer_ID) as Total_Customers
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Policy_Protection_Plan] pp
on fct.Policy_code = pp.Policy_Code
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID
group by pp.Policy_Name
having count(c.Customer_ID) > 1000;

-- 50.	Occupations having more than 50 customers.
select Occupation, count(Customer_ID) as Total_Customers
from [dbo].[DM.Customer_Detail_Table]
group by Occupation
having count(Customer_ID) > 50;

-- ________________________________________

-- 51.	States with highest premium.
select top 5 State, Max(Premium_Amount) as Highest_Prem
from [dbo].[FCT.Insurance_Policy_Table]
group by State 
order by max(Premium_Amount) desc;

-- 52.	Agents with highest sales.
select Top 5 Sales_Agent_Code, count(Customer_ID) as Total_Sales
from [dbo].[FCT.Insurance_Policy_Table]
group by Sales_Agent_Code 
order by count(Customer_ID) desc;

-- 53.	Top 5 policy types by premium.
select Top 5 Policy_Type_Code, Sum(Premium_Amount) as Total_Prem
from [dbo].[FCT.Insurance_Policy_Table]
group by Policy_Type_Code 
order by Sum(Premium_Amount) desc;

-- 54.	Top 5 states by policies sold.
select top 5 State, Count(Policy_number) as Total_Policies
from [dbo].[FCT.Insurance_Policy_Table]
group by State
order by Count(Policy_number) desc

-- 55.	Top occupations by premium contribution.
select top 5 c.Occupation, sum(fct.Premium_Amount) as Total_Prem
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID
group by c.Occupation 
order by sum(fct.Premium_Amount) desc

-- 56.	Top customers by sum assured.
select top 5 c.customer_ID, sum(fct.Sum_Assured_INR_Coverage_Amount) as Total_Sum_Assured
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID
group by c.Customer_ID 
order by sum(fct.Sum_Assured_INR_Coverage_Amount) desc

-- 57.	Top customers by premium.
select top 5 c.customer_ID, sum(fct.Premium_Amount) as Total_Prem
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID
group by c.Customer_ID 
order by sum(fct.Premium_Amount) desc

-- 58.	Top regions by business.
select rm.Region, sum(fct.Premium_Amount) as Total_Prem
from [dbo].[FCT.Insurance_Policy_Table] fct
left join [dbo].[DM.Regional_Manager] rm
on fct.RM_ID = rm.Regional_Manager_ID
group by rm.Region
order by sum(fct.Premium_Amount) desc;

-- 59.	Top policy plans.
select Policy_Code, Sum(Premium_Amount) as Total_Prem, count(Policy_Number) as Total_Policies
from [dbo].[FCT.Insurance_Policy_Table]
group by Policy_Code
order by Sum(Premium_Amount), count(Policy_Number) desc

-- 60.	Top managers by premium.
select Zonal_Manager_ID, Sum(Premium_Amount) as Total_Prem
from [dbo].[FCT.Insurance_Policy_Table]
group by Zonal_Manager_ID
order by Sum(Premium_Amount) desc
-- _______________________________________________________________________________________________________________________________
-- SECTION 4 - JOINS (61-90)

-- Fact + Customer

-- 61.	Customer name with policy details.
select c.customer_ID, c.Policy_Holder_Name, fct.*
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID

-- 62.	Customer age with premium amount.
select c.customer_ID, c.Policy_Holder_Name, c.Age_at_Entry, fct.Premium_Amount
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID

-- 63.	Customer occupation with policy status.
select c.customer_ID, c.Policy_Holder_Name, c.Occupation, fct.Policy_Status
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID

-- 64.	Smoker vs premium analysis.
select c.Smoker_Status, sum(fct.Premium_Amount)
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID
group by c.Smoker_Status;

-- 65.	State-wise customer policy details.
select c.*, fct.State
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Customer_Detail_Table] c
on fct.Customer_ID = c.Customer_ID
-- __________________________________________________
-- Fact + Agent

-- 66.	Agent name with policy sold.
select distinct a.Sales_Agent, fct.Policy_Code
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Insurance_Agent_Table] a
on fct.Sales_Agent_Code = a.Agent_Code

-- 67.	Agent-wise premium collected.
select a.Sales_Agent, Sum(fct.Premium_Amount) Total_Prem
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Insurance_Agent_Table] a
on fct.Sales_Agent_Code = a.Agent_Code
group by a.Sales_Agent;

-- 68.	Agent-wise policies sold.
select a.Sales_Agent, count(fct.Policy_Number) Total_Policies
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Insurance_Agent_Table] a
on fct.Sales_Agent_Code = a.Agent_Code
group by a.Sales_Agent;

-- 69.	Agent-wise active policies.
select a.Sales_Agent, count(fct.Policy_Number) Total_Active_Policies
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Insurance_Agent_Table] a
on fct.Sales_Agent_Code = a.Agent_Code 
where fct.Policy_Status = 'Active'
group by a.Sales_Agent

-- 70.	Agent-wise claim count.
select a.Sales_Agent, count(fct.Claim_ID) Total_Claims
from [dbo].[FCT.Insurance_Policy_Table] fct
left Join [dbo].[DM.Insurance_Agent_Table] a
on fct.Sales_Agent_Code = a.Agent_Code 
group by a.Sales_Agent;

--__________________________________________________
-- Fact + Policy Type

-- 71.	Policy type with premium.
select pt.Policy_Type, fct.Premium_Amount 
from [dbo].[FCT.Insurance_Policy_Table] fct
left join [dbo].[DM.Policy_Type] pt
on fct.Policy_Type_Code = pt.Policy_Type_Code

-- 72.	Policy type with average premium.
select pt.Policy_Type, avg(fct.Premium_Amount) Avg_Prem 
from [dbo].[FCT.Insurance_Policy_Table] fct
left join [dbo].[DM.Policy_Type] pt
on fct.Policy_Type_Code = pt.Policy_Type_Code
group by pt.Policy_Type

-- 73.	Policy type with total policies.


-- 74.	Policy type with claim count.


-- 75.	Policy type with average tenure.


________________________________________
Fact + Policy Plan
76.	Policy plan with premium.
77.	Policy plan performance.
78.	Policy plan with highest claims.
79.	Policy plan with highest premium.
80.	Policy plan-wise active policies.
________________________________________
Fact + Regional Manager
81.	Regional manager premium summary.
82.	Regional manager policy count.
83.	Regional manager active policies.
84.	Regional manager claim summary.
85.	Regional manager state performance.
________________________________________
Multi-table Join
86.	Customer + Agent + Policy Type.
87.	Customer + Agent + RM.
88.	Customer + Policy Plan + Agent.
89.	Customer + Policy Type + RM.
90.	Complete insurance reporting dataset.
________________________________________
SECTION 5 - SUBQUERIES (91-110)
91.	Customer with highest premium.
92.	Customer with second highest premium.
93.	Agent with highest premium.
94.	Policy type with highest premium.
95.	State with highest premium.
96.	Customers above average premium.
97.	Agents above average sales.
98.	States above average premium.
99.	Policy types above average premium.
100.	Customers above average sum assured.
101.	Policy with maximum tenure.
102.	Customer owning maximum policies.
103.	Agent selling maximum policies.
104.	RM managing maximum premium.
105.	Policy type generating maximum revenue.
106.	Customers without claims.
107.	Agents without sales.
108.	States without claims.
109.	Policy types without claims.
110.	Customers without loan eligibility.
________________________________________
SECTION 6 - CTE QUESTIONS (111-130)
111.	Top premium customers.
112.	Top premium agents.
113.	Monthly premium summary.
114.	Quarterly premium summary.
115.	State premium summary.
116.	Claim summary by state.
117.	Policy status summary.
118.	Policy type summary.
119.	Customer age segmentation.
120.	Occupation premium analysis.
121.	Top 10 customers.
122.	Top 10 agents.
123.	Top 10 states.
124.	Top 10 policy plans.
125.	Top 10 policy types.
126.	RM performance dashboard.
127.	Zonal manager dashboard.
128.	Insurance KPI dashboard.
129.	Premium trend dashboard.
130.	Claims dashboard.
________________________________________
SECTION 7 - WINDOW FUNCTIONS (131-160)
131.	Rank customers by premium.
132.	Rank agents by premium.
133.	Rank states by premium.
134.	Rank policy types by premium.
135.	Rank managers by premium.
136.	Dense rank customers.
137.	Dense rank agents.
138.	Dense rank states.
139.	Dense rank plans.
140.	Dense rank policy types.
141.	Top 3 customers per state.
142.	Top 3 agents per state.
143.	Top 3 plans per region.
144.	Top 3 policy types per state.
145.	Top 3 occupations per premium.
146.	Running premium total.
147.	Running claim count.
148.	Running policy count.
149.	Running customer count.
150.	Running sum assured.
151.	Previous month's premium.
152.	Next month's premium.
153.	Premium growth month over month.
154.	Premium growth quarter over quarter.
155.	Premium growth year over year.
156.	First policy per customer.
157.	Latest policy per customer.
158.	First policy per agent.
159.	Latest policy per agent.
160.	First policy per state.
________________________________________
SECTION 8 - CASE WHEN (161-180)
161.	Categorize premium:
•	Low (<10K)
•	Medium (10K-50K)
•	High (>50K)
162.	Categorize age groups:
•	Young
•	Adult
•	Senior
163.	Categorize tenure.
164.	Categorize claim risk.
165.	Categorize sum assured.
166.	Premium risk category.
167.	Loan eligibility category.
168.	Smoker risk category.
169.	Customer segment.
170.	Policy value segment.
171.	Create KPI flag.
172.	Create claim flag.
173.	Create retention flag.
174.	Create renewal flag.
175.	Create high-value customer flag.
176.	Agent performance flag.
177.	RM performance flag.
178.	State performance flag.
179.	Policy type performance flag.
180.	Customer loyalty flag.
________________________________________
SECTION 9 - DATE FUNCTIONS (181-210)
181.	Policies purchased this month.
182.	Policies purchased last month.
183.	Policies purchased this year.
184.	Policies purchased last year.
185.	Policies expiring this month.
186.	Policies with anniversary today.
187.	Policies with anniversary next month.
188.	Customers completing 5 years.
189.	Policies older than 10 years.
190.	Customers older than 60.
191.	Monthly premium trend.
192.	Quarterly premium trend.
193.	Yearly premium trend.
194.	Monthly policy count.
195.	Quarterly policy count.
196.	Average days since purchase.
197.	Average tenure.
198.	Oldest policy.
199.	Newest policy.
200.	Premium trend by year.
________________________________________
SECTION 10 - DATA VALIDATION & RECONCILIATION (MOST IMPORTANT FOR YOUR EXPERIENCE)
201.	Find duplicate Policy Numbers.
202.	Find duplicate Claim IDs.
203.	Find duplicate Customer IDs in fact.
204.	Find policies without customers.
205.	Find policies without agents.
206.	Find invalid Policy Type Codes.
207.	Find invalid Policy Codes.
208.	Find invalid RM IDs.
209.	Find invalid Zonal Manager IDs.
210.	Find policies with NULL premium.
211.	Find policies with negative premium.
212.	Find policies with negative sum assured.
213.	Find future purchase dates.
214.	Find invalid anniversary dates.
215.	Find policies with tenure mismatch.
216.	Reconcile premium by state.
217.	Reconcile policy count by state.
218.	Reconcile policy count by agent.
219.	Reconcile policy count by RM.
220.	Reconcile claim count by policy type.
________________________________________
SECTION 11 - REAL INTERVIEW SCENARIOS (221-250)
These are exactly the kind of questions senior interviewers ask.
221.	Find customers holding multiple policy types.
222.	Find customers whose premium increased year over year.
223.	Find customers with both active and lapsed policies.
224.	Find agents who sold policies in every quarter.
225.	Find top-performing agent in each state.
226.	Find state contributing highest premium.
227.	Find policy type contributing highest revenue.
228.	Find region contributing highest revenue.
229.	Find manager contributing highest premium.
230.	Find customer contributing highest premium.
231.	Find customers who never claimed.
232.	Find customers with multiple claims.
233.	Find policy plans with highest claim ratio.
234.	Find states with highest claim ratio.
235.	Find agents with highest claim ratio.
236.	Find month with highest premium.
237.	Find quarter with highest premium.
238.	Find year with highest premium.
239.	Find payment frequency with highest revenue.
240.	Find occupation contributing highest premium.
241.	Build an executive premium dashboard dataset.
242.	Build an RM performance dataset.
243.	Build an agent scorecard dataset.
244.	Build a customer retention dataset.
245.	Build a claim monitoring dataset.
246.	Design a star schema using this data.
247.	Identify fact and dimension tables.
248.	Explain grain of fact table.
249.	Explain slowly changing dimensions.
250.	How would you optimize a dashboard built on this dataset?
