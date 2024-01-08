/* GITHUB FILE--

/* COVID-19 DATA ANALYSIS */


select * 
from PortfolioProject.coviddeaths
order by 3,4;

select * 
from PortfolioProject.covidvaccinations
order by 3,4 ;


-- (1) Selecting data that we are workig with 

select 
location,
date,
population,
total_cases,
new_cases,
total_deaths
from PortfolioProject.coviddeaths
order by 1,2 ;


-- (2) Looking at total cases vs total deaths 

select 
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100
from PortfolioProject.coviddeaths
order by 1,2 ;


-- (3) Looking for particular location  being infected 
-- shows the likelyhood of dying if u get covid in particular country 

select 
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject.coviddeaths
where location like '%states%'
order by 1,2 ;


-- (4) Looking at total cases vs population or what perecentage of population are infected with covid 

select 
location,
date,
total_cases,
population,
(total_cases/population)*100 as percentpopulationinfected
from PortfolioProject.coviddeaths
-- where location like '%India%'
order by 1,2 ;


-- (5) Looking at countries with higgest infection rate w.r.t population 

select 
location,
population,
max(total_cases)as highestinfectioncount,
max(total_cases/(population))*100 as highestinfectedpopulation 
from PortfolioProject.coviddeaths
group by location,population
order by highestinfectedpopulation desc; 

-- order by highestinfectedpopulation to get countries with higest infected population 


-- (6) Looking at countries with highest death count per population

select 
location,
max(total_deaths) as totaldeathcount 
from PortfolioProject.coviddeaths
where continent is not null
group by location
order by totaldeathcount desc;


-- (7) Breaking things with respect to continent 

select 
continent,
max(total_deaths) as totaldeathcount
from PortfolioProject.coviddeaths
where continent is  not null
group by continent
order by totaldeathcount desc;


-- (8) Showing continents with highest death count per population 

select 
continent,
max(total_deaths) as totaldeathcount
from PortfolioProject.coviddeaths
where continent is  not null
group by continent
order by totaldeathcount desc;


-- (9) Global numbers 
-- if u want to look at global numbers w.r.t each day i.e date 

select 
date,
sum(new_cases) as total_cases,
sum(new_deaths) as total_deaths,
(sum(new_deaths)/sum(new_cases))*100 as deathpercentage
from PortfolioProject.coviddeaths
-- where location like '%states%'
where continent is not null
group by date
order by 1;


-- (10) If u want to look at global number in total and not per day/date 

select 
sum(new_cases) as total_cases,
sum(new_deaths) as total_deaths,
(sum(new_deaths)/sum(new_cases))*100 as deathpercentage
from PortfolioProject.coviddeaths
-- where location like '%states%'
where continent is not null
-- group by date
order by 2,3;


/* Using covidvaccinations table */

select * 
from PortfolioProject.covidvaccinations;


-- (11)Joining both coviddeaths and covidvaccinations table 
--     using inner join or just join

select * 
from PortfolioProject.coviddeaths dea
join  PortfolioProject.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date;


-- (12) Looking at total population vs vaccination in the world 

select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations 
from PortfolioProject.coviddeaths dea
join  PortfolioProject.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3;


 -- (13)Doing the rolling count to find the new_vaccinations count to add up as numbers go up  w.r.t date
 --     Using this to partition by or breaking it by date and location 
 --     we are partitioning by location as we want new_vaccination count to start over everytime it gets to new location
 
 select 
 dea.continent,
 dea.location,
 dea.date,
 dea.population,
 vac.new_vaccinations,
 sum(new_vaccinations) over (partition by dea.location) 
 from PortfolioProject.coviddeaths dea
 join  PortfolioProject.covidvaccinations vac
 on dea.location=vac.location
 and dea.date=vac.date
 where dea.continent is not null
 order by 2,3;
 
 -- the above will partition only by location to sum the total new_vaccination by location only i.e new numbers will show up 
 -- only if the new location changes
 
 
 -- (14) If the above  query has to rolling count everytime new numbers show up then we should order by both location and date
 --     we are partitioning by location as we want new_vaccination count to start over everytime it gets to new location
 
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(new_vaccinations) over (partition by dea.location order by dea.location, dea.date ) as rollingcountpeoplevaccinated
from PortfolioProject.coviddeaths dea
join  PortfolioProject.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3;
 
 
 -- (15) look at total rollingcountpeoplevaccinated w.r.t polupation.We cant directly use the column rollingpeople vaccinated 
 --      which is just created for calculation.So we create CTE(common table expression)/ Temp table 
 --      Using CTE here
 --      popvsvac is populationnvs vaccination and all columns in cte should be same as the below columns in select statement
 
 with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated) 
 as 
 (
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(new_vaccinations) over (partition by dea.location order by dea.location, dea.date ) as rollingpeoplevaccinated
from PortfolioProject.coviddeaths dea 
join  PortfolioProject.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
 -- order by 2,3
)
select * from popvsvac;


-- (16) Now we hv the cte table as above.lets do rollingpeoplevac w.r.t population
--      popvsvac is population vs vaccination and all columns in CTE should be same as the below columns in select statement

with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated) 
as 
(
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(new_vaccinations) over (partition by dea.location order by dea.location, dea.date ) as rollingpeoplevaccinated
from PortfolioProject.coviddeaths dea 
join  PortfolioProject.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
 -- order by 2,3
)
select *,(rollingpeoplevaccinated/population)*100 from popvsvac;


-- (17) Using TEMP table 

drop table if exist percentpopulationvaccinated;

create table percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)
insert into percentpopulationvaccinated
(
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(new_vaccinations) over (partition by dea.location order by dea.location, dea.date ) as rollingpeoplevaccinated
from PortfolioProject.coviddeaths dea 
join  PortfolioProject.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
 -- order by 2,3
 )
 select *,(rollingpeoplevaccinated/population)*100 from percentpopulationvaccinated;
 
 
 
-- (18) Creating views to store data for visualizations
 
create view percentpopulationvaccinated as
select 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
sum(new_vaccinations) over (partition by dea.location order by dea.location, dea.date ) as rollingpeoplevaccinated
from PortfolioProject.coviddeaths dea 
join  PortfolioProject.covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3;
 
 
-- (19) Quirying the view created above */
 
 select * from percentpopulationvaccinated ;
 
 
 





