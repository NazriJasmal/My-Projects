Create sequence sample_fact_seq;
DECLARE
   CURSOR c_data IS
      SELECT
         "samplesampleDateTime" AS sample_date,
         "samplesamplingPointlabel" AS location_name,
         "determinanddefinition" AS sensor_type,
         "determinandnotation" AS notation,
         "determinandunitlabel" AS unit,
         "samplesampledMaterialTypelabel" AS sample_method_type,
         "samplepurposelabel" AS sample_purpose_type,
         "samplesamplingPointeasting" AS COORDINATE_EASTING,
         "samplesamplingPointnorthing" AS COORDINATE_NORTHING,
         "result",
         "sampleisComplianceSample" AS Compliance
      FROM staging_table;
      
   v_sample_id NUMBER;
   v_time_id NUMBER;
   v_sensor_id NUMBER;
   v_location_id NUMBER;
   v_sample_method_id NUMBER;
   v_sample_purpose_id NUMBER;
   
BEGIN
   FOR c_rec IN c_data LOOP
      -- Get the next value from the sequence for sample_id
      v_sample_id := sample_fact_seq.nextval;
   
      -- Use direct references of foreign key values from dimension tables
      SELECT time_id INTO v_time_id FROM TIME WHERE sample_date = TO_DATE(c_rec.sample_date, 'YYYY-MM-DD"T"HH24:MI:SS')AND ROWNUM=1;
      SELECT sensor_id INTO v_sensor_id FROM WATER_SENSORS WHERE sensor_type = c_rec.sensor_type AND ROWNUM=1;
      SELECT location_id INTO v_location_id FROM LOCATION WHERE location_name = c_rec.location_name AND ROWNUM=1;
      SELECT sample_method_id INTO v_sample_method_id FROM SAMPLE_METHOD WHERE sample_method_type = c_rec.sample_method_type AND ROWNUM=1;
      SELECT sample_purpose_id INTO v_sample_purpose_id FROM SAMPLE_PURPOSE WHERE sample_purpose_type = c_rec.sample_purpose_type AND ROWNUM=1;

      -- Insert into SAMPLE_FACT table
      INSERT INTO SAMPLE_FACT (sample_id, time_id, sensor_id, sample_method_id, sample_purpose_id, location_id, result, compliance)
         VALUES (v_sample_id, v_time_id, v_sensor_id, v_sample_method_id, v_sample_purpose_id, v_location_id, c_rec."result", c_rec.Compliance);

   END LOOP;

   -- Commit the changes
   COMMIT;
END;
/
select count(*) from sample_fact;

select * from sample_fact;