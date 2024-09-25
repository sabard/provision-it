import os

PROVISION_PORTS = {80: 5000}
PROVISION_IMAGE_URL = "us-west1-docker.pkg.dev/soe-licorice/provision/provision"
PROVISION_IMAGE_HASH = os.environ["PROVISION_IMAGE_HASH"]
