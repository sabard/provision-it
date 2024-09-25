"""add next_menu_item to client

Revision ID: 844f8db88172
Revises: 45a83a328ad7
Create Date: 2023-05-06 20:42:20.985805

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '844f8db88172'
down_revision = '45a83a328ad7'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('client', sa.Column('next_menu_item', sa.String(length=16), nullable=True))
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('client', 'next_menu_item')
    # ### end Alembic commands ###