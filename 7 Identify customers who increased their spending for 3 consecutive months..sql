# 7 Identify customers who increased their spending for 3 consecutive months.

with cte1 as (
SELECT 
	month(sale_date) as Month_,
    customer_id, 
	sum(total_amount) as This_month
from sales
GROUP BY customer_id , Month_),

cte2 as (
SELECT 
	Month_,
    customer_id, 																		
    lag(This_month,2) 
		over(PARTITION BY customer_id 
			ORDER BY MOnth_ ) 
				as Prev_month_2,
    lag(This_month,1) 
		OVER(PARTITION BY customer_id 
			ORDER BY MOnth_) 
				as Prev_month_1,
    This_month
from cte1)

select 
	*
from cte2
WHERE Prev_month_2 IS NOT NULL 
and This_month>Prev_month_1 and Prev_month_1>Prev_month_2
order by Month_;