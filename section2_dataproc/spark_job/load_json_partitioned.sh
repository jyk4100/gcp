## create tables with schema jsons
## 2021-05-09
## dump to tables

bucket=gs://test-etl

data_date = '2019-04-30'

bq load --source_format=NEWLINE_DELIMITED_JSON  ^ 
 data_test.avg_delays_by_distance ^ 
 $bucket/flights_data_output/${data_date}"_distance_category/*.json" &&

bq load --source_format=NEWLINE_DELIMITED_JSON ^
 data_test.avg_delays_by_flight_nums ^
 $bucket/flights_data_output/${data_date}"_flight_nums/*.json"
