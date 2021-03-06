USE vodafone;

DROP TABLE IF EXISTS numbers;
CREATE TABLE IF NOT EXISTS numbers(
  hash_number_A INT PRIMARY KEY
);

TRUNCATE numbers;
INSERT INTO numbers
SELECT DISTINCT hash_number_A
FROM events WHERE hash_number_A <> 0;

DROP TABLE IF EXISTS dates;
CREATE TABLE IF NOT EXISTS dates(
  dd DATE PRIMARY KEY
);

TRUNCATE dates;
INSERT INTO dates
SELECT DISTINCT DATE(event_start_date)
FROM events
WHERE DATE(event_start_date) BETWEEN CAST('2017-07-01' AS DATE) AND CAST('2017-07-31' AS DATE);

DROP TABLE IF EXISTS `30days`;
CREATE TABLE IF NOT EXISTS `30days`(
  day INT PRIMARY KEY
);
TRUNCATE `30days`;
INSERT INTO `30days`
SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30;

DROP TABLE IF EXISTS current_event;
CREATE TABLE IF NOT EXISTS current_event(
  hash_number_A INT,
  dd DATE
);
TRUNCATE current_event;
INSERT INTO current_event
SELECT hash_number_A, dd
FROM numbers, dates;

CREATE UNIQUE INDEX ix_hd1 ON current_event(hash_number_A, dd);


DROP TABLE IF EXISTS events_of_interest;
CREATE TABLE iF NOT EXISTS events_of_interest(hash_number_A INT, previous_dd DATE, cost FLOAT);

TRUNCATE events_of_interest;
INSERT INTO events_of_interest 
SELECT DISTINCT hash_number_A, DATE(event_start_date) previous_dd, SUM(cost)
FROM events e
WHERE e.event = 'network_ser' AND e.event_sub = 'onnet_voice' AND e.network_service_direction = 'Outgoing'
GROUP BY hash_number_A, DATE(event_start_date);

CREATE UNIQUE INDEX ix_hpd1 ON events_of_interest(hash_number_A, previous_dd);

DROP TABLE IF EXISTS factors;
CREATE TABLE IF NOT EXISTS factors(
  hash_number_A INT,
  dd DATE,
  recency INT,
  frequency FLOAT,
  monetary FLOAT
);
TRUNCATE factors;

INSERT INTO factors
SELECT
  c.hash_number_A,
  c.dd AS dd,
  DATEDIFF(c.dd, MAX(e.previous_dd)) AS recency,
  SUM(CASE WHEN e.hash_number_A IS NOT NULL THEN 1 ELSE 0 END) AS frequency,
  SUM(e.cost) AS monetary
FROM current_event c LEFT JOIN events_of_interest e ON c.hash_number_A = e.hash_number_A
WHERE
  e.hash_number_A = c.hash_number_A AND
  e.previous_dd < c.dd AND
  e.previous_dd > DATE_SUB(c.dd, INTERVAL 30 DAY)
GROUP BY c.hash_number_A, c.dd;
CREATE UNIQUE INDEX ix_hd2 ON factors(hash_number_A, dd);

DROP TABLE IF EXISTS target;
CREATE TABLE IF NOT EXISTS target(
  hash_number_A INT,
  dd DATE,
  horyzon INT,
  t BOOLEAN
);
TRUNCATE target;

INSERT INTO target
SELECT
  c.hash_number_A AS hash_number_A,
  c.dd AS dd,
  d.day AS horyzon,
  (CASE WHEN i.hash_number_A IS NOT NULL THEN 1 ELSE 0 END) AS t
FROM
  current_event c
  CROSS JOIN `30days` d
  LEFT JOIN events_of_interest i
  ON c.hash_number_A = i.hash_number_A AND DATEDIFF(i.previous_dd, c.dd) = d.day;

CREATE UNIQUE INDEX ix_hd3 ON target(hash_number_A, dd, horyzon);

DROP TABLE IF EXISTS dataset;
CREATE TABLE IF NOT EXISTS dataset(
  hash_number_A INT,
  dd DATE,
  horyzon INT,
  t BOOLEAN,
  recency INT,
  frequency FLOAT,
  monetary FLOAT
);
TRUNCATE dataset;

INSERT INTO dataset
SELECT
  t.hash_number_A,
  t.dd,
  t.horyzon,
  t.t,
  f.recency,
  f.frequency,
  f.monetary
FROM target t INNER JOIN factors f ON t.hash_number_A = f.hash_number_A AND t.dd = f.dd;

