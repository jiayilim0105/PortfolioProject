Select*
FROM dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4


Select*
FROM dbo.CovidVaccinations
ORDER BY 3,4

--Select Data that are going to using
Select location,date,total_cases, new_cases, total_deaths, population
FROM dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at the total cases vs total deaths
--Shows the likelihood you die if you contract covid
Select location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

Select location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM dbo.CovidDeaths
WHERE location like '%States%' and continent is not null
ORDER BY 1,2


--Looking at the total cases vs population
--Showing what infection percentage
Select location,date, population, total_cases, (total_cases/population)*100 as InfectedPercent
FROM dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at country with highest infection rate
Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as InfectedPercent
FROM dbo.CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY InfectedPercent DESC

--Showing countries with highest death count vs population
Select location, max(cast(total_deaths as int)) as HighestDeathCount
FROM dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY HighestDeathCount DESC

--Lets break the things down by continent
--Showing continent with highest death count per population
Select continent, max(cast(total_deaths as int)) as HighestDeathCount
FROM dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY HighestDeathCount DESC

--Global numbers
Select sum(new_cases) as NewCases, sum(cast(new_deaths as int)) as newDeath, (sum(cast(new_deaths as int))/sum(new_cases))*100 as deathPercent
FROM dbo.CovidDeaths
WHERE continent is not null
--Group by date
--Order by 1,2


--Looking at total population vs  vaccinations
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(dec, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.date, dea.location)
FROM dbo.CovidDeaths dea 
Join dbo.CovidVaccinations vac
On dea.location=vac.location
and dea.date=vac.date
WHERE dea.continent is not null
Order by 2,3

--CTE
With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(dec, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.date, dea.location) as RollingPeopleVaccinated
FROM dbo.CovidDeaths dea 
Join dbo.CovidVaccinations vac
On dea.location=vac.location
and dea.date=vac.date
WHERE dea.continent is not null
--Order by 2,3
)
Select*, (RollingPeopleVaccinated/population)*100
From PopvsVac





