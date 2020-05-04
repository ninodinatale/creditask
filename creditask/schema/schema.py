import graphql_jwt
from graphene import ObjectType, Schema, Field

from .task import TaskQuery, TaskMutation
from .user import UserQuery, UserType


#
# Queries
#
class Query(UserQuery, TaskQuery, ObjectType):
    pass


class ObtainJSONWebToken(graphql_jwt.JSONWebTokenMutation):
    user = Field(UserType)

    @classmethod
    def resolve(cls, root, info, **kwargs):
        return cls(user=info.context.user)


#
# Mutations
#
class Mutation(TaskMutation, ObjectType):
    token_auth = ObtainJSONWebToken.Field()
    verify_token = graphql_jwt.Verify.Field()
    refresh_token = graphql_jwt.Refresh.Field()


schema: Schema = Schema(query=Query, mutation=Mutation)
