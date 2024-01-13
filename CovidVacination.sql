-- Joining the two data together using location and date
Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
And dea.date = vac.date


--Looking At Total Population Vs Vacination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
And dea.date = vac.date
Where dea.continent is not null
Order by 2,3

  --2-
Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3

  
--Looking At Total Population Vs  Sum of newVacination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Running_Vaccination,
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
And dea.date = vac.date
Where dea.continent is not null
and dea.location = 'Albania'
Order by 2,3

-- USE CTE
WITH PopsvsVac ( continent, location, date, population, new_vaccination, Running_vaccination)
AS(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Running_Vaccination
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
And dea.date = vac.date
Where dea.continent is not null
)
Select * , (Running_vaccination/population)* 100 AS percentageVaccinated
From PopsvsVac
where location = 'Albania'


-- USING TEMP TABLE
--DROP Table if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
Running_vaccination Numeric
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Running_Vaccination
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
And dea.date = vac.date
Where dea.continent is not null
and dea.location = 'Albania'

Select * , (Running_vaccination/population)* 100 AS percentageVaccinated
From #PercentPopulationVaccinated



--Creating Views to store data for later visualizations
--Drop view if exists GlobalNumber

USE PortfolioProject
GO
Create view GlobalNumber AS
Select SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is  not null


--Drop view if exists PercentPopulationVaccinated

USE PortfolioProject
GO
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int))  OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS Running_Vaccination
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
And dea.date = vac.date
Where dea.continent is not null

