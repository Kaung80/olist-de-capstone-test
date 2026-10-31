--quesiton1 null audit

select 
	count(*) - count(p.product_category_name) as null_category_count,
	count(*) - count(p.product_weight_g) as null_weight_count
from products p ;

--question2 
with delivery as(
	select 
		date_trunc('month', order_purchase_timestamp)::date as purchase_month,
		date_part('day', order_delivered_customer_date-order_purchase_timestamp) as delivery_days
	from orders
	where order_status='delivered'
	and order_delivered_customer_date is not null
)
select 
	purchase_month, 
	round(avg(delivery_days)::numeric,1) as avgerage_delivery_days,
	count(*) filter(where delivery_days <= 30) as delivered_within_30days,
	round((100.00 * count(*) filter (where delivery_days <= 30)/ count(*))::numeric,1) as percent_within_30days
from delivery 
group by purchase_month 
order by purchase_month;

--question3
select extract(isodow from o.order_purchase_timestamp) as day_number,
	to_char(order_purchase_timestamp,'Day') as day_name,
	count(*) as total_orders
from orders o 
group by 1,2
order by total_orders desc;

--question 4
select 
	colaesce(t.product_category_name_english, p.product_category_name,'unknown') as category_name,
	rount(sum(oi.price),2) as total_revenue
from order_items oi 
join products p  on p.product_it=oi.product_id 
left join product_category_name_translation t
on t.producct_category_name=p.product_category_name 
group by 1
order by total_revenue desc;

--question 5

with delivery_buckets as( 
	select 
		order_id,
		case 
			when date_part('day',order_delivered_customer_date - order_purchase_timestamp) <= 7 then 'Fast(<=7 days)'
			when date_part('day',order_delivered_customer_date - order_purchase_timestamp) between 8 and 14 then 'Normal (8-14 days)'
			when date_part('day', order_delivered_customer_date - order_purchase_timestamp) between 15 and 30 then 'Slow(15-39 days)'
			else 'Very slow (>30 days)'
		end as delivery_tier
	from orders o 
	where order_status ='delivered'
	and order_delivered_customer_date is not null 
)
select 
	delivery_tier,
	count(*) as total_orders,
	round(100.0 * count(*)/sum(count(*)) over(), 1) as pct_of_total
from delivery_buckets 
group by delivery_tier 
order by total_orders desc;
