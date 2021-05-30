rem gcp-de study
rem create tables to store aggregate/average values
rem last modified: 2021-05-09

rem set variables
set bucket=gs://test-etl
set upload_filename=2019-05-04

ECHO OFF
CLS
ECHO laoding pyspark processed data into summary tables  ---------

echo loading to tables--------------------- 

bq load --source_format=NEWLINE_DELIMITED_JSON ^
  data_test.avg_delays_by_distance ^
  %bucket%/flights_data_output/%upload_filename%_distance_category/*.json && ^

bq load --source_format=NEWLINE_DELIMITED_JSON ^
  data_test.avg_delays_by_flight_nums ^
  %bucket%/flights_data_output/%upload_filename%_flight_nums/*.json