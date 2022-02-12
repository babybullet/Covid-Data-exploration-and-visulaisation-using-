/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/
select * from [Covid Portf Project ]..coviddeath$

Select *
From [Covid Portf Project ]..coviddeath$
Where continent is not null 
order by 3,4 /* order by clause is used to keep column in ascending or descending order.*/


-- Selecting the data that to perform data exploration.

Select Location, date, total_cases, new_cases, total_deaths, population
From [Covid Portf Project ]..coviddeath$
Where continent is not null 
order by 1,2


-- Gathering Death Percentage from above data.

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage --as is known as Alias, to make a new column use alias.
From [Covid Portf Project ]..coviddeath$
Where location like '%states%' -- like claus is used to extract rows having something similar to the word provided in like operator.
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Showing percentage of population infected by Covid.

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From [Covid Portf Project ]..coviddeath$
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Portf Project ]..coviddeath$
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount -- cast is performed to change the datatype. in this case total death column is in nvarchar predefined
From [Covid Portf Project ]..coviddeath$
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- Data analysing in context of continent.

-- Showing contintents with the highest death count per population

Select continent, count(cast(Total_deaths as int)) as TotalDeathCount
From [Covid Portf Project ]..coviddeath$
Where continent is not null 
Group by continent -- group by clause is used to groups rows that have the same values into summary rows
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid Portf Project ]..coviddeath$
where continent is not null 
order by 1,2



-- Here i have performed join operation betwen the two tables to analyse further insights.

-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select (dea.continent), dea.location, dea.date, dea.population, vac.new_vaccinations --created an alias named dea and vac to get column from resp tables.
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [Covid Portf Project ]..coviddeath$ dea --We use SQL PARTITION BY to divide the result set into partitions and perform computation on each subset of partitioned data.
Join [Covid Portf Project ]..covidvaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


/*In SQL, a view is a virtual table based on the result-set of an SQL statement.

A view contains rows and columns, just like a real table. The fields in a view are fields from one or more real tables in the database.*/
 --Creating a view from covid death table
CREATE VIEW 
abc AS 
select continent, total_deaths
From [Covid Portf Project ]..coviddeath$
Where continent is not null 


 select * from abc where total_deaths is not null