rem gcp-de study
rem submit pyspark job
rem last modified: 2021-05-14

gcloud dataproc jobs submit pyspark ^ 4flights-etl.py --cluster=test-etl --region=us-central1
