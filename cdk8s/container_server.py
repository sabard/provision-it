from constructs import Construct
from cdk8s_plus_25 import Secret

from imports import k8s


class ContainerServer(Construct):
    def __init__(
        self, scope, name, image, ports, env_dict={}, host_network=False
    ):
        super().__init__(scope, name)

        label = {"app": name}

        service_ports = [
            k8s.ServicePort(
                port=k,
                target_port=k8s.IntOrString.from_number(v)
            ) for k, v in ports.items()
        ]

        k8s.KubeService(
            self,
            "service",
            spec=k8s.ServiceSpec(
                type="LoadBalancer",
                ports=service_ports,
                selector=label
            )
        )

        Secret.from_secret_name(
            scope, "provision-creds", "provision-creds"
        )

        Secret.from_secret_name(
            scope, "provision-db", "provision-db"
        )

        cred_volume = k8s.Volume(
            name="gcloud-volume",
            secret=k8s.SecretVolumeSource(
                # items=[
                #     k8s.KeyToPath(
                #         key="GOOGLE_APPLICATION_CREDENTIALS",
                #         path="gcloud_creds.json"
                #     )
                # ],
                secret_name="provision-creds"
            )
        )

        deployment_ports = [
            k8s.ContainerPort(container_port=v) for _, v in ports.items()
        ]

        k8s.KubeDeployment(
            self,
            "deployment",
            spec=k8s.DeploymentSpec(
                replicas=1,
                selector=k8s.LabelSelector(match_labels=label),
                template=k8s.PodTemplateSpec(
                    metadata=k8s.ObjectMeta(labels=label),
                    spec=k8s.PodSpec(
                        containers=[k8s.Container(
                            name="provision",
                            image=image,
                            ports=deployment_ports,
                            # env_from=[k8s.EnvFromSource(secret_ref=k8s.SecretEnvSource(name="provision-secrets"))],
                            env=[
                                k8s.EnvVar(
                                    name="PROVISION_DATABASE_URI",
                                    value_from=k8s.EnvVarSource(secret_key_ref=k8s.SecretKeySelector(key="PROVISION_DATABASE_URI", name="provision-db"))
                                ),
                                k8s.EnvVar(
                                    name="GOOGLE_APPLICATION_CREDENTIALS",
                                    value="/tmp/keys/GOOGLE_APPLICATION_CREDENTIALS"
                                )
                            ],
                            volume_mounts=[k8s.VolumeMount(
                                name="gcloud-volume",
                                mount_path="/tmp/keys",
                                read_only=True
                            )]
                        )],
                        host_network=host_network,
                        volumes=[cred_volume],
                    )
                )
            )
        )

