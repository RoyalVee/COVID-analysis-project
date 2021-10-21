-- Confirm data imported to SQL Sever
SELECT *
FROM [Portfolio Projects]..CovidDeath
ORDER BY 3,4;

SELECT *
FROM [Portfolio Projects]..CovidVaccinations
ORDER BY 3,4;



-- SELECT the data to be used 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Projects]..CovidDeath
ORDER BY 1,2;

/*looking out for countries and the highest death record between 2020-01-01 to 2021-10-20*/
WITH deaths AS (SELECT location, date, total_cases, new_cases, total_deaths, population
						FROM [Portfolio Projects]..CovidDeath
						)

SELECT deaths.location, MAX(deaths.total_deaths) death_count
FROM deaths
GROUP BY deaths.location
HAVING deaths.location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
ORDER BY MAX(deaths.total_deaths) ASC;
