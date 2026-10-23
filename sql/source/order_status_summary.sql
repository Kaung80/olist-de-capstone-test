select * from customers c limit 10

select customer_state, count(*) as customer_count
from raw.customers c 
group by c.customer_state 
order by c.customer_state 
limit 5;

select count(distinct c.customer_unique_id ) as real_customer_count
from raw.customers c;

select * from order_payments op  limit 10;

select payment_type,count(*) payment, SUM(op.payment_value) as total_payment_value
from raw.order_payments op
group by payment_type;


select * from order_reviews t ;

select review_score, count(*) as review_count
from order_reviews t 
group by review_score;

select AVG(t.review_score) as overall_average_score 
from order_reviews t ;

select * from sellers s;

select seller_state, count(*) as seller_count
from sellers s 
group by s.seller_state 
having count(*) > 50;

select * from order_items oi ;

select round(AVG(oi.price ),2) as average_price, round(AVG(oi.freight_value),2) as average_freight
from order_items oi ;