# 8 Find profit margin variance across cities and rank them.
with cte1 as (
select 
	sl.store_id as Store_id,
    st.loaction as Loaction,
    st.store_name as Store_name,
	concat( 
		round( 
			(((sum(pr.selling_price) - sum(pr.cost_price)) / 
            sum(pr.cost_price))*100) ,2) ,"%") 
				as Profit_Margin
from products pr
join sales sl
on pr.product_id = sl.product_id
join stores st
on st.store_id = sl.store_id
GROUP BY Store_name,Store_id
)

SELECT 
	* ,
    Rank() OVER(ORDER BY Profit_Margin desc) as Ranking
from cte1
order by Ranking ;