--Fact table foreign key validation
select distinct time_id from sample_fact order by time_id;
select distinct sensor_id from sample_fact  order by sensor_id;
select distinct sample_method_id from sample_fact order by sample_method_id;
select distinct sample_purpose_id from sample_fact;
select distinct location_id from sample_fact;

select time_id from TIME;
select sensor_id from water_sensors;
select sample_method_id from sample_method;
select sample_purpose_id from sample_purpose order by sample_purpose_id;
select location_id from location order by location_id;

