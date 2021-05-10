## create tables with schema jsons
## 2021-05-09
## nobash...

## powershell 
## C:/'Program Files (x86)'/Google/'Cloud SDK'/cloud_env.bat ## ggwp I give up

## cmder 
## cd C:/Program Files (x86)/Google/Cloud SDK/
## cloud_env.bat
## cd C:/Users/Kim Jungyoon/Documents/2.study/gcp-de/section2_dataproc/spark_job/
## "bq" not found...

## wsl ubuntu...
## cd /mnt/c/'Program Files (x86)'/Google/'Cloud SDK'/
## cloud_env.bat ## command not found need to install ubuntu GCloud SDK

## mingw shell
## cd C:/'Program Files (x86)'/Google/'Cloud SDK'/cloud_env.bat ## \s string breaks ggwp

bq mk -t \
--schema schema/avg_delay_flight_nums.json \
--time_partitioning_field flight_date data_test.avg_delays_by_flight_nums2 &&

bq mk -t \
--schema schema/avg_delays_by_distance.json \
--time_partitioning_field flight_date data_test.avg_delays_by_distance2