/* MUSIC STORE DATA ANALYSIS */


-- (1) Based on job title who is the senior most employee 

select * 
from employee
order by levels desc
limit 1;


-- (2) Which country has most invoices

select 
billing_country,
count(*) as total_invoice
from invoice
group by billing_country
order by total_invoice desc
limit 1;


-- (3) What are the top3 values of total invoice

select total
from invoice
order by total desc
limit 3;
 
 
-- (4) Which city has best customers? 
--     If the city that makes most money will have music festival then find that city with highest sum of invoice total
--     Return both city name and sum of all invoices
 
select 
billing_city,
sum(total) as total_invoice
from invoice
group by billing_city
order by total_invoice desc
limit 1;


-- (5) Customer who spend the most money/invoice is declared as best customer find that customer 

select 
c.customer_id, 
c.first_name,
c.last_name,
sum(i.total) as total_invoice
from customer c
join invoice i 
on c.customer_id=i.customer_id
group by c.customer_id 
order by total_invoice desc;


-- (6) Write query to return the email,first name,last name,& Genre of all Rock Music listeners. 
--     Return list ordered asc by email 

select 
distinct(c.email),
c.first_name,
c.last_name
from customer c
join invoice i
on c.customer_id=i.customer_id
join invoice_line l
on i.invoice_id=l.invoice_id
join track t
on l.track_id=t.track_id
join genre g
on t.genre_id=g.genre_id
where g.name like 'Rock'
order by c.email asc;


-- we can write the above query using sub query as below 

select 
distinct(c.email),
c.first_name,
c.last_name
from customer c
join invoice i
on c.customer_id=i.customer_id
join invoice_line l
on i.invoice_id=l.invoice_id
where track_id in(
                select track_id from track
                 join genre g
		on track.genre_id=g.genre_id
	        where g.name like 'Rock'
                )
order by c.email asc;


-- (7) Invite artists with the most number of rock music albums in the dataset
--     Show artist name and total track count of top 10 rock bands

Select
artist.artist_id,
artist.name,
COUNT(artist.artist_id) AS number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by  number_of_songs DESC
limit 10;


-- (8) Return all track names with song length longer than average song length.
--     Return the name and milliseconds for each track
--     Order by song length with longest songs listed first

select 
name,
milliseconds 
from track
where milliseconds > (
select avg(milliseconds) as avg_song_length
from track
)
order by milliseconds desc;


-- (9) Find the amount spent by each customer on artists.
--     Write query to give the customer name,artist name,total spent
--     We use CTE to the solve the abv

WITH  best_selling_artist as (
select 
artist.artist_id as artist_id,artist.name as artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
from invoice_line
join track
on track.track_id=invoice_line.track_id
join album
on album.album_id=track.album_id
join artist
on artist.artist_id=album.artist_id
group by 1 
order by 3 desc
limit 1
)
select 
c.customer_id, 
c.first_name, 
c.last_name, 
bsa.artist_name, 
SUM(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c 
on c.customer_id = i.customer_id
join invoice_line il 
on il.invoice_id = i.invoice_id
join track t 
on t.track_id = il.track_id
join album alb 
on alb.album_id = t.album_id
join best_selling_artist bsa 
on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 DESC;


-- (10) We want to find the most popular music Genre for each country. 
--      We determine the most popular genre as the genre with the highest amount of purchases.
--      Write a query that returns each country along with the top Genre. 
--      For countries where the maximum number of purchases is shared return all Genres.

with popular_genre as 
(
select 
count(invoice_line.quantity) as purchases,
customer.country,genre.name,genre.genre_id,
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS Rowno 
from invoice_line 
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2 ASC, 1 DESC
)
Select * from popular_genre 
where Rowno <= 1;


--  The above query can also be written using recursive as below

with recursive
sales_per_country as(
select COUNT(*) as purchases_per_genre, 
customer.country, 
genre.name, 
genre.genre_id
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id
join customer on customer.customer_id = invoice.customer_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2
),
max_genre_per_country as(
select MAX(purchases_per_genre) AS max_genre_number, 
country
from sales_per_country
group by 2
order by 2
)
select sales_per_country. * 
from sales_per_country
join max_genre_per_country on sales_per_country.country = max_genre_per_country.country
where sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;


-- (11)  Write a query that determines the customer that has spent the most on music from each country
--       Write a query that returns the country along with the top customer and how much they spent
--       For countries where the top amount spent is shared, provide all customers who spent this amount

with recursive
             customer_with_country as (
             select customer.customer_id,
             customer.first_name,
             customer.last_name,
             customer.country,
             sum(invoice.total) as max_amount_spent
             from customer
             join invoice
             on customer.customer_id=invoice.customer_id
             group by customer.customer_id,customer.first_name,customer.last_name,customer.country
             order by max_amount_spent desc
             ),
			 country_max_spending as (
			 select customer_with_country.country,
             max(customer_with_country.max_amount_spent) as max_spending
			 from customer_with_country
             group by customer_with_country.country
             )
			 Select cc.country, 
             cc.max_amount_spent, 
             cc.first_name, 
             cc.last_name, 
		     cc.customer_id
             from customter_with_country cc
             join country_max_spending ms
             on cc.country = ms.country
             where cc.max_amount_spent = ms.max_spending
             order by cc.country;  
       
       
-- (11a) The above query can be written using CTE as below
       
with customer_with_country as (
select customer.customer_id,
customer.first_name,
customer.last_name,
customer.country,
sum(invoice.total) as max_amount_spent,
row_number() over( partition by customer.country order by sum(invoice.total) desc) as Rowno
from customer
join invoice
on customer.customer_id=invoice.customer_id
group by customer.customer_id,customer.first_name,customer.last_name,customer.country
order by max_amount_spent desc,customer.country asc
)
select * from customer_with_country where rowno <=1;      


  





