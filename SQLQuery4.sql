------------------------------------------------------------------------------------------------------------------------------

--Testing The Table
select *
from dbo.athlete_events

------------------------------------------------------------------------------------------------------------------------------

--Query1 How many olympics games have been held?

 select count(distinct games) as total_olympic_games
 from dbo.athlete_events

--Query2 List down all Olympics games held so far.

select year  , Season , City
from dbo.athlete_events
group  by year , Season , City
order by 1 , 2 , 3

--OR 


select distinct oh.year,oh.season,oh.city
from dbo.athlete_events oh
order by year;


--Query3 Mention the total no of nations who participated in each olympics game?




------------------------------------------------------------------------------------------------------------------------------

SELECT SUM(No_OF_Nations) AS Total_No_OF_Nations
FROM (
    SELECT COUNT(DISTINCT team) + 1 AS No_OF_Nations
    FROM dbo.athlete_events
    GROUP BY team
) AS subquery;


SELECT Sport
FROM dbo.athlete_events
GROUP BY Sport
HAVING COUNT(DISTINCT Year) = (SELECT COUNT(DISTINCT Year) FROM dbo.athlete_events where Season='Summer');


------------------------------------------------------------------------------------------------------------------------------

--Query6 Identify the sport which was played in all summer olympics.
--1.Find total no of summer olympic games.
--2.Find for each sport, how many games where they played in.
--3.Compare 1 & 2

With t1 as 
(select count(distinct games) as total_summer_games
from dbo.athlete_events
where season = 'Summer') ,



t2 as 
(
select distinct sport,games
from dbo.athlete_events
where Season = 'Summer'

) ,

t3 as
(
select sport, count(games) as no_of_games
from t2
group by sport
)
select *
from t3
join t1 
ON t1.total_summer_games = t3.no_of_games

------------------------------------------------------------------------------------------------------------------------------
--QUERY.11. Fetch the top 5 athletes who have won the most gold medals.

--Checking one of the top players about his total medals : Frederick Carlton "Carl" Lewis

SELECT DISTINCT Name, Team, COUNT(Medal) AS total_of_medals_per_athlete
FROM dbo.athlete_events
WHERE Medal = 'Gold' AND Name = 'Frederick Carlton "Carl" Lewis'
GROUP BY Name, Team;

--The actually Query First mEthode With Only Names

with m1 as 
(
select  distinct Name,team,Count( Medal) as total_of_medals_per_athlete
from dbo.athlete_events
Where Medal = 'Gold'
group by name,team
),

m2 as

(
select top 5 Name,team,total_of_medals_per_athlete
from m1
order by total_of_medals_per_athlete desc
)
select *
from m2


--The actually Query With the Second methode With More Details

with t1 as
(
select name,count(1) as total_medals
from athlete_events
Where Medal = 'Gold'
group by name
),

t2 as
(
select *, dense_rank() over(order by total_medals desc) as rnk
from t1)

select*
from t2
where rnk <=5;


-----------------------------------------------------------------------------------------------------
--QUERY.14 List down total gold, silver and bronze medals won by each country.
--First methode
WITH t1 AS
(
    SELECT DISTINCT team, COUNT(Medal) AS Gold
    FROM dbo.athlete_events
    WHERE Medal = 'gold'
    GROUP BY team
),
t2 AS
(
    SELECT DISTINCT team, COUNT(Medal) AS Silver
    FROM dbo.athlete_events
    WHERE Medal = 'Silver'
    GROUP BY team
),
t3 AS
(
    SELECT DISTINCT team, COUNT(Medal) AS Bronze
    FROM dbo.athlete_events
    WHERE Medal = 'Bronze'
    GROUP BY team
),
t4 AS
(
    SELECT t1.team, t1.Gold, t2.Silver, t3.Bronze
    FROM t1
    JOIN t2 ON t1.team = t2.team
    JOIN t3 ON t2.team = t3.team
)
SELECT *
FROM t4;







--------------------------------------------------------
--Second methode

WITH t1 AS (
    SELECT team, COUNT(Medal) AS Gold
    FROM dbo.athlete_events
    WHERE Medal = 'Gold'
    GROUP BY team
),
t2 AS (
    SELECT team, COUNT(Medal) AS Silver
    FROM dbo.athlete_events
    WHERE Medal = 'Silver'
    GROUP BY team
),
t3 AS (
    SELECT team, COUNT(Medal) AS Bronze
    FROM dbo.athlete_events
    WHERE Medal = 'Bronze'
    GROUP BY team
)
SELECT t1.team, COALESCE(t1.Gold, 0) AS Gold, COALESCE(t2.Silver, 0) AS Silver, COALESCE(t3.Bronze, 0) AS Bronze
FROM t1
LEFT JOIN t2 ON t1.team = t2.team
LEFT JOIN t3 ON t1.team = t3.team;








