##$ udemy data-engineering-on-google-cloud-platform/
##$ 2021-05-09: section2 data proc cluster

## windows shell clear: cls
## initialization wari gari ;; ## course basd on previous interface being really careful not to click and get billed;;

## initialization-actions not available?
gsutil ls gs://dataproc-initialization-actions
## apache-zeppelin, conda, dask, h20, hue, jupyter, python, rstudio, solr woo

## initialization complains that this bucket doesn't exist... but can't create the bucket "locally"...
gsutil ls gs://dataproc-initialization-actions/jupyter
gsutil mb gs://dataproc-initialization-actions ## bucket name not globally unique....

# gsutil mb gs://[BUCKET_NAME] // Create a bucket e.g. `gsutil mb gs://my_bucket`
# gsutil ls gs://[BUCKET_NAME] // View contents of a bucket e.g. `gsutil ls gs://my_bucket`
# gsutil cp [MY_FILE] gs://[BUCKET_NAME] // Copy file from Cloud Shell VM to a bucket
# gsutil cp ‘my file.txt' gs://[BUCKET_NAME] // If filename has whitespaces, ensure to place single quotes around the filename

## and... https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/init-actions explains copy to "local"
gsutil 
gsutil cp gs://goog-dataproc-initialization-actions-us-east1/jupyter/jupyter.sh gs://test-etl
gsutil rm -r gs://dataproc-staging-us-central1-817654930415-8fwrvesc/
gsutil rm -r gs://dataproc-temp-us-central1-817654930415-j9xwqclb/

## cmd for dataproc cluster and fails again and again with initilaization
gcloud dataproc clusters create spark-etl ^
 --scopes=default ^
 --initialization-actions=gs://test-etl/jupyter.sh ^
 --enable-component-gateway --region us-east1 --zone us-east1-b ^
 --master-machine-type n1-standard-2 --master-boot-disk-size 200 --num-workers 2 ^
 --worker-machine-type n1-standard-2 --worker-boot-disk-size 200 ^
 --image-version 1.3 ^
 --project gcp-etl-prac

## cmd for dataproc cluster creation according to course resource
gcloud dataproc clusters create spark-dwh ^
 --scopes=default ^
 --region "us-east1" --zone "us-east1-b" ^
 --initialization-actions=gs://dataproc-initialization-actions/jupyter/jupyter.sh ^
 --master-machine-type n1-standard-2 ^
 --master-boot-disk-size 200 ^
 --num-workers 2 ^
 --worker-machine-type n1-standard-2 ^
 --worker-boot-disk-size 200 ^
 --image-version 1.3

## dump json files again
cd C:/Users/Kim Jungyoon/Documents/2.study/gcp-de/secion2_loading_data/json-files/

## ggwp and use web interface ## beta install required?? ## component vs initialization??
gcloud beta dataproc clusters create spark-etl ^
  --enable-component-gateway ^
  --optional-components JUPYTER ^
  --region us-east1 --zone us-east1-c ^
  --master-machine-type custom-1-3840 --master-boot-disk-size 100 --num-workers 2 ^
  --worker-machine-type custom-2-7680 --worker-boot-disk-size 100 ^
  --image-version 2.0-debian10 ^
  --project gcp-etl-prac
