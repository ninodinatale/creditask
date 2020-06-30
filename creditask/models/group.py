from django.db import models

from .base import BaseModel


class Group(BaseModel):
    # TODO test this overriden property
    created_by = models.ForeignKey('User', related_name='+',
                                   null=True,
                                   on_delete=models.SET_NULL)

    class Meta:
        db_table = 'groups'
