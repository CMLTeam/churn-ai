DROP TABLE IF EXISTS events;
CREATE TABLE events
(
	hash_number_A INT,
	hash_tariff INT,
	event VARCHAR(15),
	event_sub VARCHAR(31),
	network_service_direction VARCHAR(15),
	event_start_date VARCHAR(31),
	hash_b_number INT,
	number_B_category VARCHAR(255),
	cost FLOAT,
	call_duration_minutes FLOAT,
	data_volume_mb DOUBLE,
	hash_accum_code INT,
	LAT DOUBLE,
	LON DOUBLE,
	device_type VARCHAR(15),
	phone_price_category TINYINT,
	interest_1 VARCHAR(31),
	interest_2 VARCHAR(31),
	interest_3 VARCHAR(31),
	interest_4 VARCHAR(31),
	interest_5 VARCHAR(31),
	test_flag TINYINT,
	target TINYINT
);
