# 3 Identify top 10 customers by lifetime value (LTV) using all-time sales data 
 
 select 
	cu.customer_name,
    sl.customer_id , 
    sum(sl.total_amount) as Life_Time_Value
from sales sl
join customers cu
USING(customer_id)
GROUP BY sl.customer_id,cu.customer_name
order by Life_Time_Value desc
limit 10 ;