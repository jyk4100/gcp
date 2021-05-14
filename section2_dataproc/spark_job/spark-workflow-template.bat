rem gcp-de study
rem submit pyspark job
rem last modified: 2021-05-14

rem line break in set variable i.e. set var1 = abc doesn't work...
set template_name=flights_etl
set cluster_name=test-etl
set bucket=gs://test-etl
set data_path=flights-data
set upload_filename=2019-05-04

rem gcloud dataproc workflow-templates delete -q $template_name  &&

gcloud beta dataproc workflow-templates create %template_name% --region 'us-east1-b' && ^^

rem rem data proc cluster creation part commented out to save cost
rem gcloud beta dataproc workflow-templates set-managed-cluster $template_name --zone "us-east1-b" \
rem --cluster-name=$cluster_name \
rem  --scopes=default \
rem  --master-machine-type n1-standard-2 \
rem  --master-boot-disk-size 20 \
rem   --num-workers 2 \
rem --worker-machine-type n1-standard-2 \
rem --worker-boot-disk-size 20 \
rem --image-version 1.3 &&

rem rem $bucket/spark-job/flights-etl.py 
rem rem dataproc spark job submit part commented out for cost
rem gcloud dataproc workflow-templates ^
rem 	add-job pyspark ^
rem 	step-id flight_delays_etl ^
rem 	workflow-template=$template_name && ^

gcloud beta dataproc workflow-templates instantiate $template_name && ^

bq load --source_format=NEWLINE_DELIMITED_JSON ^
  data_test.avg_delays_by_distance ^
  %bucket%/flights_data_output/%upload_filename%_distance_category/*.json && ^

bq load --source_format=NEWLINE_DELIMITED_JSON ^
  data_test.avg_delays_by_flight_nums ^
  %bucket%/flights_data_output/%upload_filename%_flight_nums/*.json



