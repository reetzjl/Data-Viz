USE sakila;
#1A
select first_name, last_name from actor;

#1B
select upper(concat(first_name, ' ', last_name)) as `Actor Name`
from actor;

#2A
select actor_id, first_name, last_name
from actor
where first_name = "Joe";

#2B
select actor_id, first_name, last_name
from actor
where last_name like '%GEN%';

#2C
select actor_id, last_name, first_name
from actor
where last_name like '%LI%';

#2d
select country_id, country 
from country
where country in ('Afghanistan', 'Bangledesh', 'China');

#3A
alter table actor
add column description BLOB AFTER last_name;

# select * from actor

#3C
alter table actor
drop column description;

# select * from actor
#4A
select last_name, count(*) as 'Number of Actors' 
from actor group by last_name;

#4B
select last_name, count(*) as 'Number of Actors' 
from actor group by last_name having count(*) >=2;

#4C
update actor
set first_name = 'Groucho'
where first_name = 'Harpo' and last_name = "Williams";

# select first_name from actor
# where first_name = "Groucho";

#4D
update actor
set first_name = 'Harpo'
where first_name = 'Groucho' and last_name = "Williams";

#why is this not changing all the first names to Harpo????
#select first_name from actor
#where first_name in ("Harpo", "Groucho");

#5a
describe sakila.address;

# Select * from staff

#6A
select staff.first_name, staff.last_name, address.address
from address
join staff on
staff.address_id=address.address_id;

#6B
#Select * from payment

select staff.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
from payment
inner join staff on
staff.staff_id=payment.staff_id and payment_date like '2005-08%'
group by last_name;

#6C
SELECT film.title AS 'Film Title', COUNT(film_actor.actor_id) AS `Number of Actors`
from film_actor
inner join film on
film.film_id=film_actor.film_id
group by title;

#6D
select title, (
select count(*) from inventory
where film.film_id = inventory.film_id
) as 'Number of Copies'
from film
where title = "Hunchback Impossible";

#Select * from film
#6E
select customer.first_name, customer.last_name, sum(payment.amount) as `Total Paid`
from customer
join payment 
on customer.customer_id= payment.customer_id
group by customer.last_name;

#7A
select title
from film where title 
like 'K%' or title like 'Q%'
and title in 
(select title 
from film 
where language_id = 1
);

#7B
select first_name, last_name
from actor
where actor_id in
(Select actor_id
from film_actor
where film_id in 
(select film_id
from film
where title = 'Alone Trip'
));


#7C
#join name and email addresses and filter on canada country 
Select c.customer_id, first_name, last_name, email
from customer c 
join address a 
on (c.address_id=a.address_id) 
join city 
on (city.city_id=a.city_id) 
join country 
on (country.country_id=city.country_id)
where country.country = 'Canada';

#7D
select title, description from film
where film_id in (
select film_id from film_category
where category_id in
(select category_id from category
where name = "Family"
));

#7E
select f.title, count(rental_id) as 'Times Rented' 
from rental r
join inventory i 
on (r.inventory_id=i.inventory_id)
join film f
on (f.film_id=i.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

#7F
select s.store_id, sum(amount) as 'Revenue'
from payment p
join rental r
on (p.rental_id = r.rental_id)
join inventory i
on (i.inventory_id = r.inventory_id)
join store s
on (s.store_id = i.store_id)
group by s.store_id; 

#7G
select s.store_id, cty.city, country.country 
from store s
join address a 
on (s.address_id = a.address_id)
join city cty
on (cty.city_id = a.city_id)
join country
on (country.country_id = cty.country_id);

#7H
select c.name as 'Genre', sum(p.amount) as 'Gross' 
from category c
join film_category fc 
on (c.category_id=fc.category_id)
join inventory i 
on (fc.film_id=i.film_id)
join rental r 
on (i.inventory_id=r.inventory_id)
join payment p 
on (r.rental_id=p.rental_id)
group by c.name order by Gross  limit 5;

#8A
create view genre_revenue as
select c.name as 'Genre', sum(p.amount) as 'Gross' 
from category c
join film_category fc 
on (c.category_id=fc.category_id)
join inventory i 
on (fc.film_id=i.film_id)
join rental r 
on (i.inventory_id=r.inventory_id)
join payment p 
on (r.rental_id=p.rental_id)
group by c.name order by Gross  limit 5;

#8B
select * from genre_revenue;

#8C
drop view genre_revenue;


