##$ udemy data-engineering-on-google-cloud-platform/
##$ 2021-05-03: section2 loading data

## ls buckets
gsutil ls gs://test-etl

## table created through web UI but this is the command?
Load gs://test-etl/2019-04-27.json to gcp-etl-prac:data_test.flights_temp

## anaconda python distribution doesn't work with gcp sdk.....

## set path so that cmd can pick up schema definition in json file from local
cd C:/Users/Kim Jungyoon/Documents/2.study/gcp-de/

## ls buckets (https://cloud.google.com/storage/docs/gsutil/commands/ls)
gsutil ls gs://test-etl

## table created through web UI but this is the command?
Load gs://test-etl/2019-04-27.json to gcp-etl-prac:data_test.flights_temp

## 윈도우 쉘이라고 \ 안먹히는거 실화 ㅋㅋㅋㅋㅋㅋㅋ
bq mk -t --schema schema.json data_test.flight_delays_json_non_partitioned

## create empty schema from a json file
bq mk -t --schema schema.json ^
  data_test.flight_delays_json_non_partitioned ## && 

## load data into table 
bq load --source_format=NEWLINE_DELIMITED_JSON ^
  data_test.flight_delays_json_non_partitioned ^
  gs://test-etl/2019-04-27.json

## otherwise auto detect/define schema from the input
bq load --source_format=NEWLINE_DELIMITED_JSON --autodetect ^
  data_test.flight_delays_json_non_partitioned ^
  gs://test-etl/2019-04-27.json

## required vs nullable on the json schema 
## bq command for csv file basically same
## partitioning data: https://cloud.google.com/bigquery/docs/partitioned-tables?_ga=2.203658896.-1095196622.1620094460)
## gcp billing based on data scan so partition table e.g. based on column (date-column) or partition based on ingestion time (not part of the table but will add “createddate” like column) more efficient and saves cost

## cmd for creating table with partition on date and loading data
bq mk -t --schema schema.json --time_partitioning_field flight_date data_test.flight_delays_partitioned
bq load --source_format=NEWLINE_DELIMITED_JSON data_test.flight_delays_partitioned gs://test-etl/2019-04-27.json
bq load --source_format=NEWLINE_DELIMITED_JSON data_test.flight_delays_partitioned gs://test-etl/2019-04-28.json

## can also query with bq?
bq query --use_legacy_sql=false "SELECT * FROM `data_test.flight_delays_partitioned` WHERE flight_date = '2019-04-27' LIMIT 10"
## guess can be used to programmatically to load to table, query report