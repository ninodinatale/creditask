from graphene import Field, NonNull, InputObjectType, \
    String, Mutation as GrapheneMutation, Int, Date, List
from graphene_django.types import DjangoObjectType
from graphql import GraphQLError
from graphql_jwt.decorators import login_required

from creditask.models import Task
from creditask.schema.scalars import custom_string, custom_float
from creditask.services.task_service import save_task, get_task_by_id, \
    get_todo_tasks_by_user_email


#
# Object Types
#
class TaskType(DjangoObjectType):
    class Meta:
        model = Task


#
# Query
#
class TaskQuery:
    task = NonNull(TaskType, task_id=NonNull(Int))
    todo_tasks_of_user = List(NonNull(TaskType), user_email=NonNull(String))

    @staticmethod
    @login_required
    def resolve_task(self, info, **kwargs):
        return get_task_by_id(kwargs.get('task_id'))

    @staticmethod
    @login_required
    def resolve_todo_tasks_of_user(self, info, **kwargs):
        return get_todo_tasks_by_user_email(kwargs.get('user_email'))


#
# Input Types
#
task_input_type_name = custom_string(min_len=3, max_len=30)
task_input_type_factor = custom_float(min_value=1)
task_input_type_user_id = Int
task_input_type_period_start = Date
task_input_type_period_end = Date


class TaskInputCreate(InputObjectType):
    name = NonNull(task_input_type_name)
    factor = NonNull(task_input_type_factor)
    user_id = task_input_type_user_id()
    period_start = task_input_type_period_start()
    period_end = task_input_type_period_end()


class TaskInputUpdate(InputObjectType):
    name = task_input_type_name()
    factor = task_input_type_factor()
    user_id = task_input_type_user_id()
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
