from typing import Dict, Optional

import jinja2
from starlite import Starlite, get
from starlite.connection.request import Request
from starlite.response import Response
import subprocess

from .database import init_db, Session
from .client import get_client_from_fields, update_client

MENU_FILE = "provision/menu.ipxe.j2"
CUSTOM_MENU_FILE = "provision/custom_menu.ipxe.j2"

AUTOINSTALL_PATH = "http://storage.googleapis.com/licorice/autoinstall"
PROVISION_TAG = subprocess.run(
    "git describe --tags".split(), capture_output=True
).stdout.decode().strip()
PROVISION_VERSION = subprocess.run(
    "git rev-parse --verify --short HEAD".split(), capture_output=True
).stdout.decode().strip()
print(subprocess.run(
    "git rev-parse --verify --short HEAD".split(), capture_output=True
).stderr)


@get("/ip")
async def get_ip(request: Request) -> Dict[str, str]:
    return {"client": {
        "host": request.client.host,
        "port": request.client.port
    }}

@get(["/", "/menu"])
async def menu(
    request: Request,
    hostname: Optional[str] = None,
    ip: Optional[str] = None,
    mac: Optional[str] = None
) -> str:
    with Session() as session:

        # look up config for given client
        if hostname or ip or mac:
            client = get_client_from_fields(
                {"hostname": hostname, "ip": ip, "mac": mac},
                session=session
            )
            if not client:
                return Response(
                    content="Client not found.", status_code=404
                )
            next_menu_item = client.next_menu_item
            if next_menu_item:
                default_menu_item = next_menu_item
                update_client(
                    client.id, {"next_menu_item": None},
                    session=session
                )
            else:
                default_menu_item = client.default_menu_item
        else:
            default_menu_item="local"

    template_kwargs = {
        "version": (
            PROVISION_VERSION if len(PROVISION_TAG) == 0 else
            f"{PROVISION_TAG} {PROVISION_VERSION}"
        ),
        "default_menu_item": default_menu_item,
        "install_options": [
            {
                "name": "meadow-focal",
                "description": "Install Ubuntu 20.04.5 LTS Focal (Meadow)",
                "efi": False,
                "kernel_path": f"{AUTOINSTALL_PATH}/legacy/ubuntu-focal/linux",
                "initrd_path": f"{AUTOINSTALL_PATH}/legacy/ubuntu-focal/initrd.gz",
                "preseed_path": f"{AUTOINSTALL_PATH}/legacy/ubuntu-focal/preseed-meadow.cfg",
            },
        ]
    }

    template = jinja2.Template(open(MENU_FILE, "r").read())
    return template.render(**template_kwargs)


@get("/chain_custom_menu")
async def chain_custom_menu(
    hostname: Optional[bool] = False,
    ip: Optional[bool] = False,
    mac: Optional[bool] = False
) -> str:

    query_params = []

    if hostname:
        query_params.append("hostname=${hostname}")

    if ip:
        query_params.append("ip=${ip}")

    if mac:
        query_params.append("mac=${mac}")

    if query_params:
        query_params = f"?{'&'.join(query_params)}"

    template = jinja2.Template(open(CUSTOM_MENU_FILE, "r").read())
    return template.render({"query_params": query_params or ""})

    return open(CUSTOM_MENU_FILE, "r").read()

app = Starlite(route_handlers=[get_ip, menu, chain_custom_menu])
init_db()
