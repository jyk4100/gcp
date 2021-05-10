rem 2021-05-09
rem .bat file instead of struggling with .sh files and bashes on windows
rem realized upon seeing .bat file opening error on mingw shell 

bq mk -t ^
--schema schema/avg_delay_flight_nums.json ^
--time_partitioning_field flight_date data_test.avg_delays_by_flight_nums2 ^
&& ^
bq mk -t ^
--schema schema/avg_delays_by_distance.json ^
--time_partitioning_field flight_date data_test.avg_delays_by_distance2


rem ECHO OFF
rem CLS
rem SET PATH=C:\Program Files (x86)\Google\Cloud SDK\google-cloud-sdk\bin;%PATH%;
rem cd C:\Program Files (x86)\Google\Cloud SDK
rem ECHO Welcome to the Google Cloud SDK! Run "gcloud -h" to get the list of available commands.
rem ECHO ---
rem ECHO ON
