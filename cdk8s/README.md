# provision-it cdk8s deployment

## Setup

Install gcloud CLI and run setup script

```bash
./setup.sh
```

## Deployment

Load environment variables and call upload script:

```bash
set -a && . <env-file> && set +a
./upload.sh
```

## Developers
