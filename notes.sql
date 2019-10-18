/* #################
   # SQL ZOO NOTES #
/* #################

/* 0 SELECT basics */

--IN checks if an item is in a list.
SELECT name, population --Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark') 

--BETWEEN allows range checking (range specified is inclusive of boundary values)
SELECT name, area 
FROM world
WHERE area BETWEEN 200000 AND 250000

/* 1 SELECT names */




