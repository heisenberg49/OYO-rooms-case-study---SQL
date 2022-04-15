create database oyo;
use oyo;
create table oyo_booking(
 booking_id	int,
 customer_id text,
 status	text,
 check_in text,
 check_out text,
 no_of_rooms int,
 hotel_id text,
 amount int,
 discount int,
 date_of_booking text
 );

 select * from oyo_booking; /* Table 1 */
  select * from oyo_city; /* Table 2 */
 
  /* no. of hotels in the data set */
  select count(distinct hotel_id) as `Total Hotels`
  from oyo_booking;
    /* no. of cities in the data set */
 select count(distinct city) as `Total city`
  from oyo_city;
/* no. of hotels by city */
select city,count(hotel_id) as `no. of hotels`
from oyo_city
group by city
order by `no. of hotels` desc;

-- changing dates to sql formate
alter table oyo_booking
add column newcheck_in date;
update oyo_booking
set  newcheck_in = str_to_date(substr(check_in,1,10),'%d-%m-%Y');
alter table oyo_booking
add column newcheck_out date;
update oyo_booking
set  newcheck_out = str_to_date(substr(check_out,1,10),'%d-%m-%Y');
alter table oyo_booking
add column newdate_of_booking date;
update oyo_booking
set  newdate_of_booking = str_to_date(substr(date_of_booking,1,10),'%d-%m-%Y');
-- addinng new column 'price'
alter table oyo_booking
add column price float;
update oyo_booking
set price = amount + discount;
-- adding new column 'no_of_nights'
alter table oyo_booking
add column no_of_nights int;
update oyo_booking
set no_of_nights = datediff(newcheck_out,newcheck_in);
-- adding rate column
alter table oyo_booking
add column rate float;
update oyo_booking
set rate = round(if(no_of_rooms =1,(price/no_of_nights),(price/no_of_nights)/no_of_rooms),2);

/* average room rate by city */
select b.hotel_id,city,round(avg(rate),2) as `avg rate per room`
from oyo_booking b
join oyo_city c
on b.hotel_id = c.hotel_id
group by city
order by 3 asc;

/* gross revenue */
select city, sum(amount) revenue 
from oyo_booking b
join oyo_city c
on b.hotel_id = c.hotel_id
where status = 'cancelled'
group by city
order by revenue desc;

select city,sum(amount) revenue 
from oyo_booking b
join oyo_city c
on b.hotel_id = c.hotel_id
group by city
order by revenue desc;



/* booking in january */
select count(booking_id),city,month(newdate_of_booking)
from oyo_booking ob, oyo_city oc
where month(newdate_of_booking) = 1 and ob.hotel_id = oc.hotel_id
group by city;

/* total booking by cities */
select count(booking_id),city
from oyo_booking ob join oyo_city oc
on ob.hotel_id = oc.hotel_id
group by city;

    




