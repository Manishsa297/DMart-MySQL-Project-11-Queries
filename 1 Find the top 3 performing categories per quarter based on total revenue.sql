
# 1 -- Find the top 3 performing categories per quarter based on total revenue 

WITH cte1 as (
SELECT 
	pr.category as Category,
	sum((pr.selling_price * sl.quantity) ) as Total_Revenue,
    quarter(sl.sale_date) as Quarter_,
    YEAR(sl.sale_date) AS Year_
from products pr 
join sales sl 
on pr.product_id = sl.product_id 
GROUP BY Category , Quarter_  , Year_ )
,
cte2 as (
select 
	* ,
    DENSE_RANK() over(PARTITION BY Year_, Quarter_ ORDER BY Total_Revenue desc)  as Rank_
from cte1)

select 
	Category,Quarter_,Total_Revenue,Year_,Rank_ 
from cte2
where Rank_ < 4;