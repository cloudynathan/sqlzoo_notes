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
WHERE capital = concat(name, ' City');

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
--SELECT name, REPLACE(capital, name, '')
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





