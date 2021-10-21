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
WHERE location LIKE '%india%'
ORDER BY 1,2;

