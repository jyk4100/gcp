rem gcp-de study
rem create tables to store aggregate/average values
rem last modified: 2021-05-09

bucket = gs://test-etl
data_date = '2019-04-30'

ECHO OFF
CLS
ECHO laoding pyspark processed data into summary tables  ---------

bq load --source_format=NEWLINE_DELIMITED_JSON  ^ 
 data_test.avg_delays_by_distance ^ 
 $bucket/flights_data_output/${data_date}"_distance_category/*.json" && ^

bq load --source_format=NEWLINE_DELIMITED_JSON ^
 data_test.avg_delays_by_flight_nums ^
 $bucket/flights_data_output/${data_date}"_flight_nums/*.json"