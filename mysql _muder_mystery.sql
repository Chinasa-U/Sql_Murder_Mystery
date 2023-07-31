/*observe the dataset*/
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM information_schema.columns
WHERE TABLE_SCHEMA = 'sqlmurderschema'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

/*observe the crime scene report table*/
select * 
from crime_scene_report;

/*find the crime that was a “murder” that happened on 15/10/2018 on SQL City*/ 
SELECT * 
FROM sqlmurderschema.crime_scene_report 
WHERE city = 'SQL City' AND date = 20180115 AND type = 'murder'; 

/*To find more details about the witnesses, I used the provided information from the 
crime_scene_report result above and queried the “person” table*/
SELECT * 
FROM sqlmurderschema.person 
WHERE address_number = (SELECT MAX(address_number)   FROM person  WHERE address_street_name = 'Northwestern Dr') 
UNION 
SELECT * 
FROM sqlmurderschema.person 
WHERE name LIKE '%Annabel%' AND address_street_name = 'Franklin Ave'; 

/*Using the witnesses’s person_ids from the above queried result to query the interview 
table to see the transcript of the witnesses*/
SELECT * 
FROM interview 
WHERE person_id IN (14887,16371); 

/*queried the tables using the details provided by the 2nd witness (Morty Schapiro), use Join clause on get_fit_now_member table 
for similar ID, membership status and drivers_license table to check for the plate number */
SELECT gm.id, gm.person_id, gm.name, gm.membership_status,  
              dr.plate_number 
FROM get_fit_now_member AS gm 
JOIN person AS pe  
ON  gm.person_id = pe.id 
JOIN drivers_license AS dr 
ON pe.license_id = dr.id 
WHERE  gm.id LIKE '%48Z%' AND  gm.membership_status='gold'  
                AND dr.plate_number like '%H42W%'; 
/*the query showed 'Jeremy Bowers' as the  suspect*/

/* to confirm if the two witness saw the same person, i queried the tables using the description of the of 
the first witness (Annabel miller),Using the date provided (january 09), and since his description was based on a week ago
from the crime date, I added the year ‘2018’  and queried the get_fit_now_check_in table*/
SELECT * 
FROM get_fit_now_check_in 
WHERE check_in_date = 20180109; 

/*I noticed that there are a lot of data  entry on that date and I decided to narrow it down by applying a membership ID since 
the second witness reference.*/
SELECT * 
FROM get_fit_now_check_in 
WHERE check_in_date = 20180109 AND membership_id LIKE '%48Z%'; 

/*I Observed  two membership_id 48Z7A, 48Z55  from  the result. So, I   went further to check  the get_fit_now_member table
 to get the details about the IDs.*/
SELECT * 
FROM get_fit_now_member 
WHERE id IN ('48Z7A','48Z55'); 

/*to confirm my guess I used the person.id gotten from the immediate 
query and join the person.licence_id to the drivers_licence to check  the two suspect plate number.*/
SELECT pe.name, dr.plate_number 
FROM person  pe 
JOIN drivers_license dr 
ON dr.id = pe.license_id 
WHERE pe.id IN  (28819,67318); 

-- the prime suspect is JEREMY BOWER

/*to check if the prime suspect i found is the correct one I insert the name and plate number i got to the solution table*/
ALTER TABLE solution MODIFY COLUMN user VARCHAR(255);
ALTER TABLE solution MODIFY COLUMN value VARCHAR(255);
insert into solution
 Values(1,' Jeremy Bowers');
 select * from solution;
 
/*use the mystery.knightlab.com to check the final answer and 'Jeremy Bower' was the correct suspect*/

/*to find the real vallin , check the interview table for the suspect interview*/
select * from interview;

/* get the interview of Jeremy Bowers using his perso_id*/
select * 
from interview 
where person_id = 67318;

/*find the main suspect using join syntax*/
select *
 from drivers_license dr
 join person pe 
 on dr.id=pe.license_id
 join facebook_event_checkin fa
 on  fa.person_id = pe.id
 where dr.hair_color = 'red'
 and dr.gender = 'female' 
 and dr.car_make = 'Tesla'
 and dr.height in (65,66,67) and dr.car_model = 'model S'
 and pe.license_id in (918773,291182,202298)
 and  fa.event_name = 'SQL Symphony Concert' and fa.date like '201712%' and fa.person_id in (78881, 90700, 99716);
 
/*the main suspect is "Miranda Priestly"*/


 



