from sqlalchemy.orm import Mapped, mapped_column, Session as SessionType

from .database import Base, Session

import json
import sqlalchemy
from sqlalchemy.types import TypeDecorator


class SerializedDict(TypeDecorator):

    impl = sqlalchemy.Text()

    def process_bind_param(self, value, dialect):
        if value is not None:
            value = json.dumps(value)
        return value

    def process_result_value(self, value, dialect):
        if value is not None:
            value = json.loads(value)
        return value


class Deployment(Base):
    __tablename__ = "deployment"

    id: Mapped[int] = mapped_column(primary_key=True)
    system_info: Mapped[dict] = mapped_column(SerializedDict())
    jitter_results: Mapped[dict] = mapped_column(SerializedDict())

    def __repr__(self) -> str:
        return (
            f"Deployment(id={self.id!r}, system_info={self.system_info!r}, "
            f"jitter_results={self.jitter_results!r})"
        )


def create_deployment(deployment_fields: dict, session: SessionType = None):
    if not session:
        session = Session()
    with session:
        deployment = Deployment(
            system_info=deployment_fields["system_info"],
            jitter_results=deployment_fields["jitter_results"],
        )
        session.add(deployment)
        session.commit()
    return deployment


def update_deployment(deployment_id, deployment_fields: dict, session: SessionType = None):
    if not session:
        session = Session()
    with session:
        Deployment.query.filter_by(id=deployment_id).update(deployment_fields)
        session.commit()


def get_deployment(deployment_id: int, session: SessionType = None):
    if not session:
        session = Session()
    with session:
        deployment = Deployment.query.get(deployment_id)
        session.commit()
    return deployment


def get_deployment_from_fields(deployment_fields: dict, session: SessionType = None):
    if not session:
        session = Session()
    with session:
        deployment = Deployment.query.filter_by(**{
            k: v for k, v in deployment_fields.items() if v is not None
        }).first()
        session.commit()
    return deployment


