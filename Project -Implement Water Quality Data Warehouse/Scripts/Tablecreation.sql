CREATE TABLE TIME (
    time_id NUMBER NOT NULL,
    sample_date DATE NOT NULL,  --@sampleSampleDateTime
    year NUMBER NOT NULL,
    month NUMBER(2) NOT NULL,
    week NUMBER(2) NOT NULL,
    day NUMBER(2) NOT NULL,
    CONSTRAINT PK_TIME PRIMARY KEY (time_id)
); 

CREATE TABLE WATER_SENSORS (
    sensor_id NUMBER NOT NULL,
    sensor_type VARCHAR(100) NOT NULL,   --@determinandDefinition
    notation NUMBER(10) NOT NULL,       --@determinandnotation
    unit VARCHAR(10) NOT NULL,          --@determinantUnitLabel
    CONSTRAINT PK_WATER_SENSORS PRIMARY KEY (sensor_id)
);
--Drop table water_sensors
create table SAMPLE_METHOD (
    sample_method_id NUMBER NOT NULL,
    sample_method_type VARCHAR(50) NOT NULL,   -- @samplesampleMaterialTypeLabel
    CONSTRAINT PK_SAMPLE_METHOD PRIMARY KEY (sample_method_id)
);


create table SAMPLE_PURPOSE (
    sample_purpose_id NUMBER NOT NULL,
    sample_purpose_type VARCHAR(100) NOT NULL,   -- @samplePurposeLabel
    CONSTRAINT PK_SAMPLE_PURPOSE PRIMARY KEY (sample_purpose_id)
);

create table LOCATION (
    location_id Number NOT NULL,
    location_name VARCHAR(100) NOT NULL, --@sampleSamplingPointLabel
    coordinate_easting NUMBER NOT NULL, --@samplesampleEasting
    coordinate_northing NUMBER NOT NULL,--@samplesampleNorthings
    CONSTRAINT PK_LOCATION PRIMARY KEY (location_id)
);
--Drop table location;
create table SAMPLE_FACT (
    sample_id NUMBER NOT NULL,
    time_id NUMBER NOT NULL,
    sensor_id NUMBER NOT NULL,
    sample_method_id NUMBER NOT NULL,
    sample_purpose_id NUMBER NOT NULL,
    location_id NUMBER NOT NULL,
    result BINARY_DOUBLE NOT NULL,           			--@result
    compliance NUMBER(1) DEFAULT 0 NOT NULL,		--@Compliance
    CONSTRAINT PK_SAMPLE_FACT PRIMARY KEY (sample_id),
    CONSTRAINT FK_TIME_ID FOREIGN KEY (time_id) REFERENCES time(time_id),
    CONSTRAINT FK_SENSOR_ID FOREIGN KEY (sensor_id) REFERENCES water_sensors(sensor_id),
    CONSTRAINT FK_SAMPLE_METHOD_ID FOREIGN KEY (sample_method_id) REFERENCES sample_method(sample_method_id),
    CONSTRAINT FK_SAMPLE_PURPOSE_ID FOREIGN KEY (sample_purpose_id) REFERENCES sample_purpose (sample_purpose_id),
    CONSTRAINT FK_LOCATION_ID FOREIGN KEY (location_id) REFERENCES "LOCATION"(location_id),
    CONSTRAINT CHECK_COMPLIANCE CHECK (compliance in (0,1))
);