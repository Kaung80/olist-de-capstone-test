select * from orders o;
select * from customers c ;
select * from order_items oi  op ;

--question1
select c.customer_state, sum(oi.price) as revenue , o.order_status 
from orders o
inner join customers c on o.customer_id = c.customer_id 
inner join order_items oi  on o.order_id = oi.order_id 
where o.order_status = 'delivered'
group by c.customer_state, o.order_status 
order by revenue desc limit 10;

--question2
select * from orders o;
select * from order_reviews t ;

select count(*) as order_without_reviews
from orders o
left join order_reviews t on o.order_id = t.order_id
where t.order_id is null;


--question3
select * from products p ;
select * from order_items oi ;
select * from category_translation ct ;

select ct.product_category_name_english ,count(oi.order_item_id ) as items_sold from products p 
inner join order_items oi  on p.product_id=oi.product_id 
left join category_translation ct on p.product_category_name =ct.product_category_name 
group by ct.product_category_name_english 
order by items_sold desc limit 10;

--question4
select * from order_items oi ;
select * from sellers s ;
select * from customers c;
select * from orders o;

select round(100.0 * count( case when s.seller_state = c.customer_state then 1 end)/ count(*),2) as share
from order_items oi
inner join sellers s on oi.seller_id = s.seller_id 
inner join orders o on oi.order_id = o.order_id 
inner join customers c on o.customer_id = c.customer_id;

--question 5
select i.order_id, i.item_revenue, p.paid,
		p.paid - i.item_revenue as diff
from (select order_id, sum(price+freight_value) as item_revenue 
	from order_items oi group by order_id) i
join (select order_id, sum(payment_value) as paid
	from order_payments group by order_id) p
	on p.order_id = i.order_id
limit 5;

--question 6
select i.order_id, i.item_revenue, p.paid,
		p.paid - i.item_revenue as diff
from (select order_id, sum(price+freight_value) as item_revenue 
	from order_items oi group by order_id) i
join (select order_id, sum(payment_value) as paid
	from order_payments group by order_id) p
	on p.order_id = i.order_id
where p.paid - i.item_revenue > 1.00
order by diff desc;
