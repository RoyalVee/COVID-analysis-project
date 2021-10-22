-- Confirm data imported to SQL Sever
SELECT *
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NOT NULL
ORDER BY 3,4;

SELECT *
FROM [Portfolio Projects]..CovidVaccinations
ORDER BY 3,4;



-- SELECT the data to be used from death table
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Projects]..CovidDeath
ORDER BY 1,2;


-- Looking at the percentage of death 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 percentage_death
FROM [Portfolio Projects]..CovidDeath
ORDER BY 1,2;


-- Looking at the percantage of population that got COVID
SELECT location, date, total_cases, population, (total_cases/population)*100 percentage_of_population_withCOVID
FROM [Portfolio Projects]..CovidDeath
--WHERE location LIKE '%india%'
ORDER BY 1,2;


-- Looking out for the highest cases by countries
SELECT location, population, MAX(CAST(total_cases as int)) maxNumberOfCases
FROM [Portfolio Projects]..CovidDeath
WHERE location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
GROUP BY location, population
ORDER BY 3 DESC;

-- Looking out for the highest cases by countries
SELECT location, population, MAX(CAST(total_cases as int)) maxNumberOfCases
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 3 DESC;


-- Looking out for the highest cases by countries relative to their total population
SELECT location, population, MAX(CAST(total_cases as int)) maxNumberOfCases, MAX((total_cases/population)*100) highest_casesByPopulation
FROM [Portfolio Projects]..CovidDeath
WHERE location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
GROUP BY location, population
ORDER BY 4 DESC;

-- Looking out for the highest cases by countries relative to their total population
SELECT location, population, MAX(CAST(total_cases as int)) maxNumberOfCases, MAX((total_cases/population)*100) highest_casesByPopulation
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC;

-- Looking out for the highest death by countries
SELECT location, population, MAX(CAST(total_deaths as int)) maxNumberOfDeath
FROM [Portfolio Projects]..CovidDeath
WHERE location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
GROUP BY location, population
ORDER BY 3 DESC;


-- Looking out for the highest death by countries
SELECT location, population, MAX(CAST(total_deaths as int)) maxNumberOfDeath
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 3 DESC;

-- Looking out for the highest death by countries relative to their population
SELECT location, population, MAX(CAST(total_deaths as int)) maxNumberOfDeath, MAX((total_deaths/population)*100) percentageOfPopulationDead
FROM [Portfolio Projects]..CovidDeath
WHERE location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
GROUP BY location, population
ORDER BY 4 DESC;

-- Looking out for the highest death by countries relative to their population
SELECT location, population, MAX(CAST(total_deaths as int)) maxNumberOfDeath, MAX((total_deaths/population)*100) percentageOfPopulationDead
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 DESC;


-------------BY continent break down----------------------------


-- Looking out for the highest death by continent recorded
SELECT continent, MAX(CAST(total_deaths as int)) maxNumberOfDeath
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC;

-- the more accurate result for the highest death by continent recorded
SELECT location, MAX(CAST(total_deaths as int)) maxNumberOfDeath
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NULL
GROUP BY location
ORDER BY 2 DESC;




-- Global Numbers per Day
SELECT date, SUM(new_cases) Global_Total_Case_perDay, SUM(cast(new_deaths as int)) Global_Total_Deaths_perDay, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 percentage_WorldDeathPerDay
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date ASC;


-- Global Numbers cummulative
SELECT SUM(new_cases) Global_Total_Cases, SUM(cast(new_deaths as int)) Global_Total_Deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 percentage_WorldDeath
FROM [Portfolio Projects]..CovidDeath
WHERE continent IS NOT NULL;
--GROUP BY date
--ORDER BY date ASC



-- Looking at population vs vaccinations 

WITH locVac AS (SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
						SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date) RunningTotalVaccination
				FROM [Portfolio Projects]..CovidDeath dth
				JOIN [Portfolio Projects]..CovidVaccinations vac
						ON dth.location = vac.location 
						AND dth.date = vac.date
				WHERE dth.continent IS NOT NULL
)

SELECT *, (locVac.RunningTotalVaccination/locVac.population)*100 PercentageOfPopulationVaccinated
FROM locVac
--WHERE locVac.location LIKE 'United Sta%'
--ORDER BY 2,3


-- Create a temp table for the population vaccinated results 
DROP TABLE if exists #PercentagePopulactionVaccinated
CREATE TABLE #PercentagePopulactionVaccinated
(
continent nvarchar(255),
location nvarchar(255),
data datetime,
population numeric,
new_vaccinations numeric,
RunningTotalVaccination numeric,
);

--INSERT values into the temp table
INSERT INTO #PercentagePopulactionVaccinated
SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
						SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date) RunningTotalVaccination
				FROM [Portfolio Projects]..CovidDeath dth
				JOIN [Portfolio Projects]..CovidVaccinations vac
						ON dth.location = vac.location 
						AND dth.date = vac.date
				WHERE dth.continent IS NOT NULL;

-- Looking at Percentage Of Population Vaccinated from temp table
SELECT *, (ppv.RunningTotalVaccination/ppv.population)*100 PercentageOfPopulationVaccinated
FROM #PercentagePopulactionVaccinated ppv
ORDER BY 2,3;



-- Create View for Percentage Of Population Vaccinated from temp table
CREATE VIEW PercentageOfPopulationVaccinated AS 
SELECT dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
						SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date) RunningTotalVaccination
				FROM [Portfolio Projects]..CovidDeath dth
				JOIN [Portfolio Projects]..CovidVaccinations vac
						ON dth.location = vac.location 
						AND dth.date = vac.date
				WHERE dth.continent IS NOT NULL;
				--ORDER BY 2,3;
