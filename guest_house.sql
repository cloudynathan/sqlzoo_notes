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
















