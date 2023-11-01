--Selecting data to be used
select location,date, total_cases,new_cases,total_deaths,population
from CovidDeaths$

--Looking for total cases vs total deaths (Death Percentage)
--wrt location
select location,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths$
where location like 'Pakistan'

--Looking at Total cases vs Population in percentage 
--wrt location
select location,total_cases,population, (total_cases/population)*100 as CovidInfected_Population
from CovidDeaths$
where location like '%a'

--Looking at countires with highest Infection rate w.r.t Population
select location,population,max(total_cases) as Maximum_Cases, (max(total_cases/population))*100 as Maximum_Cases_Percentage 
from CovidDeaths$
--where location like 'India'
group by location,population
order by Maximum_Cases_Percentage desc

--Looking at countires with highest Deaths rate w.r.t Population
select location,population,max(cast(total_deaths as int)) as Maximum_Deaths, (max(total_deaths/population))*100 as Maximum_Death_Percentage 
from CovidDeaths$
where continent is not null
--where location like 'India'
group by location,population
order by Maximum_Death_Percentage desc

--Total of new Cases and new deaths
select location, sum(new_cases) as New_Covid_Cases,
sum(cast(new_deaths as int)) as New_Covid_Deaths  --cast is used in order to round of values for eg: float to int
from CovidDeaths$
group by location
order by location

--Joining deaths & vaccination based on location and date
select * from CovidDeaths$ as cd
join CovidVaccinations$ as cv
on cd.location  = cv.location and cd.date = cv.date


--Looking for  Population vs Vaccinations
select cd.continent,cd.population,cv.new_vaccinations
from CovidDeaths$ as cd
join CovidVaccinations$ as cv
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null


--Looking for Total Population vs  Vaccinations 
select cd.continent,sum(cd.population) as Total_Population,sum(cast(cv.new_vaccinations as int)) as New_Vaccinations
from CovidDeaths$ as cd
join CovidVaccinations$ as cv
on cd.location  = cv.location and cd.date = cv.date
where cd.continent is not null
group by cd.continent

--Cumulative sum of new vaccinations
--Temporary table to store the Cumulative sum Table
create table #temp_table
(
location nvarchar(255),
date datetime,
population  numeric,
continentcc nvarchar(255),
Cumulative_sum  numeric
)

insert into #temp_table
--with my_cte
--as(
select cd.location,cd.date,cd.population,cd.continent, 
sum(cast(cv.new_vaccinations as numeric)) over(order by cd.continent) as Cumulative_Vaccinations 
from CovidDeaths$ as cd
join CovidVaccinations$ as cv
on cd.location  = cv.location
where cd.location is not null  
group by cd.location,cd.date,cd.continent,cd.population, cv.new_vaccinations
having sum(cast(cv.new_vaccinations as int)) > 0
--order by 1,2,3
--)
select  *,(Cumulative_sum/population)*100 from #temp_table
--from  my_cte