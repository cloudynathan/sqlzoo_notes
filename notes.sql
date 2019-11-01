/* #################
   # SQL ZOO NOTES #
   ################# */

/*---------- 0 SELECT basics */

--IN checks if an item is in a list.
SELECT name, population --2. Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark') ;

--BETWEEN allows range checking (range specified is inclusive of boundary values)
SELECT name, area --3. Countries with an area between 200,000 and 250,000.
FROM world
WHERE area BETWEEN 200000 AND 250000;

/*---------- 1 SELECT names */
--LIKE
SELECT name --1. Find the country that start with Y
FROM world
WHERE name LIKE 'Y%';

-- _ (single character wildcard)
SELECT name FROM world --8. Find the countries that have "t" as the second character.
WHERE name LIKE '_t%'
ORDER BY name;

--concat()
--12. The capital of Mexico is Mexico City. Show all the countries where the capital has the country together with the word "City".
--Find the country where the capital is the country plus "City".
SELECT name
FROM world
WHERE capital LIKE concat(name, ' City');

--13. Find the capital and the name where the capital includes the name of the country.
SELECT capital, name
FROM world
WHERE capital LIKE concat('%',name,'%');

--14. Find the capital and the name where the capital is an extension of name of the country.
--You should include Mexico City as it is longer than Mexico. 
--You should not include Luxembourg as the capital is the same as the country.
SELECT capital, name
FROM world
WHERE capital LIKE concat('%', name, '%') AND capital > name;

--REPLACE()
--15. For Monaco-Ville the name is Monaco and the extension is -Ville.
--Show the name and the extension where the capital is an extension of name of the country.
SELECT name, REPLACE(capital, name, '')
FROM world
WHERE capital LIKE concat('%', name, '%') AND capital > name;

/*---------- 2. SELECT world */
--3. Give the name and the per capita GDP for those countries with a population of at least 200 million.
SELECT name, gdp/population
FROM world
WHERE population >= 200000000;

--7. Two ways to be big: A country is big if it has an area of more than 3 million sq km or it has a population of more than 250 million.
--Show the countries that are big by area or big by population. Show name, population and area.
SELECT name, population, area
FROM world
WHERE (area >= 3000000) OR (population > 250000000);

--XOR (Exclusive OR) 
--8. Show the countries that are big by area or big by population but not both. Show name, population and area.
--Australia has a big area but a small population, it should be included.
--Indonesia has a big population but a small area, it should be included.
--China has a big population and big area, it should be excluded.
--United Kingdom has a small population and a small area, it should be excluded.
SELECT name, population, area
FROM world
WHERE (area >= 3000000) XOR (population > 250000000);

--9. Show the name and population in millions and the GDP in billions for the countries of the continent 'South America'. 
--Use the ROUND function to show the values to two decimal places.
--For South America show population in millions and GDP in billions both to 2 decimal places.
SELECT name, ROUND(population/1000000, 2), ROUND(gdp/1000000000, 2)
FROM world
WHERE continent = 'South America';

--10. Show the name and per-capita GDP for those countries with a GDP of at least one trillion (1000000000000; that is 12 zeros). 
--Round this value to the nearest 1000.
--Show per-capita GDP for the trillion dollar countries to the nearest $1000.
SELECT name, ROUND(gdp/population, -3)
FROM world
WHERE gdp > 1000000000000;

--11. Greece has capital Athens.
--Each of the strings 'Greece', and 'Athens' has 6 characters.
--Show the name and capital where the name and the capital have the same number of characters.
SELECT name, capital
FROM world
WHERE LENGTH(name)=LENGTH(capital);

--LEFT(name,1)
--12. The capital of Sweden is Stockholm. Both words start with the letter 'S'.
--Show the name and the capital where the first letters of each match.
--Don't include countries where the name and the capital are the same word.
--You can use the function LEFT to isolate the first character.
--You can use <> as the NOT EQUALS operator.
SELECT name, capital
FROM world
WHERE (LEFT(name,1)=LEFT(capital,1)) AND (name <> capital);

--13. Equatorial Guinea and Dominican Republic have all of the vowels (a e i o u) in the name. 
--They don't count because they have more than one word in the name.
--Find the country that has all the vowels and no spaces in its name.
--You can use the phrase name NOT LIKE '%a%' to exclude characters from your results.
--The query shown misses countries like Bahamas and Belarus because they contain at least one 'a'
SELECT name
FROM world
WHERE name LIKE '%a%' AND 
name LIKE '%e%' AND
name LIKE '%i%' AND
name LIKE '%o%' AND
name LIKE '%u%' AND
name NOT LIKE '% %';

/*---------- 3. SELECT nobel */
--5. Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive.
SELECT *
FROM nobel
WHERE (subject = 'Literature') AND (yr BETWEEN 1980 AND 1989);

--12. Find all details of the prize won by EUGENE O'NEILL.
SELECT *
FROM nobel
WHERE winner = 'EUGENE O''NEILL'; --use double ' to escape

-- 13. List the winners, year and subject where the winner starts with 'Sir'. 
--Show the the most recent first, then by name order.
SELECT winner, yr, subject
FROM nobel
WHERE (winner LIKE 'Sir%')
ORDER BY yr DESC, winner;

--14. Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.
SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY subject IN ('Chemistry','Physics'),subject,winner;

/*---------- 4. SELECT within SELECT */
--1. List each country name where the population is larger than that of 'Russia'.
SELECT name
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Russia');

--3. List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent
FROM world
WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))
ORDER BY name;

--5. Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name, CONCAT(ROUND(population/(SELECT population FROM world WHERE name = 'Germany')*100), '%')
FROM world
WHERE continent = 'Europe';
                                                               
--7. Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area
FROM world x
WHERE area >= ALL
    (SELECT area FROM world y
    WHERE y.continent=x.continent
    AND area>0);

SELECT continent, name, area
FROM world
WHERE area IN (SELECT MAX(area) FROM world GROUP BY continent);

--8. List each continent and the name of the country that comes first alphabetically.
SELECT continent, name
FROM world x
WHERE name <= ALL(SELECT name FROM world y WHERE y.continent = x.continent);

SELECT continent, MIN(name) as name
FROM world
GROUP BY continent
ORDER BY continent;
                                                               
--9. Find the continents where all countries have a population <= 25000000. 
--Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population
FROM world x
WHERE 25000000  > ALL(SELECT population FROM world y WHERE x.continent = y.continent AND y.population > 0);

SELECT name, continent, population
FROM world
WHERE continent NOT IN (SELECT continent FROM world WHERE population >= 25000000);

--10. Some countries have populations more than three times that of any of their neighbours (in the same continent).
--Give the countries and continents.
SELECT name, continent
FROM world x
WHERE population > ALL(SELECT population*3 FROM world y WHERE x.continent = y.continent AND population > 0 AND y.name != x.name)

/*---------- 5. SUM and COUNT */
--SUM, COUNT, MAX, DISTINCT, ORDER  BY

--6. For each continent show the continent and number of countries.
SELECT DISTINCT(continent), COUNT(name)
FROM world
GROUP BY continent;

--7. For each continent show the continent and number of countries with populations of at least 10 million.
SELECT DISTINCT(continent), COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent;

--HAVING: specify conditions that filter which group results appear in the results.                                                               --
--8. List the continents that have a total population of at least 100 million.
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;

/*---------- 5. JOIN */
--3. Show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
FROM goal JOIN game ON (goal.matchid=game.id)
WHERE teamid='GER';

--6. List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
FROM game JOIN eteam ON (game.team1 = eteam.id)
WHERE coach = 'Fernando Santos';

--8. Show the name of all players who scored a goal against Germany.
SELECT DISTINCT(player)
FROM game JOIN goal ON (goal.matchid = game.id)
WHERE (team1 = 'GER' OR team2 = 'GER')
AND teamid <> 'GER';

--9. Show teamname and the total number of goals scored (in descending order).
SELECT teamname, COUNT(teamid) AS 'total_goals'
FROM eteam JOIN goal ON eteam.id=goal.teamid
GROUP BY teamname
ORDER BY total_goals DESC;

--10. Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(player) as goals_scored
FROM game JOIN goal ON game.id=goal.matchid
GROUP BY stadium;

--11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(player)
FROM game JOIN goal ON id=matchid
WHERE team1='POL' OR team2='POL'
GROUP BY matchid, mdate;





