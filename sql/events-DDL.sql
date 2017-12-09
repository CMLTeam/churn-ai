DROP TABLE IF EXISTS events;
CREATE TABLE events
(
	hash_number_A INT,
	hash_tariff INT,
	event VARCHAR(15),
	event_sub VARCHAR(31),
	network_service_direction CHAR(1) NULL,
	event_start_date DATETIME,
	hash_b_number INT NULL,
	number_B_category VARCHAR(255) NULL,
	cost FLOAT NULL,
	call_duration_minutes FLOAT NULL,
	data_volume_mb DOUBLE NULL,
	hash_accum_code INT NULL,
	LAT DOUBLE NULL,
	LON DOUBLE NULL,
	device_type CHAR(1) NULL,
	phone_price_category TINYINT NULL,
	interest_1 VARCHAR(31) NULL,
	interest_2 VARCHAR(31) NULL,
	interest_3 VARCHAR(31) NULL,
	interest_4 VARCHAR(31) NULL,
	interest_5 VARCHAR(31) NULL,
	test_flag BOOL NULL,
	target BOOL NULL
);
