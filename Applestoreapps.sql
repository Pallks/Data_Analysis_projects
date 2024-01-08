/*    MOBILE APP STORE ANALYSIS :APPLE IOS APP STORE ANALYSIS   */


-- 2 Tables used for analysis
-- AppleStore.csv 
-- AppleStore_description.csv


/* EXPLORATORY DATA ANALYSIS (EDA) */

-- (1) Check for number of unique apps in both tables 

select count(distinct(id)) as unique_id
from applestore;

select count(distinct(id)) as unique_id
from applestore_description;


  -- (2) Check for missing values in key fields in both tables
 
 select 
 count(*) as missing_values
 from applestore
 where track_name is null 
 or user_rating is null 
 or prime_genre is null 
 or rating_count_tot is null 
 or ver is null; 
 
 
 select 
 count(*) as missing_values
 from applestore_description
 where track_name is null 
 or app_desc is null;
 
 
 
-- (3)Finding the popular genres/APP categories on IOS
-- Find number of Apps per genre/overview of types of distribution   

select 
prime_genre,
count(id) as popular_genres
from applestore
group by  prime_genre
order by popular_genres desc;


-- (4) Overview of  user app rating 

select 
Round(avg(user_rating),2) as avg_rating,
max(user_rating) as max_rating,
min(user_rating) as min_rating
from applestore;


-- (5) Find the distribution of app prices within each genre?

select 
prime_genre,
Round(AVG(price),2) AS avg_price,
MAX(price) AS max_price,
min(price) AS min_price
from applestore
group by prime_genre
order by 2 desc;


/*FINDING THE INSIGHTS FROM THE DATASET  */

-- (1) What are the most popular app categories

select 
prime_genre,
Round(avg(rating_count_tot),2) as avg_rating_count
from applestore
group by prime_genre
order by 2 desc;
 
-- (2)Which apps dominate more,are they based on genres,free or paid subscription
-- Are there certain genres where paid apps are more common or free apps dominate?

select 
prime_genre,
sum(case when price = 0 then 1 else 0 end) as num_free_apps,
sum(case when price > 0 then 1 else 0 end) as num_paid_apps
from applestore
group by prime_genre
order by 2 desc;


-- (3)Determine if paid apps have higher rating than free apps

select 
case 
    when price > 0 then 'paid_app'
	else 'free_app'
	end as App_type,
Round(avg(user_rating),2) as avg_rating
from applestore
group by App_type
order by avg_rating desc;


-- (4) Check if apps with more supported languages have higher rating--


select 
language_range,
Round(AVG(user_rating),2) as avg_user_rating 
from(select
	 case 
		when `lang.num`<10 then '<10 languages'
		when `lang.num` between 10 and 30 then '10-30 languages'
		else '>30 languages'
		end as num_supported_lang,
	  user_rating  
      from applestore 
      ) as  a
group by num_supported_lang 
order by avg_user_rating desc;


-- Other way of writing the above query

select 
Round(avg(user_rating),2) as avg_user_rating,
case
     when `lang.num`<10 then '<10 languages'
     when `lang.num` between 10 and 30 then '10-30 languages'
     else '>30 languages'
     end as num_supported_lang
from applestore
group by num_supported_lang
order by 1 desc;


-- (5) How does the average user rating of mobile apps vary across different genres?
   
select 
prime_genre,
Round(avg(user_rating),2) as avg_user_rating
from applestore
group by prime_genre
order by avg_user_rating desc;
   
   
-- (5a)check genres with low rating

select 
prime_genre,
Round(Avg(user_rating),2) as avg_user_rating
from applestore
group by prime_genre
order by avg_user_rating 
limit 10;

-- (6) what are the different app description length range
 
select 
  case
      when char_length(app_desc)<500 then 'short'
      when char_length(app_desc) between 500 and 1000 then 'medium'
      else 'long'
      end as app_desc_bracket
from applestore_description;


-- (7) What is the average app description length for each genre, and does it vary significantly?
--     result below is divided by 2.0 as “text” data is stored in a format that requires two bytes per character

select 
a.prime_genre as genre, 
Round(avg(CHAR_LENGTH(b.app_desc)) / 2.0,2) as avg_length_description
from applestore a
join applestore_description b
on a.id=b.id
group by prime_genre
order by 2 desc;
 
 
 -- (8)what is the corelation between the length  of the app description and the user rating

select 
app_desc_bracket,
Round(avg(user_rating),2)as avg_user_rating
from (
       select 
		case
            when char_length(app_desc)<500 then 'short'
             when char_length(app_desc) between 500 and 1000 then 'medium'
             else 'long'
             end as app_desc_bracket,
		a.user_rating 
		from applestore as a
		join applestore_description as b
		on a.id=b.id
        ) as subquery
  group by  app_desc_bracket 
  order by avg_user_rating desc;
      
      
-- (8a) other way of writing the above query

select 
case 
    when char_length(b.app_desc)<500 then 'short'
    when char_length(b.app_desc) between 500 and 1000 then 'medium'
    else 'long'
    end as app_desc_bracket,
Round(Avg(a.user_rating),2)as avg_user_rating   
from applestore a
join applestore_description b 
on a.id=b.id
group by app_desc_bracket
order by avg_user_rating desc; 


-- (9)check top rated apps for each category

select 
prime_genre,
track_name,
user_rating
from ( select 
	   prime_genre,
       track_name,
       user_rating,
       Rank() over (partition by prime_genre order by user_rating desc,rating_count_tot desc) as ranking
       from applestore
       ) as a
       where a.ranking=1;


-- (10)Do apps with more screenshots tend to have higher user ratings? 

select
Round(avg(user_rating),2)as avg_user_rating,
(`ipadSc_urls.num` )as number_screenshots
from applestore
group by `ipadSc_urls.num`
order by number_screenshots desc ;


-- (11)Correlationship between the content rating of an app and its user rating?

select 
cont_rating,
Round(avg(user_rating),2)as avg_user_rating,
count(*)as num_apps
from applestore
group by cont_rating
order by cont_rating; 
             
   
-- (12)Do apps with a higher number of supporting devices tend to have higher user ratings?

select 
`sup_devices.num`,
Round(avg(user_rating),2) as avg_user_rating
from applestore
group by `sup_devices.num`
order by `sup_devices.num` desc;


-- (13) Is there a correlation between the version code of an app and its user rating? Do more recent versions receive better ratings?

select 
ver,
Round(avg(user_rating),2) as avg_user_version_rating
from applestore
group by ver
order by ver desc;


-- (14) What are the names of the top 3 highest-rated apps in each genre?

select 
prime_genre,
ranking,
user_rating,
track_name,
rating_count_tot
from ( select
             prime_genre,
             track_name,
             rating_count_tot,
             user_rating,
             row_number() over ( 
                                 partition by prime_genre 
				 order by user_rating desc,rating_count_tot desc) as ranking
             from applestore) as subquery
     where ranking <= 3 ;   
     
     
-- (15) What is the distribution of app count by genre?

with app_genre_dist as (
select 
prime_genre,
count(id) as app_count,
(select count(id) from applestore)as total_count
from applestore
group by prime_genre
)
Select 
	prime_genre, 
	app_count,
	CONCAT(ROUND (100.0 * app_count / total_count, 2),'%')  as percentage
FROM app_genre_dist
ORDER BY 2 Desc, 3 Desc;


-- (16) What is the total user rating count of apps by genre?

select 
prime_genre,
sum(rating_count_tot)as total_user_rating_count,
rank() over (order by sum(rating_count_tot) desc)
from applestore 
group by prime_genre;


-- (17) What is the average user rating of apps across all categories and by genre?

select 
prime_genre,
Round(avg(user_rating),2) as avg_rating_user,
Rank() over ( order by avg(user_rating)desc)
from applestore
group by prime_genre;


-- (18) What is the content rating by count?

with cont_rating as (
select 
cont_rating,
count(cont_rating) as cont_rating_count,
(select count(cont_rating) from applestore )as total_cont_rating_count
from applestore
group by 1
order by 2
)
select 
cont_rating,
cont_rating_count,
concat(round(100*(cont_rating_count/total_cont_rating_count),2),'%') as percentage
from cont_rating
order by 2 desc,3 desc;


-- (19) What is the most common content rating of apps by genre?

with genre_content_rating as (
select 
prime_genre,
cont_rating,
count(cont_rating) as count_content_rating,
dense_rank() over (partition by prime_genre order by count(cont_rating) desc ) as ranking
from applestore
group by 1,2
)
select 
prime_genre,
cont_rating,
count_content_rating
from genre_content_rating
where ranking=1
order by 1;


-- (20) Similarly, what is the least common content rating of apps by genre?

with genre_content_rating as (
select 
prime_genre,
cont_rating,
count(cont_rating) as count_content_rating,
dense_rank() over (partition by prime_genre order by count(cont_rating)) as ranking
from applestore
group by 1,2
)
select 
prime_genre,
cont_rating,
count_content_rating
from genre_content_rating
where ranking=1
order by 1;


-- (21) What is the count and percentage of free and paid apps for all categories?

with per_categories as (
select
count(case when price=0 then 'free_app' end)as free_app_count,
count(case when price>0 then 'paid_app' end) as paid_app_count,
count(price) as total_count
from applestore
)
select 
free_app_count,
paid_app_count,
Concat(Round((free_app_count/total_count)*100,2),'%') as percent_free_app_count,
Concat(Round((paid_app_count/total_count)*100,2),'%') as percent_paid_app_count
from per_categories;


-- (22) What is the proportion of free and paid apps by genre

with proprotion_genre as (
select 
prime_genre,
count(case when price=0 then 'free_app' else null end)as free_app_count,
count(case when price>0 then 'paid_app' else null end) as paid_app_count,
count(price) as total_count
from applestore
group by prime_genre
)
select 
prime_genre,
free_app_count,
paid_app_count,
Concat(Round((free_app_count/total_count)*100,2),'%') as percent_free_app_count,
Concat(Round((paid_app_count/total_count)*100,2),'%') as percent_paid_app_count
from proprotion_genre;


-- (23) What is the distribution of apps by price?

with app_price as (
select 
price,
count(price) as app_price,
(select count(price) from applestore) as total_price
from applestore
group by price 
order by price
)
select 
price,
concat(Round((app_price/total_price)*100,2),'%') as percent_app_price
from app_price;


-- (24a) What is the most common app price by genre?

with app_price as (
select 
prime_genre,
price,
count(price) as price_count,
Dense_rank() over (partition by prime_genre order by count(price) desc ) as ranking
from applestore
group by 1,2
)
select 
prime_genre,
price,
price_count
from app_price
where ranking=1;


-- (24b) Similarly, what is the least common app price by genre?

with app_price as (
select 
prime_genre,
price,
count(price) as price_count,
Dense_rank() over (partition by prime_genre order by count(price) ) as ranking
from applestore
group by 1,2
)
select 
prime_genre,
price,
price_count
from app_price
where ranking=1;


-- (25) Which app is the most expensive and in what category?

select 
prime_genre,
price
from applestore
where price like (select max(price) from applestore);


-- (26) Which app has the most and least size bytes? 

select 
track_name,
prime_genre,
size_bytes
from applestore
where size_bytes=(select max(size_bytes) as max_size_bytes from applestore)
union all
select 
track_name,
prime_genre,
size_bytes
from applestore
where size_bytes=(select 
	          min(size_bytes) as minimum_size_bytes 
	          from applestore);



-- (27) What are the top 10 most expensive apps?

with app_price as (
select 
price,
track_name,
dense_rank() over ( order by price desc) as ranking 
from applestore
)
select 
track_name,
price
from app_price 
where ranking between 1 and 10;


-- (28) Among the top 10 most expensive apps, what is the genre count for the apps?

with app_genre as (
select
prime_genre, 
price,
track_name,
dense_rank()over(order by price desc) as ranking 
from applestore
),
top_genre as (
select
prime_genre, 
track_name,
price
from app_genre 
where ranking between 1 and 10
)
select 
prime_genre,
count(prime_genre) as count_genre 
from top_genre
group by 1
order by 2  desc;





 




       
