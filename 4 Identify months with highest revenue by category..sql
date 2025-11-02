#4 Identify months with highest revenue by category.

with cte1 as (
SELECT 
	month(sl.sale_date) as Month_no,
    monthname(sl.sale_date) as Month_,
    pr.category as Category,
    sum(pr.selling_price * sl.quantity ) as Revenue 
from products pr
INNER join sales sl
	on pr.product_id = sl.product_id
group by  Month_no,Month_ , Category 
),

cte2 as (
select *,
	max(Revenue) over ( PARTITION BY Month_ )  as Highest_rev
from cte1
)

select 
	Month_,
    Category,
    Highest_rev
from cte2
where (Highest_rev = Revenue)
order by Month_no;
