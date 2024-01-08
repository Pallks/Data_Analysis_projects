/* Github file */

/* Walamart data Analysis */


select * from walmartsalesdata;

-- (1) Creating new column to say what time of the day 

select 
time ,
(
case
when time between  "00:00:00" and  "12:00:00" then "Morning"
when time between  "12:00:00" and  "16:00:00" then "Afternoon"
else "Evening"
end
) as Time_of_day
from walmartsalesdata;


-- (1a) First create new column by name time_of_day then update the values obtained from running abv query 

ALTER TABLE walmartsalesdata
ADD column time_of_day varchar(255);


-- (1b) By default updates are not allowed in workbench so we set it to zero as below 
SET SQL_SAFE_UPDATES=0;


-- (1c) Now that new column is created update/insert the values into the column 

update walmartsalesdata
set time_of_day = ( 
case
when time between  "00:00:00" and  "12:00:00" then "Morning"
when time between  "12:00:00" and  "16:00:00" then "Afternoon"
else "Evening"
end
) ;


-- (2) Create new column day_name to see what day in a week is the busiest in each branch 
--     First convert the date format mm/dd/yyyy to YYYY-MM-DD format and update the table then extrat the dayname 

select date from walmartsalesdata;

Select 
STR_TO_DATE(date,'%m/%d/%Y') as date1
FROM walmartsalesdata;

Alter table walmartsalesdata
Add column date1 varchar(255);

update walmartsalesdata
set date1= STR_TO_DATE(date,'%m/%d/%Y');


-- (2a) After converting into yyyy-mm-dd format now get the dayname from date1 column 

SELECT 
DAYNAME(date1) as day_name
from walmartsalesdata;


-- (2b) Now create new column in table and update the values 

Alter table walmartsalesdata
Add column day_name varchar(255);

Update walmartsalesdata
set day_name= DAYNAME(date1);


-- (3) Extract the month name from date column to find which month of the year had higgest/lowest sales

Select 
date1,
MONTHNAME(date1)
from walmartsalesdata;

-- (3a) Add new column by name month_name to table 

Alter table walmartsalesdata
add column month_name varchar(255);

-- (3b) Update the values i.e months from date1 column into new column 

Update walmartsalesdata
set month_name=MONTHNAME(date1);

select * from walmartsalesdata;


-- (4) How many unique cities,branches are there

select 
count(distinct city,branch)
from walmartsalesdata;


-- (5) In which city is each branch

select 
distinct(city),
branch
from walmartsalesdata;
 
 
/* Product analysis */
 
 -- (6) How many unique product lines are there
 
 select 
 count(distinct(`product line`))
 from walmartsalesdata;
 
 
-- (7) what is most common payment method

select 
payment,
count(payment) 
from walmartsalesdata
group by payment;


-- (8) Most selling product line

select 
`product line`,
count( `product line`) as maxproduct
from walmartsalesdata
group by `product line`
order by maxproduct desc;
 
 
 -- (9) What is the total revenue by month
 
 select 
 month_name,
 sum(total) as totalrevenue 
 from walmartsalesdata
 group by month_name
 order by totalrevenue desc;
 
 
 -- (10) Which month has higest cogs
 
 select 
 month_name,
 sum(cogs) as maxcogs
 from walmartsalesdata
 group by month_name
 order by maxcogs desc;
 
 
-- (11) Which productline has the higest revenue 

select 
`product line`,
sum(total) as maxrevenue
from walmartsalesdata
group by `product line`
order by maxrevenue desc;


-- (12) City with higest revenue 

select 
city,
branch,
sum(total) as cityrevenue
from walmartsalesdata
group by city,branch
order by cityrevenue desc;


 -- (13) Product line with higest tax% 
 
select 
`product line`,
avg(`Tax 5%`) as avg_tax
from walmartsalesdata
group by `product line`
order by avg_tax desc;


-- (14) Which branch sold more products than average products sold on whole

select 
branch,
sum(quantity) as qnty
from walmartsalesdata
group by branch
having 
sum(quantity)> (select avg(quantity) from walmartsalesdata);


-- (15) What is the top product line by gender 
 
 select 
 gender,
 `product line`,
 count(gender) as totalcount
 from walmartsalesdata
 group by `product line`,gender
 order by totalcount desc
 -- limit 1;
 
 
-- (16) What is average rating of each product line. 

select 
`product line`,
Round( avg(rating),2) as avgrating
from walmartsalesdata
group by `product line`
order by  avgrating desc;


/* Sales analysis */

-- (17) Number of items sold at what time of day per day 
 
select 
count(quantity) as total_sales,
time_of_day
from walmartsalesdata
where day_name ="tuesday" /* can change weekdays to get values accordingly */
group by time_of_day
order by total_sales desc;


-- (18) Which customer types brings most revenue

select 
`customer type`,
sum(total) as totalrevenue
from walmartsalesdata
group by `customer type`
order by totalrevenue desc;


-- (19) which city has higest tax-percentage/VAT(value added tax)

select 
city,
avg(`tax 5%`) as tax_percentage 
from walmartsalesdata 
group by city
order by tax_percentage desc;


-- (20) Which customer type pays the most vat/tax

select 
`customer type`,
avg(`tax 5%`) as tax
from walmartsalesdata
group by `customer type`
order by tax desc;


/*  Customer info analysis */

-- (21) How many unique customer types do they have 

select 
distinct(`customer type`),
count(`customer type`)
from walmartsalesdata
group by `customer type`;


-- (22) How many unique payment type do they have 

select 
distinct(payment),
count(payment)
from walmartsalesdata
group by payment;


-- (23) most common customer type

select 
distinct(`customer type`),
count(`customer type`)
from walmartsalesdata
group by `customer type`
limit 1;


-- (24) Which type of customer buys the most goods

select 
`customer type`,
count(*) as customer_count
from walmartsalesdata
group by `customer type`;


-- (25) Which gender type are most customers

select 
gender,
count(`customer type`) as gender_count
from walmartsalesdata
group by gender
order by gender_count desc;


-- (26) What time of day customer gives most ratings per branch

select  
avg(rating),
time_of_day
from walmartsalesdata
where branch ='a'
group by time_of_day;


-- (27) What time of week do they hv best avg rating 

select 
day_name,
avg(rating) as avgrating 
from walmartsalesdata
-- where branch='a'
group by day_name
order by avgrating desc;



 

 
 

