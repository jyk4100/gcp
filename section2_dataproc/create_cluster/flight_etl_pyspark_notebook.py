## 2021-05-09
## finally able to create data proc cluster with "resource" on web ui instead of initialization

## import pyspark ## took forever but no need
## pyspark.__version__

from pyspark import SparkContext 
from pyspark.sql import SQLContext

from pyspark.conf import SparkConf
from pyspark.sql.session import SparkSession

sc ## SparkContext() ## already defined with pyspark notebook

spark ## SQLContext(sc) ## already defined with pyspark notebook

## uhh I h notebook run cell by cell...
bucket_name = "gs://test-etl/"
filename = "2019-04-30"
flights_data = spark.read.json(bucket_name+filename+".json")
flights_data.show(10)
flights_data.registerTempTable("flights_data")

## query on temptable
qry = """
        select 
            flight_date , 
            round(avg(arrival_delay),2) as avg_arrival_delay,
            round(avg(departure_delay),2) as avg_departure_delay,
            flight_num 
        from 
            flights_data 
        group by 
            flight_num , 
            flight_date 
      """
## execute query
avg_delays_by_flight_nums = spark.sql(qry)
avg_delays_by_flight_nums.show(5)

# output_flight_nums = bucket_name+"/flights_data_output/"+file_name+"_flight_nums"
# output_distance_category = bucket_name+"/flights_data_output/"+file_name+"_distance_category"
# avg_delays_by_flight_nums.coalesce(1).write.format("json").save(output_flight_nums)
# avg_delays_by_distance_category.coalesce(1).write.format("json").save(output_distance_category)

avg_delays_by_flight_nums.coalesce(1).write.format("json").save("gs://test-etl/avg_delays_pyspark.json")

## and saves typicall spark way of saving file name like this before even after coalesce I don't get this...
## avg_delays_pyspark.json/part-00000-c9e177f7-dc3b-410a-9292-1f8b8e1c4a00-c000.json