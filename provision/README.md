# LiCoRICE Provision HTTP Server

## Containers

The app can be built and run using docker as follows:

```bash
docker build -t provision .
CONTAINER_ID=$(docker run -d -p 5000:5000 --env PROVISION_DATABASE_URI=<database_uri> provision)
```

Note: you will need to supply the server with a database URI that it can use. This could be a SQLite database URL or anything else supported by SQLAlchemy.

Then, the container can be stopped with:

```bash
docker stop $CONTAINER_ID
```

## Developers

### Setup

Simply run the `setup.sh` script to set up pyenv and a virtualenv:

```bash
./setup.sh
```

Then make sure you have correct access to the `soe-licorice` project on GCP and setup GCP Docker auth with:

```bash
gcloud auth configure-docker us-west1-docker.pkg.dev
```

### Making changes

If any packages need to be added or updated, make the needed changes in `requirements.in` and run the update script:

```bash
./update-deps.sh
```

### Running the server locally

```bash
./run.sh
```

### Uploading your changes

The upload script builds the app in a container and uploads that container image to the GCP artifact registry.

```bash
./upload
```
