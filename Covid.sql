-- Making sure data was loaded in correctly
SELECT * FROM dbo.CovidDeaths
ORDER BY 'location';

SELECT * FROM dbo.CovidVaccinations
ORDER BY 'location';


SELECT location, date, total_cases, new_cases, total_deaths, population FROM CovidDeaths
ORDER BY location;


-- Looking at total cases vs total deaths, showing how fatal the disease is
SELECT location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as DeathPercent FROM CovidDeaths
ORDER BY location;


-- Looking at Total Cases vs population
SELECT location, date, total_cases, population, ((total_cases/population)*100) as PercentInfected FROM CovidDeaths
ORDER BY location,date;

-- Finding what country has the highest infection rate compared to population
SELECT location, population, MAX(total_cases) as total_cases, (MAX(total_cases)/population)*100 as PercentInfected FROM CovidDeaths
GROUP BY Location, Population
ORDER BY PercentInfected DESC;

-- Andora has one of the highest percent infected at 17%, USA is 9 at 9.5 as of 05/2021

-- highest death per population
SELECT location, population, MAX(total_deaths) as total_death, (MAX(total_deaths)/population)*100 as PercentDead FROM CovidDeaths
GROUP BY Location, Population
ORDER BY PercentDead DESC;

--Peru at ~.3% of their population died of COVID

-- Highest deaths overall
SELECT location, population, MAX(cast(total_deaths as int)) as total_death FROM CovidDeaths --HAD TO CAST DUE TO TOTAL DEATHS BEING A VARCHAR WHEN IMPORTED
WHERE continent is not null -- was getting data like Europe and high income when all I wanted was individual countries
GROUP BY Location, Population
ORDER BY total_death DESC;
-- Unfortunatley USA has the highest death toll, but not too shocking as we do have one of the highest populations in the world

--Total case amount and death percentage of the world currently
SELECT SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as PercentDead FROM CovidDeaths
WHERE continent is not null; -- was getting data like Europe and high income when all I wanted was individual countries


-- Looking to see amount of people vaccinated using joins

SELECT cd.continent, cd.location, cd.date,cd.population, cv.new_vaccinations,
SUM(cast(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location ORDER BY cd.date) as CountOfPeopleVaxed
FROM CovidDeaths cd JOIN CovidVaccinations cv 
ON cd.location = cv.location AND cd.date = cv.date
where cd.continent is not null
order by cd.location,cd.date;



