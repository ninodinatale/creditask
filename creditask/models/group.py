from .base import BaseModel


class Group(BaseModel):
    class Meta:
        db_table = 'groups'
