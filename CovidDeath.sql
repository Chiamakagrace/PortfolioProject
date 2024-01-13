--Checking  the data 
Select * from PortfolioProject.dbo.CovidDeaths
order by 3,4

--Checking  the data 
Select * from PortfolioProject.dbo.CovidVaccinations
order by 3,4;

-- Selecting the Data that we are going to be using
Select location, date, population, total_cases, new_cases,total_deaths
from PortfolioProject..CovidDeaths
order by 1,2


-- Looking at Total case vs Total deaths
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS No_death
From PortfolioProject..CovidDeaths
Where location Like '%states%'
order by 1,2;



--Looking at the Total_case vs the Populations
--shows percentage of population  that has covid
Select location, date, total_cases, population,(total_cases/population)*100 AS percentage_death
From PortfolioProject..CovidDeaths
Where location Like '%states%'
order by 1,2;



-- Looking at countries with highest infection rate compared to population
Select location, MAX(total_cases) as HighestInfection, population,MAX((total_cases/population))*100 AS percentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, population
order by percentPopulationInfected desc;



--Showing Countries with the Highest Death
Select continent, location, population, MAX(Cast(total_deaths as int)) as DeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population, continent
order by DeathCount desc

--Lets Break Things down by continent


-- Showing continents with the Highest death rate
Select continent, MAX(Cast(total_deaths as int)) as DeathCount
From PortfolioProject..CovidDeaths
Where continent is  not null
Group by continent
order by DeathCount desc


----Global Number
Select  date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is  not null
Group by date
order by 1,2

--Total Global Number
Select SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) AS total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is  not null
order by 1,2
