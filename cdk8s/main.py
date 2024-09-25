#!/usr/bin/env python
from constructs import Construct
from cdk8s import App, Chart

from imports import k8s
from config import PROVISION_PORTS, PROVISION_IMAGE_URL, PROVISION_IMAGE_HASH

from container_server import ContainerServer

# PROVISION_IMAGE_HASH = (
#     "sha256:"
#     "234c4f0ae72e070b512e8aa4054fe80c25df5322c25cd1c0b4fff6b441937e5f"
# )

# SALT_PORTS = {4505: 4505, 4506: 4506}
# SALT_IMAGE_URL = "us-west1-docker.pkg.dev/soe-licorice/provision/provision"
# SALT_IMAGE_HASH = (
#     "sha256:"
#     "ff44c174444f8e556abf448f2ecad97b9d514c88d9d458c5fc5ec084ecb18ab3"
# )


class ContainerChart(Chart):
    def __init__(self, scope: Construct, chart_id: str):
        super().__init__(scope, chart_id)

        provision_image = f"{PROVISION_IMAGE_URL}@{PROVISION_IMAGE_HASH}"
        ContainerServer(
            self, chart_id, provision_image, PROVISION_PORTS, host_network=True
        )

        # salt_image = f"{SALT_IMAGE_URL}@{SALT_IMAGE_HASH}"
        # ContainerServer(
        #     self, chart_id, salt_image, SALT_PORTS, host_network=True
        # )


app = App()
ContainerChart(app, "provision")

app.synth()
