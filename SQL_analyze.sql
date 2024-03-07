SELECT * 
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE location  like 'Algeria'
and continent is not null 
ORDER BY 1,2;

SELECT Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM dbo.CovidDeaths
ORDER BY 5 DESC,1;

SELECT Location, population, MAX(total_cases), MAX((total_cases / population)) * 100 AS HighestPopulationInfected
FROM dbo.CovidDeaths
GROUP BY location, population
ORDER BY HighestPopulationInfected DESC;

SELECT Location, population, MAX(CAST(total_deaths AS INT)) AS DeathCount
FROM dbo.CovidDeaths
WHERE continent is not null 
GROUP BY location,population
ORDER BY DeathCount;

WITH MaxCte AS (SELECT 
location, date, total_cases,total_deaths,(total_deaths/total_cases) * 100 as MAXDeathPercentage,
MAX((total_deaths/total_cases) * 100) OVER() AS Max_Ratio
FROM
	dbo.CovidDeaths
WHERE location = 'ALGERIA')
SELECT
	*
FROM
	MaxCte
WHERE
	MAXDeathPercentage = Max_Ratio;


SELECT continent, MAX(total_deaths / population) AS HighestDeathPopulations
FROM dbo.CovidDeaths
WHERE continent is not null 
GROUP BY continent
ORDER BY 1;

SELECT 
       continent, population, MAX(cast(Total_deaths as int)) AS Highest_DeathCount 
FROM 
       dbo.CovidDeaths
-- WHERE location ...
Where continent is not null 
GROUP BY continent, population
ORDER BY Highest_DeathCount desc;

SELECT continent, SUM(CAST(Total_Death_Count AS int)) AS total_deaths_for_continent
FROM (
    SELECT continent, MAX(Total_deaths) as Total_Death_Count
    FROM dbo.CovidDeaths
    WHERE continent IS NOT NULL
    GROUP BY continent

    UNION

    SELECT location AS continent, MAX(Total_deaths) as Total_Death_Count
    FROM dbo.CovidDeaths
    WHERE continent IS NULL
    GROUP BY location
) AS subquery
GROUP BY continent
ORDER BY total_deaths_for_continent DESC;


--Second Method 
WITH AggregatedDeaths AS (
    SELECT continent, MAX(Total_deaths) as Total_Death_Count
    FROM dbo.CovidDeaths
    WHERE continent IS NOT NULL
    GROUP BY continent

    UNION

    SELECT location AS continent, MAX(Total_deaths) as Total_Death_Count
    FROM dbo.CovidDeaths
    WHERE continent IS NULL
    GROUP BY location
)
SELECT continent, SUM(CAST(Total_Death_Count AS int)) AS total_deaths_for_continent
FROM AggregatedDeaths
GROUP BY continent
ORDER BY total_deaths_for_continent DESC;

WITH combined_results AS (
  SELECT
    location ,continent ,MAX(Total_deaths) as Total_Death_Count
  FROM
    dbo.CovidDeaths
  WHERE
    continent IS  NULL
  GROUP BY
    location, continent
)

SELECT c.location,r.continent ,SUM(COALESCE(r.Total_Death_Count, 0)) AS total_death_for_continent
FROM combined_results c
LEFT JOIN combined_results r ON c.location = r.continent
GROUP BY c.location , r.continent
ORDER BY total_death_for_continent DESC;


-- GLOBAL NUMBERS
SELECT SUM(new_cases) as Total_CASES, SUM(CAST(new_deaths as int)) AS TOTAL_DEATH, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE  continent is not null
ORDER BY 1,2;

