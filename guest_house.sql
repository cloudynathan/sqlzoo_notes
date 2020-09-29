-------outer join with explicit joins


-------------------------------------------------------

EASY: 

--3. 
SELECT booking_id,
room_type_requested, occupants, amount 
FROM booking b, room r, room_type rt, rate ra 
WHERE b.room_no=r.id 
AND r.room_type=rt.id 
AND rt.id=ra.room_type 
AND ra.occupancy=b.occupants 
AND b.booking_id IN (5152, 5165, 5154, 5295); 

--4. 
SELECT first_name, last_name, address 
FROM booking b, guest g 
WHERE b.guest_id=g.id 
AND b.room_no=101 
AND b.booking_date='2016-12-03';

--5.
SELECT guest_id, COUNT(nights), SUM(nights) 
FROM booking b 
WHERE b.guest_id IN (1185, 1270)
GROUP BY b.guest_id; 

-- MEDIUM:----------------------------

--6.
SELECT SUM(nights*amount) 
FROM booking b, guest g, rate r 
WHERE b.guest_id=g.id 
AND b.room_type_requested=r.room_type 
AND b.occupants=r.occupancy 
AND g.first_name='Ruth' 
AND g.last_name='Cadbury';

--7. no extra

--8. 
SELECT last_name, first_name, address, SUM(ISNULL(nights,0)) 
FROM guest g 
FULL OUTER JOIN booking b ON b.guest_id=g.id 
WHERE g.address LIKE '%Edinburgh%' 
GROUP BY last_name, first_name, address;

--9.
SELECT b.booking_date as i, COUNT(b.booking_date) 
FROM booking b 
WHERE b.booking_date BETWEEN '2016-11-25' AND dateadd(day, 6, '2016-11-25') 
GROUP BY b.booking_date;

--10.
SELECT SUM(occupants) 
FROM booking b 
WHERE b.booking_date <= '2016-11-21' 
AND DATEADD(day, nights, b.booking_date) > '2016-11-21'

-- HARD:--------------------------------------------

--11. 
SELECT g.last_name, g.first_name, g2.first_name 
FROM booking b, guest g, booking b2, guest g2 
WHERE b.guest_id=g.id 
AND b2.guest_id=g2.id 
AND b.booking_date BETWEEN b2.booking_date 
AND DATEADD (Day, b2.nights, b2.booking_date) 
AND g.last_name=g2.last_name 
AND g.id<g2.id 
ORDER BY g.last_name;

--12.
SELECT checkout_date, sum(count1) AS first, sum(count2) AS second, sum(count3) AS third 
FROM (
 SELECT convert(varchar, dateadd(day, b.nights, b.booking_date)) AS 'checkout_date', 
 CASE
  WHEN LEFT(room_no, 1) = 1 THEN 1 
 END AS count1, 
 CASE
  WHEN LEFT(room_no, 1) = 2 THEN 1 
 END AS count2,
 CASE
  WHEN LEFT(room_no, 1) = 3 THEN 1 
 END AS count3 
 FROM booking b 
 WHERE DATEADD(Day, b.nights, b.booking_date) BETWEEN '2016-11-14' AND DATEADD(Day, 7, '2016-11-14')) c 
GROUP BY checkout_date 

--intermediate step
SELECT convert(varchar, dateadd(day, b.nights, b.booking_date)) AS 'checkout_date', 
 room_no, 
 CASE 
  WHEN LEFT(room_no, 1) = 1 THEN 1 
 END AS count1, 
 CASE
  WHEN LEFT(room_no, 1) = 2 THEN 1 
 END AS count2,
 CASE
  WHEN LEFT(room_no, 1) = 3 THEN 1 
 END AS count3 
 FROM booking b 
 WHERE DATEADD(Day, b.nights, b.booking_date) BETWEEN '2016-11-14' AND DATEADD(Day, 7, '2016-11-14') 

--13.
SELECT r.id 
FROM room r 
WHERE NOT EXISTS (
 SELECT * 
 FROM booking b 
 WHERE b.room_no=r.id 
 AND '2016-11-25' BETWEEN b.booking_date AND DATEADD(Day, b.nights, b.booking_date))  
UNION 
SELECT r.id 
FROM room r 
WHERE EXISTS (
 SELECT * 
 FROM booking b 
 WHERE b.room_no=r.id 
 AND DATEADD(Day, b.nights, b.booking_date)='2016-11-25' 
 AND NOT EXISTS (
  SELECT * 
  FROM booking b 
  WHERE b.room_no=r.id 
  AND b.booking_date='2016-11-25'))

--#block1: rooms where there are no checks ins 
SELECT r.id 
FROM room r 
WHERE NOT EXISTS (
 SELECT * 
 FROM booking b 
 WHERE b.room_no=r.id 
 AND '2016-11-25' BETWEEN b.booking_date AND DATEADD(Day, b.nights, b.booking_date))

--#block2: where people checked out on this day AND no new check ins
SELECT r.id 
FROM room r 
WHERE EXISTS (
 SELECT * 
 FROM booking b 
 WHERE b.room_no=r.id 
 AND DATEADD(Day, b.nights, b.booking_date)='2016-11-25' 
 AND NOT EXISTS (
  SELECT * 
  FROM booking b 
  WHERE b.room_no=r.id 
  AND b.booking_date='2016-11-25'))

--14. 
SELECT TOP 1 c.room_no, MAX(LEFT(c.checkout,10)) checkout 
FROM (
 SELECT room_no, booking_date, DATEADD(Day, b.nights, b.booking_date) AS checkout, b.nights 
 FROM booking b, room r 
 WHERE b.room_no=r.id 
 AND max_occupancy=1) c 
GROUP BY c.room_no 
ORDER BY checkout



















