TRUNCATE TABLE events;
LOAD DATA LOCAL INFILE 'bd_lab_small_sample.csv'
INTO TABLE events
CHARACTER SET 'utf8'
FIELDS TERMINATED BY ','
ENCLOSED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
	hash_number_A,
	hash_tariff,
	event,
	event_sub,
	network_service_direction,
	@sdate,
	hash_b_number,
	number_B_category,
	cost,
	call_duration_minutes,
	data_volume_mb,
	hash_accum_code,
	LAT,
	LON,
	device_type,
	phone_price_category,
	interest_1,
	interest_2,
	interest_3,
	interest_4,
	interest_5,
	test_flag,
	target
)
SET event_start_date = STR_TO_DATE(@sdate, '%d%b%y:%T');

