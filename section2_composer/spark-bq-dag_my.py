## airflow script instead of workflow template that never ran ETE....
## jyk4100
## last modified: 2021-05-16

from datetime import datetime, timedelta , date 
from airflow import models,DAG 
from airflow.contrib.operators.dataproc_operator import DataprocClusterCreateOperator,DataProcPySparkOperator,DataprocClusterDeleteOperator
from airflow.contrib.operators.gcs_to_bq import GoogleCloudStorageToBigQueryOperator
from airflow.operators import BashOperator 
from airflow.models import *
from airflow.utils.trigger_rule import TriggerRule

# data_date = str(date.today())
PROJECT_ID = "gcp-etl-prac" ## project id != project name okay...
BUCKET = "test-etl" ## doen'st require gs:// anymore??
PYSPARK_JOB = BUCKET + "/4flights-etl.py" ## pass full "url" gs://test-etl/flights-data...
data_date = "2019-05-04"
table_name = "data_test"

DEFAULT_DAG_ARGS = {
    'owner':"airflow",
    'depends_on_past': False,
    "start_date": datetime.utcnow(),
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0, ## how many time to retry
    "retry_delay": timedelta(minutes=5),
    "project_id": PROJECT_ID,
    "scheduled_interval": "00 1 * * *" 
    ## crontab syntax min/hour/day/month/dayofweek: https://crontab.guru/#5_4_*_*_*
}

with DAG("flights_delay_etl", default_args=DEFAULT_DAG_ARGS) as dag : 

    create_cluster = DataprocClusterCreateOperator(
        task_id ="create_dataproc_cluster",
        cluster_name="ephemeral-spark-cluster-{{ds_nodash}}",
        master_machine_type="n1-standard-2",
        ## create cluster with n1-standard-1 not allowed??
        ## error message/log props under task instance details/log
        ## airflow log doesn't show each tasks message/log?
        worker_machine_type="n1-standard-2",
        num_workers=2,
        region="us-east1",
        zone ="us-east1-b"
    )

    submit_pyspark = DataProcPySparkOperator(
        task_id = "run_pyspark_etl",
        main = PYSPARK_JOB,
        cluster_name="ephemeral-spark-cluster-{{ds_nodash}}",
        region="us-east1"
    )

    bq_load_delays_by_distance = GoogleCloudStorageToBigQueryOperator(
        task_id = "bq_load_avg_delays_by_distance",
        bucket=BUCKET,
        source_objects=["flights_data_output/"+data_date+"_distance_category/part-*"],
        destination_project_dataset_table=PROJECT_ID+"."+table_name+".avg_delays_by_distance",
        autodetect = True,
        ## if schema set with required field then error??
        source_format="NEWLINE_DELIMITED_JSON",
        create_disposition="CREATE_IF_NEEDED",
        skip_leading_rows=0,
        write_disposition="WRITE_APPEND",
        max_bad_records=0
    )

    bq_load_delays_by_flight_nums = GoogleCloudStorageToBigQueryOperator(
        task_id = "bq_load_delays_by_flight_nums",
        bucket=BUCKET,
        source_objects=["flights_data_output/"+data_date+"_flight_nums/part-*"],
        destination_project_dataset_table=PROJECT_ID+"."+table_name+".avg_delays_by_flight_nums",
        autodetect = True,
        source_format="NEWLINE_DELIMITED_JSON",
        create_disposition="CREATE_IF_NEEDED",
        skip_leading_rows=0,
        write_disposition="WRITE_APPEND",
        max_bad_records=0
    )

    delete_cluster = DataprocClusterDeleteOperator(
        task_id ="delete_dataproc_cluster",
        cluster_name="ephemeral-spark-cluster-{{ds_nodash}}",
        region="us-east1",
        trigger_rule = TriggerRule.ALL_DONE
    )

    delete_tranformed_files = BashOperator(
        task_id = "delete_tranformed_files",
        bash_command = "gsutil -m rm -r " + BUCKET + "/flights_data_output/*"
    )

    create_cluster.dag = dag
    create_cluster.set_downstream(submit_pyspark)
    submit_pyspark.set_downstream([bq_load_delays_by_flight_nums, bq_load_delays_by_distance, delete_cluster])
    delete_cluster.set_downstream(delete_tranformed_files)

    # # testing just the upload portion after clusters creation finally success
    # bq_load_delays_by_flight_nums.dag = dag
    # bq_load_delays_by_flight_nums.set_downstream(bq_load_delays_by_distance)
