import graphene
import graphene_django
import graphql
import graphql_jwt

from creditask.models import User, ApprovalState, TaskState, Approval, \
    Task
from creditask.models.enums import ChangeableTaskProperty
from .scalars import custom_string, custom_float
from ..services import get_task_changes, save_approval, \
     get_todo_tasks_by_user_email, get_task_by_id, \
    get_to_approve_tasks_of_user, save_task, get_users, \
    get_other_users


class UserType(graphene_django.DjangoObjectType):
    class Meta:
        model = User


class CurrentUserType(graphene.ObjectType):
    id = graphene.NonNull(graphene.ID)
    email = graphene.NonNull(graphene.String)
    public_name = graphene.NonNull(graphene.String)


class TaskChangeType(graphene.ObjectType):
    current_value = graphene.String()
    previous_value = graphene.String()
    user = graphene.NonNull(UserType)
    timestamp = graphene.NonNull(graphene.DateTime)
    changed_property = graphene.Field(
        graphene.Enum.from_enum(ChangeableTaskProperty))


class ApprovalScalars:
    state = graphene.Enum.from_enum(ApprovalState)
    task_id = graphene.ID
    user_id = graphene.ID


class ApprovalType(graphene_django.DjangoObjectType):
    # implicitly declaring state here instead of inheriting from model Task
    # because graphql schema generation creates different enums from
    # `CharField`'s `choices` and actual enum. This is only a problem because
    # we use the scalar "task state" for inputs as well. This makes sure that
    # we can use the same enum for the query and the mutation.
    state = graphene.NonNull(ApprovalScalars.state)

    class Meta:
        convert_choices_to_enum = False
        model = Approval


class TaskScalars:
    id = graphene.ID
    state = graphene.Enum.from_enum(TaskState)
    name = custom_string(min_len=3, max_len=30)
    factor = custom_float(min_value=1)
    user_id = graphene.ID
    needed_time_seconds = graphene.Int
    period_start = graphene.Date
    period_end = graphene.Date


class TaskType(graphene_django.DjangoObjectType):
    changes = graphene.NonNull(graphene.List(graphene.NonNull(TaskChangeType)))
    approvals = graphene.NonNull(graphene.List(graphene.NonNull(ApprovalType)))

    # implicitly declaring state here instead of inheriting from model Task
    # because graphql schema generation creates different enums from
    # `CharField`'s `choices` and actual enum. This is only a problem because
    # we use the scalar "task state" for inputs as well. This makes sure that
    # we can use the same enum for the query and the mutation.
    state = graphene.NonNull(TaskScalars.state)

    @staticmethod
    @graphql_jwt.decorators.login_required
    def resolve_changes(parent: Task, info: graphql.ResolveInfo):
        return get_task_changes(parent)

    @staticmethod
    @graphql_jwt.decorators.login_required
    def resolve_approvals(parent: Task, info: graphql.ResolveInfo):
        return parent.approvals.all()

    class Meta:
        convert_choices_to_enum = False
        model = Task


class TaskQuery:
    task = graphene.NonNull(TaskType, id=graphene.NonNull(graphene.ID))
    todo_tasks_of_user = graphene.NonNull(
        graphene.List(graphene.NonNull(TaskType)),
        user_email=graphene.NonNull(graphene.String))
    to_approve_tasks_of_user = graphene.NonNull(
        graphene.List(graphene.NonNull(TaskType)),
        user_email=graphene.NonNull(graphene.String))

    @staticmethod
    @graphql_jwt.decorators.login_required
    def resolve_task(self, info, **kwargs):
        return get_task_by_id(kwargs.get('id'))

    @staticmethod
    @graphql_jwt.decorators.login_required
    def resolve_todo_tasks_of_user(self, info, **kwargs):
        return get_todo_tasks_by_user_email(kwargs.get('user_email'))

    @staticmethod
    @graphql_jwt.decorators.login_required
    def resolve_to_approve_tasks_of_user(self, info, **kwargs):
        return get_to_approve_tasks_of_user(kwargs.get('user_email'))


class TaskInputCreate(graphene.InputObjectType):
    name = graphene.NonNull(TaskScalars.name)
    factor = graphene.NonNull(TaskScalars.factor)
    user_id = TaskScalars.user_id()
    period_start = TaskScalars.period_start()
    period_end = TaskScalars.period_end()


class TaskInputUpdate(graphene.InputObjectType):
    id = graphene.NonNull(TaskScalars.id)  # TODO test
    state = TaskScalars.state()
    name = TaskScalars.name()
    factor = TaskScalars.factor()
    user_id = TaskScalars.user_id()
    needed_time_seconds = TaskScalars.needed_time_seconds()
    period_start = TaskScalars.period_start()
    period_end = TaskScalars.period_end()


class SaveTask(graphene.Mutation):
    class Arguments:
        create_input = TaskInputCreate()
        update_input = TaskInputUpdate()

    task = graphene.NonNull(TaskType)

    @staticmethod
    @graphql_jwt.decorators.login_required
    def mutate(root, info, create_input=None, update_input=None):
        if create_input is None and update_input is None:
            raise graphql.GraphQLError(
                'Either create_input or update_input need '
                'to be set')

        if create_input is not None and update_input is not None:
            raise graphql.GraphQLError(
                'Only one of create_input or update_input '
                'may be set')

        input = create_input or update_input or dict()
        task = save_task(info.context.user, **input)
        return SaveTask(task=task)


#
# Mutations
#
class TaskMutation:
    save_task = SaveTask.Field()


class ApprovalInput(graphene.InputObjectType):
    id = graphene.NonNull(graphene.ID)
    state = graphene.NonNull(ApprovalScalars.state)


# TODO TEST
class SaveApproval(graphene.Mutation):
    class Arguments:
        input = graphene.NonNull(ApprovalInput)

    approval = graphene.NonNull(ApprovalType)

    @staticmethod
    @graphql_jwt.decorators.login_required
    def mutate(root, info, approval_input: ApprovalInput()):
        if info.context.user.id is not approval_input.user_id:
            raise AssertionError(
                'logged in user must be the same as the user\'s approval')
        approval = save_approval(approval_input.id, approval_input.state)
        return SaveApproval(approval=approval)


class ApprovalMutation:
    save_approval = SaveApproval.Field()


class UserQuery:
    user = graphene.Field(UserType, id=graphene.NonNull(graphene.Int))
    users = graphene.List(graphene.NonNull(UserType))
    other_users = graphene.List(graphene.NonNull(UserType),
                                user_email=graphene.NonNull(graphene.String))

    @staticmethod
    @graphql_jwt.decorators.login_required
    def resolve_users(self, info, **kwargs):
        return get_users(info.context.user.group_id)

    @staticmethod
    @graphql_jwt.decorators.login_required
    def resolve_other_users(self, info, **kwargs):
        return get_other_users(kwargs.get('user_email'))


class Query(UserQuery, TaskQuery, graphene.ObjectType):
    pass


class ObtainJSONWebToken(graphql_jwt.JSONWebTokenMutation):
    user = graphene.Field(UserType)

    @classmethod
    def resolve(cls, root, info, **kwargs):
        return cls(user=info.context.user)


class VerifyJSONWebToken(graphql_jwt.Verify):
    user = graphene.Field(UserType)

    # @classmethod
    # def mutate(cls, root, info, token, **kwargs):
    #     value = super().mutate(root, info, token, **kwargs)
    #     return cls(user=value.payload)
    #
    @staticmethod
    def resolve_user(parent, info: graphql.ResolveInfo):
        return parent.user


class Verify(graphene.Mutation, graphene.ObjectType):
    user = graphene.Field(CurrentUserType)

    class Arguments:
        token = graphene.String(required=True)

    @classmethod
    def mutate(cls, root, info, token, **kwargs):
        payload = graphql_jwt.utils.get_payload(token, info.context)
        return cls(user=User(id=payload.get('id'),
                             email=payload.get('email'),
                             public_name=payload.get('publicName')))

    @staticmethod
    def resolve_user(parent: 'Verify', info: graphql.ResolveInfo):
        return parent.user


class Mutation(TaskMutation, ApprovalMutation, graphene.ObjectType):
    token_auth = ObtainJSONWebToken.Field()

    # custom verify! This replaces graphql_jwt.Verify because its payload
    # is a generic scalar and has no type safety. The custom is beneficial for
    # type safety with Artemis on the frontend
    verify_token = Verify.Field()

    refresh_token = graphql_jwt.Refresh.Field()


schema: graphene.Schema = graphene.Schema(query=Query, mutation=Mutation)
