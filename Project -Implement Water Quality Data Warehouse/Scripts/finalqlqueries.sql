--The list of water sensors measured by type of it by month
select w.sensor_type, t.month
From WATER_SENSORS W
JOIN SAMPLE_FACT SF ON W.sensor_id=SF.sensor_id
Join Time t on SF.time_id=T.time_id
Group by w.sensor_type, t.month order by T.month;

--The list of water sensors measured by type of it by month including its count and sensor_id
select w.sensor_id, w.sensor_type, t.month, count(*) as measurement_count
From WATER_SENSORS W
JOIN SAMPLE_FACT SF ON W.sensor_id=SF.sensor_id
Join Time t on SF.time_id=T.time_id
Group by w.sensor_id, w.sensor_type, t.month order by sensor_id, T.month;

--The number of sensor measurements collected by type of sensor by week
select w.sensor_type, t.week, count(*) as measurement_count
From WATER_SENSORS W
JOIN SAMPLE_FACT SF ON W.sensor_id=SF.sensor_id
Join Time t on SF.time_id=T.time_id
Group by w.sensor_type, t.week order by T.week;

--The number of sensor measurements collected by type of sensor by week including sensor_id
select w.sensor_id, w.sensor_type, t.week, count(*) as measurement_count
From WATER_SENSORS W
JOIN SAMPLE_FACT SF ON W.sensor_id=SF.sensor_id
Join Time t on SF.time_id=T.time_id
Group by w.sensor_id, w.sensor_type, t.week order by w.sensor_id, T.week;

--The number of measurements made by location by month
select l.location_name, T.month, count(*) as measurement_count
From Location L
JOIN SAMPLE_FACT SF ON L.location_id=SF.location_id
Join Time t on SF.time_id=T.time_id
Group by l.location_name, T.month order by T.month;


--The number of measurements made by location by month including location_id
select l.location_id,l.location_name, T.month, count(*) as measurement_count
From Location L
JOIN SAMPLE_FACT SF ON L.location_id=SF.location_id
Join Time t on SF.time_id=T.time_id
Group by l.location_id,l.location_name, T.month order by l.location_id, T.month;

select distinct sensor_type from water_sensors;
select * from time;


--The average number of measurements covered for PH by year
select t.year,  Round(Avg(sf.result),2) as average_PH_measurement
From WATER_SENSORS W
JOIN SAMPLE_FACT SF ON W.sensor_id=SF.sensor_id
Join Time t on SF.time_id=T.time_id
where w.sensor_type='pH'
Group by t.year
order by t.year;

--The average value of Nitrate measurements by location by year
SELECT l.location_id, L.location_name, T.year, AVG(SF.result) AS average_nitrate_value
FROM WATER_SENSORS W
JOIN SAMPLE_FACT SF ON W.sensor_id = SF.sensor_id
JOIN TIME T ON SF.time_id = T.time_id
JOIN LOCATION L ON SF.location_id = L.location_id
WHERE W.sensor_type = 'Nitrate as N'
GROUP BY l.location_id, L.location_name, T.year
ORDER BY L.location_name, T.year;

