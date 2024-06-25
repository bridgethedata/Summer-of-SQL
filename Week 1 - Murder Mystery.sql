-- Find Crime Scene Report 

SELECT * 
FROM crime_scene_report
WHERE type = 'murder' 
AND city = 'SQL City'
AND date = 20180115

-- Output, security footage shows that there were 2 witnessess info tells us where they live and who they're 
-- 1st lives at the last house on "Northwestern Dr"
  
SELECT * 
FROM PERSON
WHERE address_street_name = 'Northwestern Dr'
Order BY address_number DESC
LIMIT 1

-- 1st witness id = 14887
-- 2nd named Annabel, lives somewhere on "Franklin Ave"

SELECT * 
FROM PERSON
WHERE address_street_name = 'Franklin Ave'
LIMIT 10

-- 2nd witness id = 16371

-- Find the 2 witness using id 
SELECT *
FROM PERSON
WHERE id IN (14887,16371)
LIMIT 10

-- Find their interview transcripts 
SELECT *
FROM interview
WHERE person_id IN (14887,16371)
LIMIT 10

-- person_id 14887 
-- The membership number on the bag started with "48Z". 
-- The man got into a car with a plate that included "H42W".

-- person id_ 16371 
-- January the 9th.

SELECT p.*, gf. *
FROM drivers_license  AS DL
INNER JOIN person as p on dl.id = p.license_id
INNER JOIN get_fit_now_member as gf on p.id = gf.person_id
INNER JOIN HET_FIT_NOW_CHECK_IN AS CI ON GF.ID = CI.MEMBERSHIP_ID
WHERE plate_number LIKE '%H42W%'
AND membership_status = 'gold'
AND CHECK_IN_DATE = 20180109
LIMIT 10

--OUTPUT
--id	name	license_id	address_number	address_street_name	ssn	id	person_id	name	membership_start_date	membership_status
--67318	Jeremy Bowers	423327	530	Washington Pl, Apt 3A	871539279	48Z55	67318	Jeremy Bowers	20160101	gold
-- Jeremy Bowers

-- Find the mastermind
SELECT * 
FROM interview 
WHERE person_id = 67318

-- OUTPUT
-- she's around 5'5" , red hair and drives a Tesla Model S, attended the SQL Symphony Concert 3 times in December 2017

SELECT p. * , fb. *
FROM drivers_license as dl
INNER JOIN person as p on dl.id = p.license_id
INNER JOIN facebook_event_checkin as fb on fb.person_id =p.id
WHERE hair_color = 'red'
AND car_make = 'Tesla' 
AND height >= 65
AND height <= 67
AND gender = 'female'
LIMIT 100

-- OUTPUT
--Miranda Priestly is the mastermind
