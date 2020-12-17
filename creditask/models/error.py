from django.db import models

from .base import BaseModel
from .user import User


class Error(BaseModel):
    user: User = models.ForeignKey(User, on_delete=models.CASCADE)
    stack_trace: str = models.TextField()

    class Meta:
        db_table = 'errors'
