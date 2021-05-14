rem gcp-de study
rem create tables to store aggregate/average values
rem last modified: 2021-05-09
rem ++ bat file instead of struggling with sh files and bashes on windows
rem realized after hours of struggle with gcp+bash on windows and seeing .bat file opening error on mingw shell 

ECHO OFF
CLS

rem ++ set variable
set db_name=data_test

ECHO creating summary table on average flight delays ---------

bq mk -t ^
--schema schema/avg_delay_flight_nums.json ^
--time_partitioning_field flight_date %db_name%.avg_delays_by_flight_nums && ^
bq mk -t ^
--schema schema/avg_delays_by_distance.json ^
--time_partitioning_field flight_date %db_name%.avg_delays_by_distance