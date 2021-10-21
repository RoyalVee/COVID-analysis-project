/*looking out for countries and the highest death record between 2020-01-01 to 2021-10-20*/
WITH deaths AS (SELECT location, date, total_cases, new_cases, total_deaths, population
						FROM [Portfolio Projects]..CovidDeath
						)

SELECT deaths.location, MAX(deaths.total_deaths) death_count
FROM deaths
GROUP BY deaths.location
HAVING deaths.location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
ORDER BY MAX(deaths.total_deaths) DESC;

-- Looking at Total cases vs Total deaths 
SELECT location, date, total_cases, new_cases, total_deaths, population,
SUM(new_cases) OVER (PARTITION BY location ORDER BY date) Running_total_cases,
LAG(total_cases) OVER (PARTITION BY location ORDER BY date)
FROM [Portfolio Projects]..CovidDeath
GROUP BY location, date, total_cases, new_cases, total_deaths, population
ORDER BY 1,2;