from graphene import Field, NonNull, ID
from graphene_django import DjangoObjectType

from creditask.models import TaskGroup


#
# Object Types
#
class TaskGroupType(DjangoObjectType):
    class Meta:
        model = TaskGroup


class TaskGroupQuery:
    task_group = Field(TaskGroupType, id=NonNull(ID))
