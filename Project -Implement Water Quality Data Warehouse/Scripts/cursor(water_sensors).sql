Create sequence sensor_seq;
--Transfer the data from Staging_table to DW-watersensors table
DECLARE
   CURSOR c_water_sensors IS
      SELECT DISTINCT
         "determinanddefinition" AS sensor_type,
         "determinandnotation" AS notation,
         "determinandunitlabel" AS unit
      FROM staging_table;

   v_sensor_id NUMBER;
   v_sensor_type VARCHAR2(100);
   v_notation NUMBER(10);
   v_unit VARCHAR2(10);

BEGIN
   FOR c_rec IN c_water_sensors LOOP
      -- Get the next value from the sequence for sensor_id
      v_sensor_id := sensor_seq.nextval;

      -- Assign values from the cursor
      v_sensor_type := c_rec.sensor_type;
      v_notation := c_rec.notation;
      v_unit := c_rec.unit;

      -- Insert into WATER_SENSORS table
      INSERT INTO WATER_SENSORS (sensor_id, sensor_type, notation, unit)
         VALUES (v_sensor_id, v_sensor_type, v_notation, v_unit);
   END LOOP;
END;
/

commit;

select * from water_sensors;

select count(*) from water_sensors;

--Check if there is any duplicates in location_id column
select "SENSOR_ID", count(*) from water_sensors group by "SENSOR_ID" having count(*)>1;

--to check sensor_id is the primary_key column
SELECT column_name
FROM user_cons_columns
WHERE table_name = 'WATER_SENSORS'
AND constraint_name = (
    SELECT constraint_name
    FROM user_constraints
    WHERE table_name = 'WATER_SENSORS'
    AND constraint_type = 'P'
);