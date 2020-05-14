/* #################
   # SQL ZOO NOTES #
   ################# */

/*---------- 0 SELECT basics */

--IN checks if an item is in a list.
SELECT name, population --2. Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');

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
WHERE population > ALL(SELECT population*3 FROM world y WHERE x.continent = y.continent AND population > 0 AND y.name != x.name);

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

/*---------- 6. JOIN */
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

--12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'.
SELECT matchid, mdate, COUNT(player) as GER_goals
FROM goal JOIN game ON id=matchid
WHERE teamid='GER'
GROUP BY matchid, mdate;


-- | CASE WHEN condition1 THEN value1 
-- |     WHEN condition2 THEN value2  
-- |     ELSE def_value 
-- | END 
--13. List every match with the goals scored by each team as shown.
-- [mdate,team1,score1,team2,score2]
SELECT mdate, team1, SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) AS score1, team2, SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) AS score2
FROM game LEFT JOIN goal ON (id=matchid)
GROUP BY mdate,team1,team2
ORDER BY mdate,matchid,team1,team2;

/*---------- 7. More JOIN operations*/

-- 11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title)
FROM movie JOIN casting ON movie.id=casting.movieid JOIN actor ON casting.actorid=actor.id 
WHERE name LIKE 'Rock Hudson' 
GROUP BY yr 
HAVING COUNT(title) > 2;

-- 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name
FROM movie JOIN casting ON (movie.id=casting.movieid AND ord=1) JOIN actor ON casting.actorid=actor.id 
WHERE movie.id IN (SELECT movieid FROM casting WHERE actorid IN (179));

-- 13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
SELECT name
FROM movie JOIN casting ON (movie.id=casting.movieid AND ord=1) JOIN actor ON casting.actorid=actor.id 
GROUP BY name 
HAVING COUNT(ord) >= 30;

-- 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid)
FROM movie JOIN casting ON (movie.id=casting.movieid AND yr=1978)
GROUP BY title 
ORDER BY COUNT(actorid) DESC, title;

-- 15. List all the people who have worked with 'Art Garfunkel'.
SELECT name 
FROM actor JOIN casting ON actor.id=casting.actorid 
WHERE movieid IN (10095, 11434, 13630) AND actor.name != 'Art Garfunkel';

/*---------- 8. Using NULL*/
-- IS NULL or IS NOT NULL
-- 1. List the teachers who have NULL for their department.
SELECT teacher.name
FROM teacher 
WHERE teacher.dept IS NULL;

-- COALESCE function: COALESCE takes any number of arguments and returns the first value that is not null.
-- COALESCE(x,y,z) = x if x is not NULL
-- COALESCE(x,y,z) = y if x is NULL and y is not NULL
-- COALESCE(x,y,z) = z if x and y are NULL but z is not NULL
-- COALESCE(x,y,z) = NULL if x and y and z are all NULL

-- COALESCE can be useful when you want to replace a NULL value with some other value. 
-- In this example you show the name of the party for each MSP that has a party. 
-- For the MSP with no party (such as Canavan, Dennis) you show the string None.
SELECT name, party, COALESCE(party,'None') AS aff
FROM msp 
WHERE name LIKE 'C%';

-- CASE allows you to return different values under different conditions.
-- If there no conditions match (and there is not ELSE) then NULL is returned.
-- CASE WHEN condition1 THEN value1 
--     WHEN condition2 THEN value2  
--     ELSE def_value 
-- END
-- For example: 
SELECT name, population , CASE WHEN population<1000000 THEN 'small'
                               WHEN population<10000000 THEN 'medium'
                               ELSE 'large' END
FROM bbc;

/*---------- 8+ Numeric Examples */

/*---------- 9. Window functions */
-- RANK() 
SELECT product_id, product_name, list_price, RANK () OVER (ORDER BY list_price DESC) AS 'price_rank'  
FROM production.products;

SELECT party, votes, RANK() OVER (ORDER BY votes DESC) as 'posn' 
FROM ge 
WHERE constituency = 'S14000024' AND yr = 2017 
ORDER BY party;

-- PARTITION BY 
SELECT yr, party, votes, RANK() OVER (PARTITION BY yr ORDER BY votes DESC) as 'posn' 
FROM ge 
WHERE constituency = 'S14000021' 
ORDER BY party, yr;

SELECT constituency, party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) as 'posn' 
FROM ge 
WHERE constituency BETWEEN 'S14000021' AND 'S14000026' AND yr = 2017 
ORDER BY posn, constituency, votes DESC;

5. Edinburgh winners
SELECT constituency, party 
FROM (SELECT constituency,party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) as posn 
      FROM ge
      WHERE constituency BETWEEN 'S14000021' AND 'S14000026' AND yr  = 2017 
ORDER BY posn, constituency,votes DESC) as T 
WHERE posn = 1;

6. Scottish seats
SELECT party, COUNT(party) 
FROM (SELECT constituency,party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) as posn 
      FROM ge
      WHERE constituency LIKE 'S%' AND yr  = 2017 
      ORDER BY posn, constituency,votes DESC) as T 
WHERE posn = 1 
GROUP BY party;
                                                                 

/*---------- 9. Self join */                                                                 
5. Self join: Show services from Craiglockhart to London Route
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop = 53 AND b.stop = 149;
                                                                 
6. Self join: Show services from Craiglockhart to London Route, refer to them by name                                                                  
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, b.num
FROM route AS a
JOIN route AS b ON (a.company, a.num) = (b.company, b.num)
WHERE a.stop = 115 AND b.stop = 137;

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT r1.company, r1.num 
FROM route AS r1
JOIN route AS r2 ON (r1.company, r1.num) = (r2.company, r2.num)
JOIN stops AS s1 ON r1.stop = s1.id
JOIN stops AS s2 ON r2.stop = s2.id
WHERE s1.name = 'Craiglockhart' AND s2.name = 'Tollcross';

-- https://sqlzoo.net/wiki/Guest_House_Assessment_Medium
-- 8. Edinburgh Residents. For every guest who has the word “Edinburgh” in their address show the total number of nights booked.
-- Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and number of nights. 
-- Order by last name then first name.
SELECT last_name, first_name, address, CASE WHEN SUM(booking.nights) IS NULL THEN 0 ELSE SUM(booking.nights) END AS nights 
FROM booking RIGHT JOIN guest ON (booking.guest_id=guest.id) 
WHERE address LIKE '%Edinburgh%' 
GROUP BY last_name, first_name, address 
ORDER BY last_name, first_name;





