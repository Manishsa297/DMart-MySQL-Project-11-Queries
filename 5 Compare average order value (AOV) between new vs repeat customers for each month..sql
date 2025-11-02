# 5 Compare average order value (AOV) between new vs repeat customers for each month. 

with cte1 as (	
select 
	month(sl.sale_date) as Month_No,
    monthname(sl.sale_date) as Month_Name,
    sum((pr.selling_price*sl.quantity)/SL.quantity) as AOV_new
from sales sl 
join products pr
USING (product_id)
join customers cu
USING (customer_id)
WHERE month(cu.join_date) = month(sl.sale_date)
GROUP BY month(sl.sale_date),
    monthname(sl.sale_date)),
    
cte2 as (	
select 
	month(sl.sale_date) as Month_No,
    monthname(sl.sale_date) as Month_Name,
    sum((pr.selling_price*sl.quantity)/SL.quantity) as AOV_old
from sales sl 
join products pr
USING (product_id)
join customers cu
USING (customer_id)
WHERE month(cu.join_date) <> month(sl.sale_date)
GROUP BY month(sl.sale_date),
    monthname(sl.sale_date))
    
select 
	c1.Month_No as Month_No,
	c1.Month_Name as Month_Name,
    c1.AOV_new as AOV_new,
    c2.AOV_old as AOV_old,
    concat( round( (AOV_old - AOV_new)/AOV_old *100 ,2) ,"%" )as Dif_In_Pcr
from cte1 c1
join cte2 c2
USING(Month_No)
ORDER BY Month_No;
