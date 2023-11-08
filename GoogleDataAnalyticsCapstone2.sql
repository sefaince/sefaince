SELECT 
Id,
TotalSteps,
Calories

FROM
google_project.dbo.dailyActivity_merged

WHERE

TotalSteps > 0 AND Calories > 0  -- I exclude 0 values because if TotalSteps are 0 that's mean user doesn't use the watch

-- Query to find correlation between totalsteps and calories




SELECT
Id,
AVG(LightlyActiveMinutes) AS LightlyActiveMinutes_Average,
AVG(SedentaryMinutes) AS SedentaryMinutes_Average,
AVG(FairlyActiveMinutes) AS FairlyActiveMinutes_Average,
AVG(VeryActiveMinutes) AS VeryActiveMinutes_Average

INTO #nested

FROM (

	SELECT 
	CONVERT(int, LightlyActiveMinutes)   AS LightlyActiveMinutes,
	CONVERT(int, SedentaryMinutes)   AS SedentaryMinutes,
	CONVERT(int, FairlyActiveMinutes)   AS FairlyActiveMinutes,
	CONVERT(int, VeryActiveMinutes)   AS VeryActiveMinutes,
	Id

	FROM

	google_project.dbo.dailyActivity_merged

	) AS Nested1

GROUP BY Id


-- First Query for distribution between activity types. I have forward the query to temporary table 



SELECT 
Id,
MIN(ActivityDate) start_time,
MAX(ActivityDate) end_time,
DATEDIFF(DAY, MIN(ActivityDate), MAX(ActivityDate)) elapsed_time

INTO

#nested2

FROM

google_project.dbo.dailyActivity_merged 



GROUP BY
Id

ORDER BY

elapsed_time


-- Second Query for distribution between activity types. I have forward the query to temporary table 




SELECT 

#nested.Id,
LightlyActiveMinutes_Average,
SedentaryMinutes_Average,
FairlyActiveMinutes_Average,
VeryActiveMinutes_Average,
elapsed_time


FROM #nested INNER JOIN #nested2 ON #nested.Id = #nested2.Id

ORDER BY elapsed_time


-- Last query for distribution between activity types. I used temporary tables here







SELECT 
AVG(LightActiveDistance) AS LightActiveDistance_Average,
AVG(SedentaryActiveDistance) AS SedentaryActiveDistance_Average,
AVG(ModeratelyActiveDistance) AS ModeratelyActiveDistance_Average,
AVG(VeryActiveDistance) AS VeryActiveDistance_Average


FROM (

	SELECT 
	CONVERT(float, LightActiveDistance)   AS LightActiveDistance,
	CONVERT(float, SedentaryActiveDistance)   AS SedentaryActiveDistance,
	CONVERT(float, ModeratelyActiveDistance)   AS ModeratelyActiveDistance,
	CONVERT(float, VeryActiveDistance)   AS VeryActiveDistance

	FROM

	google_project.dbo.dailyActivity_merged

	) AS Nested2


-- Average Distance of Activites




SELECT

google_project.dbo.weightLogInfo_merged.Id,
AVG(CONVERT(float,BMI)) as BMI,
AVG(CONVERT(int,SedentaryMinutes)) as SedentaryMinutes

FROM

google_project.dbo.dailyActivity_merged 

INNER JOIN

google_project.dbo.weightLogInfo_merged ON google_project.dbo.dailyActivity_merged.Id = google_project.dbo.weightLogInfo_merged.Id

GROUP BY

google_project.dbo.weightLogInfo_merged.Id

ORDER BY

SedentaryMinutes


-- Query for correlation of BMI and Sedentary Time





SELECT
google_project.dbo.sleepDay_merged.Id,
google_project.dbo.sleepDay_merged.SleepDay,
AVG(CONVERT(float,TotalMinutesAsleep)) as TotalMinutesAsleep,
AVG(CONVERT(int,TotalTimeInBed)) as TotalTimeInBed,
AVG(CONVERT(int,TotalTimeInBed) - CONVERT(float,TotalMinutesAsleep)) AS TimeInBedWithoutSleep

FROM

google_project.dbo.dailyActivity_merged 

INNER JOIN

google_project.dbo.sleepDay_merged ON google_project.dbo.dailyActivity_merged.Id = google_project.dbo.sleepDay_merged.Id

GROUP BY

google_project.dbo.sleepDay_merged.Id,
google_project.dbo.sleepDay_merged.SleepDay



-- Query for Time in Bed and Time Asleep Correlation




SELECT
google_project.dbo.sleepDay_merged.Id,
AVG(CONVERT(int,TotalTimeInBed)) as TotalTimeInBed,
AVG(CONVERT(int,SedentaryMinutes)) as SedentaryMinutes

FROM

google_project.dbo.dailyActivity_merged 

INNER JOIN

google_project.dbo.sleepDay_merged ON google_project.dbo.dailyActivity_merged.Id = google_project.dbo.sleepDay_merged.Id

GROUP BY

google_project.dbo.sleepDay_merged.Id


-- Query for Time in Bed and Sedentary Time Correlation