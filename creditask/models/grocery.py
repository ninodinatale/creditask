from django.db import models

from .group import Group
from .base import BaseModel


class Grocery(BaseModel):
    name: str = models.CharField(max_length=30)
    in_cart: bool = models.BooleanField(default=True)
    info: str = models.CharField(max_length=30, default='')
    group: Group = models.ForeignKey(Group, on_delete=models.CASCADE)

    class Meta:
        db_table = 'groceries'
