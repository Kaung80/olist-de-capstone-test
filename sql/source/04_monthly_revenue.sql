--question 1
 with revenue as( 
 	select order_id, sum(price+freight_value) as revenue
 	from order_items oi
 	group by oi.order_id 
 ),
 payment as(
	select order_id, sum(payment_value) as paid
	from order_payments op 
	group by op.order_id 
 )
 select r.order_id, revenue, paid
 from revenue r
 left join payment p
 	on p.order_id = r.orderorder_id 
 limit 5;

--question3
select s.seller_id
from sellers s
where not exists ( 
	select 1
	from order_items oi 
	join order_reviews t on t.order_id = oi.order_id 
	where oi.seller_id = s.seller_id 
	and t.review_score = 1
);

--question4

with delivered_orders as(
	select o.order_id, date_trunc('month', o.order_purchase_timestamp) ::date as order_month 
	from orders o 
	where order_status = 'delivered'
),
order_revenue as ( 
	select order_id, SUM(payment_value) as revenue
	from order_payments op 
	group by op.order_id 
)

select d.order_month, count(*) as delivered_orders, round(sum(r.revenue), 2) as total_revenue
from delivered_orders d
join order_revenue r on r.order_id = d.order_id
group by d.order_month 
order by d.order_month;

--question 5
with category_monthly as(
	select 
		date_trunc('month',o.order_purchase_timestamp )::date as order_month,
		p.product_category_name as category,
		sum(oi.price) as revenue
	from orders o
	join order_items oi on oi.order_id = o.order_id 
	join products p on p.product_id = oi.product_id 
	where o.order_status = 'delivered'
	and p. product_category_name is not null
	group by 1,2
),
monthly_max as( 
	select order_month, max(revenue) as top_revenue
	from category_monthly 
	group by order_month
)
select cm.order_month ,cm.category , cm.revenue as category_revenue
from category_monthly cm
join monthly_max mm
on mm.order_month =cm.order_month 
and mm.top_revenue =cm.revenue 



