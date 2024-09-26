Create sequence sample_purpose_seq;
--Transfer the data from Staging_table to DW-sample_pupose table
DECLARE
   CURSOR c_sample_purpose IS
      SELECT DISTINCT "samplepurposelabel" AS sample_purpose_type
      FROM staging_table;

   v_sample_purpose_id NUMBER;
   v_sample_purpose_type VARCHAR2(100);

BEGIN
   FOR c_rec IN c_sample_purpose LOOP
      -- Get the next value from the sequence for sample_purpose_id
      v_sample_purpose_id := sample_purpose_seq.nextval;

      -- Assign the sample_purpose_label from the cursor
      v_sample_purpose_type := c_rec.sample_purpose_type;

      -- Insert into SAMPLE_PURPOSE table
      INSERT INTO SAMPLE_PURPOSE (sample_purpose_id, sample_purpose_type)
         VALUES (v_sample_purpose_id, v_sample_purpose_type);
   END LOOP;
END;
/

select * from sample_purpose;

select count(*) from sample_purpose;

--Check if there is any duplicates in location_id column
select "SAMPLE_PURPOSE_ID", count(*) from sample_purpose group by "SAMPLE_PURPOSE_ID" having count(*)>1;

--to check sample_purpose_id is the primary_key column
SELECT column_name
FROM user_cons_columns
WHERE table_name = 'SAMPLE_PURPOSE'
AND constraint_name = (
    SELECT constraint_name
    FROM user_constraints
    WHERE table_name = 'SAMPLE_PURPOSE'
    AND constraint_type = 'P'
);