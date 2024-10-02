Q1.Who is the most senior employee based on job?

select title,levels from employee
order by levels desc
limit 1;

Q2.Which countries have the most invoices?

select count(invoice_id)as count_invoice, billing_country from invoice
group by billing_country
order by count_invoice desc;

Q3.What are the top 3 values of invoice?

select total from invoice
order by total desc 
limit 3;

Q4.Which city has the best customers?

select billing_city,sum(total) as invoice_total from invoice
group by billing_city
order by invoice_total desc
limit 3;

Q5.Write a query to return the person who has spent the most money

select c.customer_id,c.first_name,c.last_name,sum(i.total) as total
from customer as c
join invoice as i
on c.customer_id = i.customer_id
group by c.customer_id
order by total desc
limit 1;

Q6.Write a query to return email,first_name,last_name of customer who only listened to rock albums
and return the list ordered alphabetically by email.

select * from customer ;
select * from invoice ;
select * from invoice_line;
select * from track;
select * from genre;
select * from artist;
select * from album;


select distinct email,first_name,last_name from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (select distinct track.track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock')
order by email;


Q7.Write a query to return artist names and total track counts of top 10 rock bands.

select artist.artist_id,artist.name,count(artist.artist_id) as no_of_songs 
from artist 
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by no_of_songs desc
limit 10;

Q8.

select avg(milliseconds) as song_length from track ;

select name,milliseconds from track
where milliseconds > (select avg(milliseconds) as song_length from track)
order by milliseconds desc;



select * from artist;
select * from customer;
select * from invoice;
select * from invoice_line;
select * from track where album_id = '186';
select * from album where artist_id = '51';
select * from artist where artist_id = '51';

Q9. Find How much amount has spent by each customer on artists?
Write a query to return customer_name,artist_name and total spent.

with best_selling_price as (
	select art.artist_id , art.name as artist_name,
	sum(il.unit_price*il.quantity) as total_sales
	from invoice_line as il
	join track as t on t.track_id = il.track_id
	join album as al on al.album_id = t.album_id
	join artist as art on art.artist_id = al.artist_id
	group by art.artist_id
	order by total_sales desc
	limit 1
)
select c.customer_id,c.first_name,c.last_name,bsp.artist_name,
sum(il.unit_price*il.quantity) as total_amount_spent
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album al on al.album_id = t.album_id
join best_selling_price bsp on bsp.artist_id = al.artist_id
group by 1,2,3,4
order by 5 desc;


select * from invoice;

Q. 10 Write a query that returns each country along with top genre.

with top_genre as (
	select customer.country,g.genre_id,g.name,count(invoice_line.quantity) as purchases,
	row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as row_no
	from invoice_line
	join invoice i on invoice_line.invoice_id = i.invoice_id
	join customer on customer.customer_id = i.customer_id
	join track t on invoice_line.track_id = t.track_id
	join genre g on t.genre_id = g.genre_id
	group by 1,2,3
	order by 1 asc , 4 desc
)
select * from top_genre where row_no <=1;



