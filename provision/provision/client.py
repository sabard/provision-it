from typing import Optional

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, Session as SessionType

from .database import Base, Session


class Client(Base):
    __tablename__ = "client"

    id: Mapped[int] = mapped_column(primary_key=True)
    hostname: Mapped[Optional[str]] = mapped_column(String(253), unique=True)
    ip: Mapped[Optional[str]] = mapped_column(String(45))
    mac: Mapped[Optional[str]] = mapped_column(String(17), unique=True)
    default_menu_item: Mapped[Optional[str]] = mapped_column(String(16))
    next_menu_item: Mapped[Optional[str]] = mapped_column(String(16))

    def __repr__(self) -> str:
        return (
            f"Client(id={self.id!r}, hostname={self.hostname!r}, "
            f"ip={self.ip!r}, mac={self.mac!r}, "
            f"default_menu_item={self.default_menu_item!r})"
        )


def create_client(client_fields: dict, session: SessionType = None):
    if not session:
        session = Session()
    with session:
        client = Client(
            hostname=client_fields["hostname"],
            ip=client_fields["ip"],
            mac=client_fields["mac"],
            default_menu_item=client_fields["default_menu_item"],
            next_menu_item=client_fields.get("next_menu_item"),
        )
        session.add(client)
        session.commit()
    return client


def update_client(client_id, client_fields: dict, session: SessionType = None):
    if not session:
        session = Session()
    with session:
        Client.query.filter_by(id=client_id).update(client_fields)
        session.commit()


def get_client(client_id: int, session: SessionType = None):
    if not session:
        session = Session()
    with session:
        client = Client.query.get(client_id)
        session.commit()
    return client


def get_client_from_fields(client_fields: dict, session: SessionType = None):
    if not session:
        session = Session()
    with session:
        client = Client.query.filter_by(**{
            k: v for k, v in client_fields.items() if v is not None
        }).first()
    session.commit()
    return client


