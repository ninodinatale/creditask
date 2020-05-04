from graphene import Field, NonNull, Int
from graphene_django import DjangoObjectType
from graphql_jwt.decorators import login_required

from creditask.models import Approval


#
# Object Types
#
class ApprovalType(DjangoObjectType):
    class Meta:
        model = Approval


class ApprovalQuery:
    approval = Field(ApprovalType, id=NonNull(Int))

    @staticmethod
    @login_required
    def resolve_approval(self, info, **kwargs):
        # TODO
        return None
