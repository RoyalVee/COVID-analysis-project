-- Confirm data imported to SQL Sever
SELECT *
FROM [Portfolio Projects]..CovidDeath
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


-- Looking out for the highest cases by countries relative to their total population
SELECT location, population, MAX(CAST(total_cases as int)) maxNumberOfCases, MAX((total_cases/population)*100) highest_casesByPopulation
FROM [Portfolio Projects]..CovidDeath
WHERE location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
GROUP BY location, population
ORDER BY 4 DESC;

-- Looking out for the highest death by countries
SELECT location, population, MAX(CAST(total_deaths as int)) maxNumberOfDeath
FROM [Portfolio Projects]..CovidDeath
WHERE location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
GROUP BY location, population
ORDER BY 3 DESC;


-- Looking out for the highest death by countries relative to their population
SELECT location, population, MAX(CAST(total_deaths as int)) maxNumberOfDeath, MAX((total_deaths/population)*100) percentageOfPopulationDead
FROM [Portfolio Projects]..CovidDeath
WHERE location NOT IN ('Africa','Asia','Europe','North America','South America', 'Australia', 'Antarctica', 'World')
GROUP BY location, population
ORDER BY 4 DESC;

