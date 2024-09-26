Create sequence time_seq;
--Transfer the data from Staging_table to DW-location table
DECLARE
   CURSOR c_time IS
      SELECT DISTINCT
         "samplesampleDateTime"
      FROM staging_table;

   v_time_id NUMBER;
   v_sample_date DATE;
   v_year NUMBER;
   v_month NUMBER(2);
   v_week NUMBER(2);
   v_day NUMBER(2);

BEGIN
   FOR c_rec IN c_time LOOP
      -- Get the next value from the sequence for time_id
      v_time_id := time_seq.nextval;

      -- Derive values from the sampleSampleDateTime
      v_sample_date := TO_DATE(c_rec."samplesampleDateTime", 'YYYY-MM-DD"T"HH24:MI:SS');
      v_year := EXTRACT(YEAR FROM v_sample_date);
      v_month := EXTRACT(MONTH FROM v_sample_date);
      v_week := TO_NUMBER(TO_CHAR(v_sample_date, 'WW'));
      v_day := TO_NUMBER(TO_CHAR(v_sample_date, 'D'));

      -- Insert into TIME table
      INSERT INTO TIME (time_id, sample_date, year, month, week, day)
         VALUES (v_time_id, v_sample_date, v_year, v_month, v_week, v_day);
   END LOOP;
END;
/

commit;

select * from time;

select count(*) from time;

--Check if there is any duplicates in TIME_id column
select "TIME_ID", count(*) from TIME group by "TIME_ID" having count(*)>1;

select * from TIME where TIME_ID IS NULL;
--to check time_id is the primary_key column
SELECT column_name
FROM user_cons_columns
WHERE table_name = 'TIME'
AND constraint_name = (
    SELECT constraint_name
    FROM user_constraints
    WHERE table_name = 'TIME'
    AND constraint_type = 'P'
);
