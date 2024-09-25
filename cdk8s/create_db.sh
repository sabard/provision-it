INSTANCE=provision-test
DATABASE=provision-test
USER=provision-user
PASSWORD=$PROVISION_PASSWORD


gcloud sql instances create $INSTANCE
gcloud sql databases create $DATABASE --instance $INSTANCE
gcloud sql users create $USER --host=% --instance=$INSTANCE --password=$PASSWORD



# connect
# IP=x.x.x.x
# mysql -h $IP -u $USER -p
# use $DATABASE

# - or -
# gcloud sql connect $INSTANCE -u $USER
# use $DATABASE
