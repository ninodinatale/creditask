from graphene import NonNull, InputObjectType, \
    String, Mutation as GrapheneMutation, Int, Date, List, ID, ObjectType, \
    DateTime, Enum, Field
from graphene_django.types import DjangoObjectType
from graphql import GraphQLError
from graphql.execution.base import ResolveInfo
from graphql_jwt.decorators import login_required

from creditask.models import Task
from creditask.models.enums import ChangeableTaskProperty
from creditask.schema.approval import ApprovalType
from creditask.schema.scalars import custom_string, custom_float
from creditask.schema.user import UserType
from creditask.services.approval_service import get_approvals_by_task_group
from creditask.services.task_service import save_task, get_changes, \
    get_task_by_task_group_id, get_todo_tasks_by_user_email


#
# Object Types
#
class TaskChangeType(ObjectType):
    current_value = String()
    previous_value = String()
    user = NonNull(UserType)
    timestamp = NonNull(DateTime)
    changed_property = Field(Enum.from_enum(ChangeableTaskProperty))


class TaskType(DjangoObjectType):
    changes = NonNull(List(NonNull(TaskChangeType)))
    approvals = NonNull(List(NonNull(ApprovalType)))

    @staticmethod
    def resolve_changes(parent: Task, info: ResolveInfo):
        return get_changes(parent)

    @staticmethod
    def resolve_approvals(parent: Task, info: ResolveInfo):
        return get_approvals_by_task_group(parent.task_group)

    class Meta:
        model = Task


#
# Query
#
class TaskQuery:
    task = NonNull(TaskType, task_group_id=NonNull(ID))
    todo_tasks_of_user = List(NonNull(TaskType), user_email=NonNull(String))

    @staticmethod
    @login_required
    def resolve_task(self, info, **kwargs):
        return get_task_by_task_group_id(kwargs.get('task_group_id'))

    @staticmethod
    @login_required
    def resolve_todo_tasks_of_user(self, info, **kwargs):
        return get_todo_tasks_by_user_email(kwargs.get('user_email'))


#
# Input Types
#
task_input_type_task_group_id = ID
task_input_type_name = custom_string(min_len=3, max_len=30)
task_input_type_factor = custom_float(min_value=1)
task_input_type_user_id = ID
task_input_type_needed_time_seconds = Int
task_input_type_period_start = Date
task_input_type_period_end = Date


class TaskInputCreate(InputObjectType):
    name = NonNull(task_input_type_name)
    factor = NonNull(task_input_type_factor)
    user_id = task_input_type_user_id()
    period_start = task_input_type_period_start()
    period_end = task_input_type_period_end()


class TaskInputUpdate(InputObjectType):
    task_group_id = NonNull(task_input_type_task_group_id)  # TODO test
    name = task_input_type_name()
    factor = task_input_type_factor()
    user_id = task_input_type_user_id()
    needed_time_seconds = task_input_type_needed_time_seconds()
    period_start = task_input_type_period_start()
    period_end = task_input_type_period_end()


#
# Mutation Types
#
class SaveTask(GrapheneMutation):
    class Arguments:
        create_input = TaskInputCreate()
        update_input = TaskInputUpdate()

    task = NonNull(TaskType)

    @staticmethod
    @login_required
    def mutate(root, info, create_input=None, update_input=None):
        if create_input is None and update_input is None:
            raise GraphQLError('Either create_input or update_input need '
                               'to be set')

        if create_input is not None and update_input is not None:
            raise GraphQLError('Only one of create_input or update_input '
                               'may be set')

        input = create_input or update_input or dict()
        task = save_task(info.context.user, **input)
        return SaveTask(task=task)


#
# Mutations
#
class TaskMutation:
    save_task = SaveTask.Field()
