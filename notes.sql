/* #################
   # SQL ZOO NOTES #
   ################# */

/*---------- 0 SELECT basics */

--IN checks if an item is in a list.
SELECT name, population --2. Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark') 

--BETWEEN allows range checking (range specified is inclusive of boundary values)
SELECT name, area --3. Countries with an area between 200,000 and 250,000.
FROM world
WHERE area BETWEEN 200000 AND 250000

/*---------- 1 SELECT names */
--LIKE
SELECT name --1. Find the country that start with Y
FROM world
WHERE name LIKE 'Y%'

-- _ (single character wildcard)
SELECT name FROM world --8. Find the countries that have "t" as the second character.
WHERE name LIKE '_t%'
ORDER BY name

--concat()
--12. The capital of Mexico is Mexico City. Show all the countries where the capital has the country together with the word "City".
--Find the country where the capital is the country plus "City".
SELECT name
FROM world
WHERE capital = concat(name, ' City')

--13. Find the capital and the name where the capital includes the name of the country.
SELECT capital, name
FROM world
WHERE capital LIKE concat('%',name,'%')

--14. Find the capital and the name where the capital is an extension of name of the country.
--You should include Mexico City as it is longer than Mexico. 
--You should not include Luxembourg as the capital is the same as the country.
SELECT capital, name
FROM world
WHERE capital LIKE concat('%', name, '%') AND capital > name

--REPLACE()
--15. For Monaco-Ville the name is Monaco and the extension is -Ville.
--Show the name and the extension where the capital is an extension of name of the country.
--SELECT name, REPLACE(capital, name, '')
FROM world
WHERE capital LIKE concat('%', name, '%') AND capital > name

/*---------- 2. SELECT nobel */

