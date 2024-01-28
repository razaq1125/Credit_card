-- 1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends.
select * from credit_card_transcations;

with cte as(
select city,sum(amount) as city_spend
from credit_card_transcations
group by city
order by city_spend desc)
select city,city_spend,(city_spend/(select sum(amount)  from credit_card_transcations)*100) as percentage_contribution
from cte
limit 5;


-- 2. write a query to print highest spend month and amount spent in that month for each card type.
select * from credit_card_transcations;
UPDATE credit_card_transcations
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%b-%y');



select card_type,year(transaction_date) yt,month(transaction_date) mt,sum(amount) as amount
from credit_card_transcations
group by card_type,yt,mt
order by mt,amount desc
limit 3;


with cte as (
select year(transaction_date) yt,month(transaction_date) mt,sum(amount) as amount
from credit_card_transcations
group by yt,mt
order by amount desc
limit 1)
select yt,mt,(select card_type from credit_card_transcations group by card_type) as cd,amount from cte
group by yt,mt,cd;


select card_type,year(transaction_date) yt,month(transaction_date) mt,sum(amount) as at
from credit_card_transcations 
group by card_type,yt,mt;

/* 3. write a query to print the transaction details(all columns from the table) for each card type when it 
reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type).*/

select * from credit_card_transcations;

with cte as (
select *,sum(amount) over(partition by card_type order by transaction_date,transaction_id) as cum_amount
from credit_card_transcations),
cte1 as (
select * , dense_rank() over(partition by card_type order by cum_amount) as ct
from cte
where cum_amount > 1000000
)
select * from cte1 
where ct =1;

-- 4. write a query to find city which had lowest percentage spend for gold card type.
select * from credit_card_transcations;
with cte as (
select city,card_type,sum(amount) as total_amount
from credit_card_transcations
where card_type = 'Gold'
group by city,card_type)
select *,(total_amount/(select sum(amount) from credit_card_transcations) *100) as Persentage
from cte
order by persentage asc
limit 1;

-- 5. write a query to print 3 columns: city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel).
select * from credit_card_transcations;

with cte as(
select city,exp_type,sum(amount) as total_amount
from credit_card_transcations
group by city,exp_type)
,cte2 as(
select *,dense_rank() over(partition by city order by total_amount) as drk_lowest,
dense_rank() over(partition by city order by total_amount desc) as higst
from cte)
select city,
max(case when drk_lowest =1 then exp_type end) as lowest_amount,
max(case when higst =1 then exp_type end) as highest_amount
from cte2
group by city;

-- 6. write a query to find percentage contribution of spends by females for each expense type.
select * from credit_card_transcations;

with cte as(
select exp_type,sum(amount) as amt
from credit_card_transcations
where gender = 'F'
group by exp_type)

select exp_type,(amt/ (select sum(amount) as amt
from credit_card_transcations
where gender = 'F')*100) as persentage
from cte;

-- 7. which card and expense type combination saw highest month over month growth in Jan-2014.
select * from credit_card_transcations;

with cte as(
select year(transaction_date) tra_year,month(transaction_date) tra_month,card_type,exp_type,
sum(amount) total_amt
from credit_card_transcations
group by tra_year,tra_month,card_type,exp_type),
cte2 as(
select * ,lag(total_amt) over(partition by card_type,exp_type order by tra_year,tra_month) as prv_trc
from cte)
select *,((total_amt-prv_trc)*100) as month_grow
from cte2
where tra_year = 2014 and tra_month =1
order by month_grow desc
limit 1;





-- 8. during weekends which city has highest total spend to total no of transcations ratio.

SELECT city,sum(amount)/count(1) as ratio
FROM credit_card_transcations
WHERE DAYOFWEEK(transaction_date) IN (1, 7)
group by city
order by ratio desc
limit 1;





-- 9. which city took least number of days to reach its 500th transaction after the first transaction in that city.
select * from credit_card_transcations;

select city,count(transaction_date) as dt
from credit_card_transcations
group by city
having dt > 500
order by dt asc
limit 1;











