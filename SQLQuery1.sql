--Select * 
--From PortfolioProject..CovidDeaths

Select * 
From PortfolioProject..CovidDeaths
order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using 
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at total cases vs total deaths 
-- the cast change and give them different datatypes 
-- the first one is an error
Select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100
From PortfolioProject..CovidDeaths
order by 1,2;

--likelihood to die in The Bahamas
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%bahamas%'
order by 1,2

--Total Cases vs Population 
--  percentage of population that got Covid
Select location, date, total_cases, population, (cast(total_cases as float)/cast(population as float))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%bahamas%'
order by 1,2

-- Countries with highest Infection Rate compared to population 
Select Location, Population, MAX(total_cases) As HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population 
Order by PercentPopulationInfected desc


-- location have things that should not be there World, High Income, Upper Income, Europe 

Select * 
From PortfolioProject..CovidDeaths
where continent is not null 
order by 3,4

--Countries with highest death count per population 
-- need to convert total deaths because the data type , will need to cast it 
Select location, MAX (cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null 
Group by location
Order by TotalDeathCount desc

-- By continent
Select continent, MAX (cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null 
Group by continent
Order by TotalDeathCount desc

--GLOBAL NUMBERS 
-- TOTAL CASES , TOTAL DEATHS AND DEATHPERCENTAGE 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases) * 100 as DeathPercentage 
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2 

-- join both datas 
-- total population vs vaccinations 
-- using the sum calculate how much people toke the vaccine 
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date = vac.date 
   where dea.continent is not null
   order by 2,3 

   --CTE
   -- BIGINT IS USED INSTEAD OF INT BECAUSE OF ERROR 
 With PopvsVac (continent, location, date, population, RollingPeopleVaccinated, new_vaccinations) AS
 (
 SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
 SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date = vac.date 
   where dea.continent is not null
   )
   Select * , (RollingPeopleVaccinated/population) * 100
   From PopvsVac


   --TEMP TABLE 
   CREATE TABLE #PercentPopulationVaccinated 
   (
   Continent nvarchar(255),
   Location nvarchar(255),
   Date datetime,
   Population numeric, 
   New_vaccinations numeric, 
   RollingPeopleVaccinated numeric
   )

   Insert into #PercentPopulationVaccinated
   SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
 SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date = vac.date 
   where dea.continent is not null
   

   Select * , (RollingPeopleVaccinated/population) * 100
   From #PercentPopulationVaccinated



   --create view to store data 

 CREATE VIEW  PercentPopulationVaccinated1 as
 SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
 SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date = vac.date 
   where dea.continent is not null

