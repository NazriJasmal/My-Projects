Create sequence location_seq;
--Transfer the data from Staging_table to DW-location table
DECLARE
   CURSOR c_location IS
      SELECT DISTINCT
          "samplesamplingPointlabel" AS location_name,
          "samplesamplingPointeasting" AS coordinate_easting,
          "samplesamplingPointnorthing" AS coordinate_northing
      FROM staging_table;

   v_location_id NUMBER;
   v_location_name VARCHAR2(100);
   v_coordinate_easting NUMBER;
   v_coordinate_northing NUMBER;

BEGIN
   FOR c_rec IN c_location LOOP
      -- Get the next value from the sequence directly in the VALUES clause
      v_location_id := location_seq.nextval; -- Assuming "location_seq" is your sequence name

      v_location_name := c_rec.location_name;
      v_coordinate_easting := c_rec.coordinate_easting;
      v_coordinate_northing := c_rec.coordinate_northing;

      -- Insert into LOCATION table using the generated sequence value
      INSERT INTO "LOCATION" (location_id, location_name, coordinate_easting, coordinate_northing)
         VALUES (v_location_id, v_location_name, v_coordinate_easting, v_coordinate_northing);
   END LOOP;
END;
/


select * from location;

select count(*) from location;

--Check if there is any duplicates in location_id column
select "LOCATION_ID", count(*) from location group by "LOCATION_ID" having count(*)>1;

--to check location_id is the primary_key column
SELECT column_name
FROM user_cons_columns
WHERE table_name = 'LOCATION'
AND constraint_name = (
    SELECT constraint_name
    FROM user_constraints
    WHERE table_name = 'LOCATION'
    AND constraint_type = 'P'
);
