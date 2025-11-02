# 10 Find products with 3-month continuous decline in sales quantity

with cte1 as (
select 
	pr.product_name as Product_Name,
    monthname(sl.sale_date) as Month_Name,
    month(sl.sale_date) as Month_,
    sl.product_id as Product_id,
    sum(sl.quantity) as This_Month_Quantity 
from sales sl
join products pr
USING (product_id )
GROUP BY Product_id,Month_,Month_Name
ORDER BY Product_id,Month_,Month_Name),

cte2 as (
select 
	*,
    lag (This_Month_Quantity,1) over(partition by Product_id order by Month_) 
		as prev_1_month_QT,
    lag(This_Month_Quantity , 2 ) over(PARTITION BY product_id order by Month_ ) 
		as prev_2_month_QT
    from cte1)
select  Month_Name,
		Product_id ,
        Product_Name,
        prev_2_month_QT,
        prev_1_month_QT,
        This_Month_Quantity 
from cte2
where 
	prev_2_month_QT is not null
    and This_Month_Quantity < prev_1_month_QT and prev_1_month_QT < prev_2_month_QT 
    and Month_ = month(now())
    ORDER BY Product_id;