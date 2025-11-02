# 2 show revenue share by category per month, including percentage of total

WITH cte1 as (
SELECT 
	monthname(sl.sale_date) as Month_Name,
	pr.category as Category,
    month(sl.sale_date) as Month_No,
    sum(sl.quantity * pr.selling_price) as  revenue
from sales sl
join products pr
on sl.product_id = pr.product_id
GROUP BY Month_Name , Month_No , Category
order by Category,Month_No),

cte2 as (
SELECT *,
	 sum(revenue) over(PARTITION BY Month_No) as cumulative
FROM cte1)

select 
	Month_Name,Category,revenue,
    concat(round((revenue/cumulative)*100,2),"%") AS Pct_contibution,
    DENSE_RANK() OVER(PARTITION BY Month_No  ORDER BY revenue desc) as Monthly_Rank
from cte2 
order by Month_No ,Monthly_Rank, Pct_contibution, Category DESC;