-- Neeps 

--EASY:
--1. Give the room id in which the event co42010.L01 takes place.
SELECT room  
FROM room r, event e 
WHERE r.id=e.room AND e.id='co42010.L01';

--2. For each event in module co72010 show the day, the time and the place.
SELECT dow, tod, room 
FROM event e 
WHERE modle='co72010'

--3. List the names of the staff who teach on module co72010.
SELECT name 
FROM event e, teaches t, staff s 
WHERE e.id=t.event AND s.id=t.staff AND modle='co72010';

--4. Give a list of the staff and module number associated with events using room cr.132 on Wednesday, include the time each event starts.
SELECT name, modle, tod 
FROM event e, teaches t, staff s 
WHERE e.id=t.event AND t.staff=s.id AND room='cr.132' AND dow='Wednesday';

--5. Give a list of the student groups which take modules with the word 'Database' in the name.
SELECT s.parent  
FROM student s, event e, modle m, attends a  
WHERE s.id=a.student AND a.event=e.id AND e.modle=m.id AND m.name LIKE '%Database%';
