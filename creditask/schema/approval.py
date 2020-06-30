from graphene_django.types import DjangoObjectType

from creditask.models import Approval


#
# Object Types
#
class ApprovalType(DjangoObjectType):
    class Meta:
        model = Approval
