
SELECT *
FROM CovidProject.coviddeaths
ORDER BY 3,4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject.coviddeaths
ORDER BY 1,2;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
FROM CovidProject.coviddeaths
WHERE location = "Indonesia"
ORDER BY 1,2;

SELECT location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
FROM CovidProject.coviddeaths
ORDER BY 1,2;

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) as InfectionPercentage
FROM CovidProject.coviddeaths
GROUP BY location, population
ORDER BY 1,2;

SELECT Location, MAX(CAST(total_deaths AS UNSIGNED)) as TotalDeathCount
FROM CovidProject.coviddeaths
WHERE  continent IS NOT NULL
	-- AND location = "Indonesia"
GROUP BY Location
ORDER BY TotalDeathCount DESC;

SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) as TotalDeathCount
FROM CovidProject.coviddeaths
WHERE continent IS NOT NULL 
	-- AND location = "Indonesia"
GROUP BY continent
ORDER BY TotalDeathCount DESC;

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as UNSIGNED)) as total_deaths, SUM(CAST(new_deaths as UNSIGNED))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject.coviddeaths
WHERE continent IS NOT NULL
	-- AND location = "Indonesia"
ORDER BY 1,2;

SELECT * FROM CovidProject.coviddeaths dea
JOIN CovidProject.covidvaccination vac
	ON dea.location = vac.location
		AND dea.date = vac.date;
        
Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as UNSIGNED)) as total_deaths, SUM(CAST(new_deaths as UNSIGNED))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject.coviddeaths
-- Where location = " Indonesia "
where continent is not null 
-- Group By date
order by 1,2;
        
SELECT dea.continent, dea.location, dea.date, dea.population, CAST(vac.new_vaccinations AS UNSIGNED)
FROM CovidProject.coviddeaths dea
JOIN CovidProject.covidvaccination vac
	ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
	-- AND dea.location = "Indonesia"
ORDER BY 5 DESC;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM CovidProject.coviddeaths dea
JOIN CovidProject.covidvaccination vac
	ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as UNSIGNED)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
FROM CovidProject.coviddeaths dea
JOIN CovidProject.covidvaccination vac
	ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3;
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;


CREATE TABLE PercentPopulationVaccinations
(
continent NVARCHAR (255),
location NVARCHAR (255),
date DATETIME,
population NUMERIC,
new_vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)
INSERT INTO PercentPopulationVaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM CovidProject.coviddeaths dea
JOIN CovidProject.covidvaccination vac
	ON dea.location = vac.location
		AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinations;

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
FROM CovidProject.coviddeaths dea
JOIN CovidProject.covidvaccination vac
	ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
-- ORDER BY 2,3

