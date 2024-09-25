from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker, scoped_session

from .settings import DATABASE_URI


engine = create_engine(
    DATABASE_URI, echo=True
)
Session = scoped_session(
    sessionmaker(autocommit=False, autoflush=False, bind=engine)
)


class Base(DeclarativeBase):
    pass


Base.query = Session.query_property()
Base.metadata.bind = engine

metadata = Base.metadata


def init_db():
    Base.metadata.create_all(engine)
