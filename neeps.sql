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

--MEDIUM:
--6. Show the 'size' of each of the co72010 events. Size is the total number of students attending each event.
SELECT COUNT(s.id) 
FROM student s, event e, attends a 
WHERE s.id=a.student AND a.event=e.id 
AND e.modle='co72010';

--7. For each post-graduate module, show the size of the teaching team. (post graduate modules start with the code co7).
SELECT e.modle, COUNT(t.staff)  
FROM event e, teaches t 
WHERE e.id=t.event 
AND e.modle LIKE 'co7%' 
GROUP BY e.modle;

--8. Give the full name of those modules which include events taught for fewer than 10 weeks
SELECT x.name, x.count_week  
FROM (SELECT m.name, o.event, COUNT(o.week) as count_week   
FROM modle m, event e, occurs o 
WHERE m.id=e.modle AND e.id=o.event 
GROUP BY m.name, o.event 
ORDER BY COUNT(o.week) ASC) as x 
WHERE x.count_week<10;


--9. Identify those events which start at the same time as one of the co72010 lectures.
SELECT e.id    
FROM event e, occurs o, week w, (SELECT e.tod    
FROM event e, occurs o, week w 
WHERE e.id=o.event AND o.week=w.id 
AND e.modle='co72010') as x
WHERE e.id=o.event AND o.week=w.id AND e.tod=x.tod 
AND e.modle='co72010';


--10. How many members of staff have contact time which is greater than the average?
--STEP1: Find the hours worked by each staff member
SELECT name, SUM(duration) as sum_duration 
FROM event e, teaches t, staff s 
WHERE e.id=t.event AND t.staff=s.id 
GROUP BY s.name

--STEP2: Find the average hours worked of all staff members
SELECT AVG(sum_duration) as avg_duration 
FROM (SELECT SUM(duration) sum_duration   
FROM event e, teaches t, staff s 
WHERE e.id=t.event AND t.staff=s.id 
GROUP BY name) as y

--STEP3: Subquery [Answer]
SELECT * 
FROM (SELECT name, SUM(duration) as sum_duration 
FROM event e, teaches t, staff s 
WHERE e.id=t.event AND t.staff=s.id 
GROUP BY s.name) as x 
WHERE x.sum_duration>(SELECT AVG(sum_duration) as avg_duration 
FROM (SELECT SUM(duration) sum_duration   
FROM event e, teaches t, staff s 
WHERE e.id=t.event AND t.staff=s.id 
GROUP BY name) as y)





