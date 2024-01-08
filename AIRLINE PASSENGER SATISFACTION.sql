/* github file */

/* AIRLINE PASSENGER SATISFACTION ANALYSIS */

/* We are analysing coustomer satisfaction based on factors/attributes  */
 
-- Class
-- online booking
-- online boading
-- seating comfort
-- inflight service
-- baggage handling
-- leg room space
-- cleanliness
-- departure  delays
-- arival delays


-- (1) Total number of entries in each table 

select count(*) from airline_test;

select count(*) from airline_train;


-- (2) Percentage of satisfaction and dissatisfaction 

select 
satisfaction,
count(*) 
from airline_test
group by satisfaction;

select 
satisfaction,
count(*) 
from airline_train
group by satisfaction;


-- (3) Joining test and train dataset 

select * from airline_test
union all 
select * from airline_train;


/* OR COMBINE BOTH TABLES TEST AND TRAIN INTO AIRLINE_PASSEGERDATA TABLE IN EXCEL */


Select * from airline_passengerdata;


-- (1) CHECKING FOR SATISFACTION COUNT AMONG PASSENGERS

select 
satisfaction,
COUNT(*) satisfaction_count
from airline_passengerdata
group by satisfaction
order by satisfaction_count desc;


-- (2) BASED ON GENDER FIND THE SATISFACTION COUNT 

select 
gender,
satisfaction,
COUNT(*) as satisfaction_count
from airline_passengerdata
group by gender,satisfaction
order by satisfaction_count desc;


-- (3) FIND THE PERCENTAGE OF SATISFACTION BASED ON GENDER TYPE 

select 
gender,
count(case when satisfaction='satisfied' then 1 end)*100/count(*) as percentage_satisfied, 
count(case when satisfaction='neutral or dissatisfied' then 1 end)*100/count(*) as percentage_dissatisfied
from airline_passengerdata
GROUP BY gender;


-- (4) FIND THE RATE OF SATISFACTION BASED ON CUSTOMER TYPE 

select 
`customer type`, 
ROUND(count(case when satisfaction='satisfied' then 1 end)*100/count(*),2) as percentage_satisfied, 
ROUND(count(case when satisfaction='neutral or dissatisfied' then 1 end)*100/count(*),2) as percentage_dissatisfied
from airline_passengerdata
GROUP BY `customer type`;


-- (5) WHAT PERCENTAGE OF CUSTOMERS ARE LOYAL AND DISLOYAL 

select 
`customer type`,
Round(count(*) * 100 /(select count(*) from airline_passengerdata),2) as percentage_customers
from airline_passengerdata
group by `customer type`;


-- (6) WHAT IS THE AVERAGE FLIGHT DISTANCE BY TYPE OF TRAVEL 

select 
`type of travel`,
ROUND(AVG(`flight distance`),0)as avg_flight_distance
from airline_passengerdata
group by `type of travel`;


-- (7) FINDING THE RATE OF SATISFACTION BASED ON TYPE OF TRAVEL 

select 
`type of travel`,
count(case when satisfaction='satisfied' then 1 end)*100/count(*) as percentage_satisfied, 
count(case when satisfaction='neutral or dissatisfied' then 1 end)*100/count(*) as percentage_dissatisfied
from airline_passengerdata
GROUP BY `type of travel`;


-- (8) SATISFACTION RATE BASED ON CLASS OF COMFORT 

select 
class,
count(case when satisfaction='satisfied' then 1 end)*100/count(*) as percentage_satisfied, 
count(case when satisfaction='neutral or dissatisfied' then 1 end)*100/count(*) as percentage_dissatisfied
from airline_passengerdata
group by class
order by percentage_dissatisfied desc;


-- (9) DOES AGE PLAY A ROLE IN SATISFIED/DISSATISFIED RATE  

select 
case
    when age  between 0 and 25 then 'young'
	when  age between 26 and 45 then 'middle age'
	when age between 46 and 60 then 'old'
	else 'senior citizen'
	end as age_group,
    -- from airline_passengerdata
    -- group by age_group
count(case when satisfaction='satisfied' then 1 end)*100/count(*) as percentage_satisfied, 
count(case when satisfaction='neutral or dissatisfied' then 1 end)*100/count(*) as percentage_dissatisfied
from airline_passengerdata
group by age_group
order by percentage_satisfied ,percentage_dissatisfied DESC;


-- (10) AVERAGE RATING OF SEAT COMFORT W.R.T GENDER,CUSTOMER TYPE 

select 
Gender,
`customer type`,
Round(avg(`seat comfort`) ,2)as avg_seatcomfort_rating
from  airline_passengerdata
group by gender,`customer type`
order by avg_seatcomfort_rating desc;


-- (11) AVERAGE RATING OF SEAT COMFORT W.R.T CLASS 

select 
class,
Round(avg(`seat comfort`) ,2)as avg_seatcomfort_rating
from  airline_passengerdata
group by class
order by avg_seatcomfort_rating desc;


-- (12) WHAT'S THE AGE GROUP AND GENDER  WITH HIGGEST NUMBER OF TRAVELERS AND WHAT CLASS DO THEY USUALLY TRAVEL 

-- (a) FINDING THE AVG AGE OF CUSTOMERS IN EACH TRAVEL CLASS AND GENDER

select 
gender,
class,
ROUND(avg(age),2) 
from airline_passengerdata
group by class,gender
order by class;

-- (b)FIRST FINDING THE TOTAL NUMBER OF PASSENGERS TRAVELLING IN EACH AGE GROUP

select 
count(case when age<30 then 1 end )as young,
count(case when age between 31 and 50  then 1  end )as middle_age,
count(case when age between 51 and 65 then 1  end )as old_age,
count(case when age > 65 then 1  end) as senior_citizen
from airline_passengerdata;


-- (c) NOW FINDING WHICH CLASS DO EACH CATEGORY OF AGE GROUP PASSENGERS TRAVEL THE MOST

select 
class,
count(case when age <30 then 1 end )as young,
count(case when age between 31 and 50  then 1  end )as middle_age,
count(case when age between 51 and 65 then 1  end )as old_age,
count(case when age > 65 then 1  end) as senior_citizen
from airline_passengerdata
group by class;


-- (13) WHICH CLASS DOES THE HIGEST PASSENGER CATEGORY( MIDDLE-AGE) TRAVEL THE MOST 

select 
class, 
count( case  when age between 30 and 50 then 1  end ) as number_middle_age_travellers
from airline_passengerdata
group by  class 
order by  2 desc ;  

       
-- (14) WHAT IS THE AVERAGE SATISFACTION RATE SERVICES AVAILABLE W.R.T TO EACH CLASS THAT PASSENGERS TRAVEL

select 
class,
ROUND(AVG(`food and drink`),2) as avg_rating_meal_service,
ROUND(AVG(`seat comfort`),2) as avg_rating_seatcomfort,
ROUND(AVG(`inflight service`),2) as avg_rating_inflight_service,
ROUND(AVG(`cleanliness`),2) as avg_rating_cleanliness,
ROUND(AVG(`checkin service`),2) as avg_rating_checkin_service,
ROUND(AVG(`on-board service`),2) as avg_rating_onboard_service,
ROUND(AVG(`leg room service`),2) as avg_rating_legroom_service,
ROUND(AVG(`baggage handling`),2) as avg_rating_baggage_service,
ROUND(AVG(`flight distance`),2) as avg_flight_distance,
ROUND(AVG(`Inflight wifi service`),2) as avg_wifi_service,
ROUND(AVG(`Ease of Online booking`),2) as ease_online_booking
from airline_passengerdata
group by class
order by class;


-- (14a) THE ABOVE QUERY CAN ALSO BE RE-WRITTEN USING CASE STATEMENTS AS FOLLOWS

select 
      class,
	  AVG(case when `Inflight wifi service`=0 then null
          else `Inflight wifi service`
		  end)as avg_wifi_service,
      AVG(case when `Ease of Online booking`=0 then null
           else `Ease of Online booking`
           end)as avg_ease_online_booking ,
      AVG(case when `Inflight entertainment` =0 then null
           else `Inflight entertainment`
           end)as avg_inflight_entertainment,
      AVG(case when `Seat comfort` =0 then null
           else `Seat comfort`
		   end)as avg_seat_comfort,
      AVG(case when `Leg room service` =0 then null
           else `Leg room service`
           end)as avg_leg_room ,
      AVG(case when `Inflight service` =0 then null
           else `Inflight service`
           end)as avg_inflight_service ,
      AVG(case when Cleanliness =0 then null
           else Cleanliness
           end)as avg_cleanliness
from airline_passengerdata
group by class;
      
      
-- (15) HOW DOES THE SATISFACTION RATE VARY W.R.T CUSTOMER TYPE  AND DOES CLASS OF TRAVEL PLAY A ROLE IN THE RATING

select 
`customer type`,
class,
ROUND(count(case when satisfaction='satisfied' then 1 end)*100/count(*),2) as percentage_satisfied, 
ROUND(count(case when satisfaction='neutral or dissatisfied' then 1 end)*100/count(*),2) as percentage_dissatisfied
from airline_passengerdata
GROUP BY class,`customer type`
order by class ;


-- (16) DOES THE SATISFACTION RATE DEPEND ON THE DISTANCE TRAVELLED. IF YES THEN DOES IT ALSO DEPEND ON CLASS OF TRAVEL 

select 
class,
round(avg(`flight distance`),2) as avg_distance
from airline_passengerdata 
group by class
order by avg_distance desc;


select 
satisfaction,
class,
round(avg(`flight distance`),2) as avg_distance
from airline_passengerdata 
group by satisfaction,class
order by avg_distance desc;


-- (17) DOES  FLIGHT DISTANCE AFFECT CUSTOMER PREFERENCE OR FLIGHT PATTERN 

-- (a)finding the total number of short,mid,long distance travel passengers w.r.t class

select 
class,
-- max(`flight distance`),
-- min(`flight distance`),
count(case when `flight distance` between 0 and 1000  then 1 end) as short_range_distance,
count(case when `flight distance` between 1001 and 3000  then 1  end) as  mid_range_distance,
count(case when `flight distance`>=3000 then 1  end)as   long_distance
from airline_passengerdata 
group by class
order by class;


-- (b)further checking if  other factors contributing to satisfaction rating of people with respect to range of distance travelled

select 
class,
case
    when `flight distance` between 0 and 1000  then 'short_range_distance'
    when `flight distance` between 1001 and 3000  then 'mid_range_distance'
    else  'long_distance'
 end as flight_distance_range ,
ROUND(AVG(age),2) as avg_age,
ROUND(AVG(`food and drink`),2) as avg_rating_meal_service,
ROUND(AVG(`seat comfort`),2) as avg_rating_seatcomfort,
ROUND(AVG(`inflight service`),2) as avg_rating_inflight_service,
ROUND(AVG(`cleanliness`),2) as avg_rating_cleanliness,
ROUND(AVG(`checkin service`),2) as avg_rating_checkin_service,
ROUND(AVG(`on-board service`),2) as avg_rating_onboard_service,
ROUND(AVG(`leg room service`),2) as avg_rating_legroom_service,
ROUND(AVG(`baggage handling`),2) as avg_rating_baggage_service
from airline_passengerdata
group by flight_distance_range,class
order by class ,flight_distance_range;


-- (18) USING CTE TO FIND TOTAL NUMBER OF PASSENGERS IN EACH AGE GROUP AND
--     WHAT IS THE RATE OF PASSENGER SATISFACTION AMONG THOSE GROUPS 

WITH 
passengers_cte as (
select 
id,
age,
case
    when age  between 0 and 25 then 'young'
	when  age between 26 and 45 then 'middle age'
	when age between 46 and 60 then 'old'
	else 'senior citizen'
	end as age_group
from airline_passengerdata
),
passenger_satisfaction_cte as (
select 
id,
satisfaction
from airline_passengerdata
)
select 
age_group,
count(passengers_cte.id) as total_passengers,
sum(case when passenger_satisfaction_cte.satisfaction='satisfied' then 1 else 0 end) as total_satisfied_passengers
from passengers_cte
left join passenger_satisfaction_cte
using id
group by age_group;




