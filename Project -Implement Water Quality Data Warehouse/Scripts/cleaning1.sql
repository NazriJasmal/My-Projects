--Duplicate check using the main columns without "samplesampleDateTime"
SELECT
  "samplesamplingPointlabel",
  "determinanddefinition",
  "result",
  "determinandunitlabel",
  "samplesampledMaterialTypelabel",
  "sampleisComplianceSample",
  "samplepurposelabel",
  COUNT(*) AS "DuplicateCount"
FROM
  staging_table
GROUP BY
  
  "samplesamplingPointlabel",
  "determinanddefinition",
  "result",
  "determinandunitlabel",
  "samplesampledMaterialTypelabel",
  "sampleisComplianceSample",
  "samplepurposelabel"
HAVING
  COUNT(*) > 1 order by "DuplicateCount" desc;


--Duplicate check using the main columns with  "samplesampleDateTime"
SELECT
  "samplesamplingPointlabel",
  "samplesampleDateTime",
  "determinanddefinition",
  "result",
  "determinandunitlabel",
  "samplesampledMaterialTypelabel",
  "sampleisComplianceSample",
  "samplepurposelabel",
  COUNT(*) AS "DuplicateCount"
FROM
  staging_table
GROUP BY
  
  "samplesamplingPointlabel",
  "samplesampleDateTime",
  "determinanddefinition",
  "result",
  "determinandunitlabel",
  "samplesampledMaterialTypelabel",
  "sampleisComplianceSample",
  "samplepurposelabel"
HAVING
  COUNT(*) > 1;
  

--Check duplicates in the @id columns  
SELECT "@id", COUNT(*) AS "DuplicateCount"
FROM staging_table GROUP BY "@id" HAVING COUNT(*) > 1;

  
 --Removing the url part of @id column as this column does not have any duplicates. 
 --We can consider this as a primary key
UPDATE staging_table
SET "@id" = SUBSTR("@id", INSTR("@id", '/', -1) + 1);

--Removing the columns id, id1 as this column have the duplicates from merging all tables from _2000 to _2016
ALTER TABLE staging_table
DROP COLUMN ID;

ALTER TABLE staging_table
DROP COLUMN ID1;

--check missing values on the @id column
select count(*) from staging_table where "@id" is null;

--Drop all unwanted columns according to the schema
ALTER table "STAGING_TABLE" DROP ("@id" , "samplesamplingPoint", "determinandlabel", 
"resultQualifiernotation","codedResultInterpretationinterpretation", "samplesamplingPointnotation");

--Check the missing values in each column
SELECT 
    COUNT(CASE WHEN "samplesamplingPointlabel" IS NULL THEN 1 END) AS SAMPLING_POINT_LABEL_missing_count,
     COUNT(CASE WHEN "samplesampleDateTime" IS NULL THEN 1 END) AS sampleDateTime_missing_count,
    COUNT(CASE WHEN "determinanddefinition" IS NULL THEN 1 END) AS DETERMINAND_DEFINITION_missing_count,
    COUNT(CASE WHEN "determinandnotation" IS NULL THEN 1 END) AS DETERMINAND_NOTATION_missing_count,
    COUNT(CASE WHEN "result" IS NULL THEN 1 END) AS RESULT_missing_count,
    COUNT(CASE WHEN "determinandunitlabel" IS NULL THEN 1 END) AS DETERMINAND_UNIT_missing_count,
    COUNT(CASE WHEN "samplesampledMaterialTypelabel" IS NULL THEN 1 END) AS SAMPLE_MATERIAL_TYPE_missing_count,
    COUNT(CASE WHEN "samplepurposelabel" IS NULL THEN 1 END) AS SAMPLE_PURPOSE_LABEL_missing_count,
    COUNT(CASE WHEN "sampleisComplianceSample" IS NULL THEN 1 END) AS sampleisComplianceSample_count,
    COUNT(CASE WHEN "samplesamplingPointeasting" IS NULL THEN 1 END) AS SAMPLING_POINT_EASTING_missing_count,
    COUNT(CASE WHEN "samplesamplingPointnorthing" IS NULL THEN 1 END) AS SAMPLING_POINT_NORTHING_missing_count
FROM Staging_table;


--Remove colons from determinanddefinition
UPDATE staging_table
SET "determinanddefinition" = REPLACE("determinanddefinition", ':', '');


UPDATE staging_table
SET "determinanddefinition" = REPLACE("determinanddefinition", ':-', '');

select * from staging_table;











