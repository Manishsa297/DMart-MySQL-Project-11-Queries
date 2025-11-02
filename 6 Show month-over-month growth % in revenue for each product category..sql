# 6 Show month-over-month growth % in revenue for each product category.

WITH cte1 as (
select 
	pr.category as Category,
    month(sl.sale_date) as Month_no ,
    sum(pr.selling_price * sl.quantity) as Revenue
from products pr 
join sales sl
on pr.product_id = sl.product_id
GROUP BY Category , Month_no),

cte2 as (
select *,
		lag(Revenue,1) OVER(PARTITION BY Category ORDER BY Month_no ) 
			as Prev_month_revenue
from cte1)

SELECT 
	Category , 
    Month_no,
    Revenue,
	Prev_month_revenue,
	concat( 
		round( ((Revenue - Prev_month_revenue) 
			/ Prev_month_revenue)*100 ,2), "%")  
		as Changes_This
from cte2
WHERE Prev_month_revenue IS NOT NULL
order by Category ,Month_no;