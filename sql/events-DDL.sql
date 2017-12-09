DROP TABLE IF EXISTS events;
CREATE TABLE events
(
	hash_number_A INT,
	hash_tariff INT,
	event VARCHAR(15),
	event_sub VARCHAR(31),
	network_service_direction VARCHAR(15) null,
	event_start_date VARCHAR(31),
	LAT DOUBLE null,
	LON DOUBLE null,
	cost FLOAT null,
	hash_number_B int null,
	number_B_category VARCHAR(255) null,
	call_duration_minutes VARCHAR(15) null,
	data_volume_mb VARCHAR(15) null,
	hash_accum_code int null,
	device_type VARCHAR(15) null,
	phone_price_category TINYINT null,
	interest_1 VARCHAR(31) null,
	interest_2 VARCHAR(31) null,
	interest_3 VARCHAR(31) null,
	interest_4 VARCHAR(31) null,
	interest_5 VARCHAR(31) null
);
