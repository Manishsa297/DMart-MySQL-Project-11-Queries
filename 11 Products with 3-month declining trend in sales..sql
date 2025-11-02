#11 Products with 3-month declining trend in sales. 

with 
cte1 as 
(select 
	pr.product_id as Product_id,
    pr.product_name as Product_name,
    month(sl.sale_date) as Month_,
    sum(sl.total_amount) as This_Month_Sales 
from sales sl
join products pr
on sl.product_id = pr.product_id
GROUP BY Month_ , Product_name ,Product_id),

cte2 as(
	SELECT * , 
			lag(This_Month_Sales  , 1) over(PARTITION BY product_name order by Month_) 
				as Last_Month_Sales_1,
            lag(This_Month_Sales ,2) OVER(PARTITION BY product_name ORDER BY month_) 
				as Last_Month_Sales_2
	from cte1
	)
    
select Product_id,product_name,Month_,Last_Month_Sales_2,Last_Month_Sales_1,This_Month_Sales 
from cte2
where This_Month_Sales  < Last_Month_Sales_1 and Last_Month_Sales_1 < Last_Month_Sales_2
order by  Product_id,Month_;