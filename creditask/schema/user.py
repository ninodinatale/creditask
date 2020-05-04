from graphene import NonNull, Int, Field, List, String
from graphene_django import DjangoObjectType
from graphql_jwt.decorators import login_required

from creditask.models import User

from creditask.services.user_service import get_other_users


#
# Query Types
#
class UserType(DjangoObjectType):
    class Meta:
        model = User


class UserQuery:
    user = Field(UserType, id=NonNull(Int))
    other_users = List(NonNull(UserType), user_email=NonNull(String))

    @staticmethod
    @login_required
    def resolve_other_users(self, info, **kwargs):
        return get_other_users(kwargs.get('user_email'))
