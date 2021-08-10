SELECT * FROM [PortfolioProject].[dbo].[covidData];

ALTER TABLE [dbo].[covidData]
ALTER COLUMN total_deaths Float;

ALTER TABLE [dbo].[covidData]
ALTER COLUMN new_deaths Float;


--Select the data that I am going to be using for analysis.

SELECT location, Date, total_cases, total_deaths, new_cases, population
FROM PortfolioProject.dbo.covidData;

--Total Cases vs Total Deaths

SELECT SUM(total_cases) AS total_cases, SUM(total_deaths) AS total_deaths
FROM PortfolioProject.dbo.covidData;

SELECT location , SUM(total_cases) AS totalCases, SUM(total_deaths) AS totalDeaths
FROM PortfolioProject.dbo.covidData
GROUP BY location;

SELECT location, date,  total_cases, total_deaths, (total_deaths/total_cases) * 100 As percentageDeaths
FROM PortfolioProject.dbo.covidData;


SELECT location, date,  total_cases, total_deaths, (total_deaths/total_cases) * 100 As percentageDeaths
FROM PortfolioProject.dbo.covidData
WHERE location = 'India';

--Total Cases vs Total Population

SELECT location, date, total_cases, population , (total_cases/population) * 100 AS percentagePopulation
FROM PortfolioProject.dbo.covidData;

-- Shows which Country has highest number of cases

SELECT location, SUM(total_cases) AS totalCases
FROM PortfolioProject.dbo.covidData
GROUP BY location
ORDER BY totalCases DESC ;


-- Shows which Country has highest death rates

SELECT location,  SUM(total_deaths) AS totalDeaths
FROM PortfolioProject.dbo.covidData
WHERE continent is not null
GROUP BY location
ORDER BY totalDeaths DESC;

SELECT date,location,population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfection
FROM PortfolioProject..covidData
GROUP BY location, population, date
ORDER BY PercentPopulationInfection DESC;



-- Which continent has highest death rate

SELECT continent, SUM(total_deaths) AS death_count
FROM PortfolioProject.dbo.covidData
WHERE continent is not null
GROUP BY continent
ORDER BY death_count DESC;

-- Global Numbers 

SELECT SUM(total_cases) AS global_cases, SUM(total_deaths) AS global_deaths, SUM(new_cases) AS global_new_cases,
        ROUND((SUM(total_deaths)/SUM(total_cases)),5) * 100 AS global_death_percentage
FROM PortfolioProject.dbo.covidData;

-- Shows at what time the death percentage out of new cases was the highest
SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
          ROUND((SUM(new_deaths)/ SUM(new_cases)) * 100,2) as death_percentage
FROM PortfolioProject.dbo.covidData
WHERE continent is not null
GROUP BY date
ORDER BY death_percentage DESC;


-- Total Population vs Vaccinated Population

SELECT date, location, population, new_vaccinations, ROUND((new_vaccinations/population) * 100,4) AS vaccinated_pop_percentage
FROM PortfolioProject..covidData
WHERE continent is not null
ORDER BY vaccinated_pop_percentage DESC;

SELECT location, date, total_vaccinations, population
FROM PortfolioProject..covidData
ORDER BY total_vaccinations DESC;

-- Shows Population that is fully vaccinated
SELECT location, date, population, people_vaccinated, people_fully_vaccinated, 
     ROUND((people_fully_vaccinated / population) *100,3) AS percentage_fully_vaccinated
FROM PortfolioProject..covidData
ORDER BY  percentage_fully_vaccinated , date;

-- Creating Views for later visualizations

CREATE VIEW global_numbers
AS
SELECT SUM(total_cases) AS global_cases, SUM(total_deaths) AS global_deaths, SUM(new_cases) AS global_new_cases,
        ROUND((SUM(total_deaths)/SUM(total_cases)),5) * 100 AS global_death_percentage
FROM PortfolioProject.dbo.covidData;


CREATE VIEW total_cases_vs_total_deaths
AS 
SELECT location , SUM(total_cases) AS totalCases, SUM(total_deaths) AS totalDeaths
FROM PortfolioProject.dbo.covidData
GROUP BY location;

CREATE VIEW total_cases_vs_total_pop
AS
SELECT location, date, total_cases, population , (total_cases/population) * 100 AS percentagePopulation
FROM PortfolioProject.dbo.covidData;

CREATE VIEW country_death_rate
AS
SELECT location,  SUM(total_deaths) AS totalDeaths
FROM PortfolioProject.dbo.covidData
WHERE continent is not null
GROUP BY location;

CREATE VIEW vaccinated_pop
AS
SELECT location, date, population, people_vaccinated, people_fully_vaccinated, 
     ROUND((people_fully_vaccinated / population) *100,3) AS percentage_fully_vaccinated
FROM PortfolioProject..covidData;
