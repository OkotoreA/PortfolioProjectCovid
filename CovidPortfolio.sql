Select * 
from dbo.CovidDeaths$
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population 
from dbo.CovidDeaths$ order by 1,2


-- looking at Total Cases vs Total Deaths
--- shows likelihood of dying from covid 19


Select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from dbo.CovidDeaths$ 
Where location like '%states%'
order by 1,2

--- looking at Total cases vs population 
Select Location, date, Population, total_cases,  (total_cases/Population) * 100 as DeathPercentage
from dbo.CovidDeaths$ 
Where location like '%states%'
order by 1,2

 
--- looking for countries with highest infection rate compared to population

 Select Location, Population,MAX (total_cases) as HighestInfectionCount, Max(total_cases/population) * 100 as PercentPopulationInfected
from dbo.CovidDeaths$ 
Where location like '%states%'
Group by Location, population
order by 1,2
Select Location, Population,MAX (total_cases) as HighestInfectionCount, Max(total_cases/population) * 100 as PercentPopulationInfected
from dbo.CovidDeaths$ 
--Where location like '%states%'
Group by Location, population
order by percentPopulationInfected desc

---showing countries with the highest death count per population

Select Location, MAX(cast(total_deaths as int)) as Total_DeathCount
from dbo.CovidDeaths$ 
--Where location like '%states%'
where continent is not null
Group by Location
order by Total_DeathCount desc


Select Location, MAX(cast(total_deaths as int)) as Total_DeathCount
from dbo.CovidDeaths$ 
--Where location like '%states%'
where continent is not null
Group by Location
order by Total_DeathCount desc

-- Break by continent 

Select continent, MAX(cast(total_deaths as int)) as Total_DeathCount
from dbo.CovidDeaths$ 
--Where location like '%states%'
where continent is not null
Group by continent
order by Total_DeathCount desc

--- showing continent with the highest death count per population 

--- Global Numbers

Select Sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,
sum(new_cases)*100 as DeathPercentage

From dbo.CovidDeaths$
where continent is not null
--group by date 
order by 1,2


Select date, Sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,
sum(new_cases)*100 as DeathPercentage

From dbo.CovidDeaths$
where continent is not null
group by date 
order by 1,2
----- looking at total population vs population 

 Select * from dbo.CovidDeaths$ dea
 Join dbo.CovidVaccinations$ vac
 on dea.date = vac.date
 ----
 Select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations 
 ,Sum(cast(vac.new_vaccinations as int)) OVER(Partition by dea.location)
 from dbo.CovidDeaths$ dea Join dbo.CovidVaccinations$ vac
 on dea.date = vac.date
 and dea.location= vac.location
 where dea.continent is not null
 order by 2,3
 --- use cte 


 ----
 with PopvsVac(Continent, location, Date, Population, new_Vaccination, RollingPeopleVaccinated) as 
 (
 ---
 ---Temp Table 
 Drop Table if exists #PercentPopulationVaccinated
  Create Table #PercentPopulationVaccinated (
 Continent nvarchar(255),
 location nvarchar(255),
 Date datetime, 
 population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric)
  
 Select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations 
 ,Sum(cast(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.Date)
 as RollingPeopleVaccinated 
 from dbo.CovidDeaths$ dea Join dbo.CovidVaccinations$ vac
 on dea.date = vac.date
 and dea.location= vac.location
 --where dea.continent is not null
 order by 2,3
 
 --Creating view for visualisation
 Create View PercentPopulationVaccination as
 Select dea.continent, dea. location, dea.date, dea.population, vac.new_vaccinations 
 ,Sum(cast(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.Date)
 as RollingPeopleVaccinated 
 from dbo.CovidDeaths$ dea Join dbo.CovidVaccinations$ vac
 on dea.date = vac.date
 and dea.location= vac.location
 where dea.continent is not null
 --order by 2,3

 Select * from PercentPopulationVaccination


