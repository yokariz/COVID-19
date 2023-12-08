select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2

--totaldeaths vs totalcases
--shows the likelihood of dying if you cantracted covid in your country
select location,date,total_cases,total_deaths,population,total_deaths/total_cases * 100 as DeathPercentage
from CovidDeaths
where location like '%states%'
order by 1,2

--totalcases vs population
--shows what percentage of the population got infected in your country
select location,date,population,total_cases,(total_cases/population) * 100 as InfectionPercentage
from CovidDeaths
where location like '%France%'
order by 1,2

--looking at countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestInfectioCount, max((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths
group by location,population
order by PercentagePopulationInfected desc

--showing countries with Highest number of deaths
select location, Max(convert(int,Total_deaths )) as Totaldeathcount
from CovidDeaths
where continent is not null
group by location
order by Totaldeathcount desc

--NOW LET'S BREAK DOWN THINGS BY CONTINENT
select continent, Max(cast(Total_deaths as int)) as Totaldeathcount
from CovidDeaths
where continent is not null
group by continent
order by Totaldeathcount desc

--showing coninents with highest death count per population
select continent, Max(cast(Total_deaths as int)) as Totaldeathcount
from CovidDeaths
where continent is not null
group by continent
order by Totaldeathcount desc

-- GLOBAL NUMBERS
select date,sum(new_cases) as Totalcases, sum(cast(new_deaths as int)) as Totaldeaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2 desc

--WORLDWIDE 
select sum(new_cases) as Totalcases, sum(cast(new_deaths as int)) as Totaldeaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from CovidDeaths
where continent is not null
order by 1,2 desc

--Looking total population vs Vaccination
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,sum(convert(int,new_vaccinations))
over(partition by dea.location order by dea.location,dea.date) as RollingPeoepleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3 

 --Looking total population vs Vaccination by percent using CTE
 with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeoepleVaccinated)
 as
 (
 SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,sum(convert(int,new_vaccinations))
over(partition by dea.location order by dea.location,dea.date) as RollingPeoepleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 )
 select * , (RollingPeoepleVaccinated/population)*100
    from PopvsVac

	--Looking total population vs Vaccination by percent using Temp-Table

	create table #PPV
	(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPeoepleVaccinated numeric
	)
	insert into #PPV
	SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,sum(convert(int,new_vaccinations))
over(partition by dea.location order by dea.location,dea.date) as RollingPeoepleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null

  select * , (RollingPeoepleVaccinated/population)*100
    from #PPV


--Creating view to store data for later visualization
create view Percentpopulationvaccinated as
SELECT dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,sum(convert(int,new_vaccinations))
over(partition by dea.location order by dea.location,dea.date) as RollingPeoepleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 

	













