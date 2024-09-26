Create sequence sample_method_seq;
--Transfer the data from Staging_table to DW-sample_method table
DECLARE
   CURSOR c_sample_method IS
      SELECT DISTINCT "samplesampledMaterialTypelabel" AS sample_method_type
      FROM staging_table; 

   v_sample_method_id NUMBER;
   v_sample_method_type VARCHAR2(50);

BEGIN
   FOR c_rec IN c_sample_method LOOP
      -- Get the next value from the sequence for sample_method_id
      v_sample_method_id := sample_method_seq.nextval;

      -- Assign the sample_method_type from the cursor
      v_sample_method_type := c_rec.sample_method_type;

      -- Insert into SAMPLE_METHOD table
      INSERT INTO SAMPLE_METHOD (sample_method_id, sample_method_type)
         VALUES (v_sample_method_id, v_sample_method_type);
   END LOOP;
END;
/


select * from sample_method;

select count(*) from sample_method;

--Check if there is any duplicates in sample_method_id column
select "SAMPLE_METHOD_ID", count(*) from sample_method group by "SAMPLE_METHOD_ID" having count(*)>1;

--to check sample_purpose_id is the primary_key column
SELECT column_name
FROM user_cons_columns
WHERE table_name = 'SAMPLE_METHOD'
AND constraint_name = (
    SELECT constraint_name
    FROM user_constraints
    WHERE table_name = 'SAMPLE_METHOD'
    AND constraint_type = 'P'
);