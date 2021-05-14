rem gcp-de study
rem bat script for uploading json from local to the bucket
rem last modified: 2021-05-09
rem ++ testing echos off -> comments not shown and only lines after echo are displayed

rem cd C:/Users/Kim Jungyoon/Documents/2.study/gcp-de/section2_dataproc/spark_job/ 

ECHO OFF
CLS

rem ++ set variable
set "data_path=flights-data"

ECHO dumping local json files to gcp buckets ---------

rem should be run programmatically but ez solution for now
gsutil cp json-files/2019-05-04.json gs://test-etl/%data_path% && ^
gsutil cp json-files/2019-05-05.json gs://test-etl/%data_path%

rem TBD: get error code or conditional execution then "log" status?