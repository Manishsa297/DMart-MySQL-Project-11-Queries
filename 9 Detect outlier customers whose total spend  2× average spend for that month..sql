# 9 Detect outlier customers whose total spend > 2× average spend for that month.

with cte1 as (
select 
	ct.customer_name as Customer_name,
    year(sale_date) as Year_,
    MONTH(sl.sale_date) AS Month_,
    sl.customer_id as Customer_id,
    sum(sl.total_amount) as Sales
from sales sl
join customers ct
USING(customer_id)
GROUP BY Customer_id,Year_,Month_),

cte2 as (
select 
	*,
    avg(Sales) OVER(PARTITION BY Year_ , Month_)  
		as Avg_yr_sales
    from cte1),

cte3 as (
select *,
		Avg_yr_sales*2 as Avg_yr_sales_2x
from cte2)

select 
	Month_,
    Customer_name,
    Customer_id,
    Sales,
    Avg_yr_sales
from cte3
WHERE Avg_yr_sales_2x < Sales
ORDER BY Sales DESC;