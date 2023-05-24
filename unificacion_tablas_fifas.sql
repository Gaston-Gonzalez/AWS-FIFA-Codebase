
CREATE TABLE PLAYERS as
SELECT '2017' AS FIFA_YEAR,
       *
FROM FIFA17
UNION
SELECT '2018' AS FIFA_YEAR,
       *
FROM FIFA18
UNION
SELECT '2019' AS FIFA_YEAR,
       *
FROM FIFA19
UNION
SELECT '2020' AS FIFA_YEAR,
       *
FROM FIFA20
UNION
SELECT '2021' AS FIFA_YEAR,
       *
FROM FIFA21
UNION
SELECT '2022' AS FIFA_YEAR,
       *
FROM FIFA22
UNION
SELECT '2023' AS FIFA_YEAR,
       *
FROM FIFA23