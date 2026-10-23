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



