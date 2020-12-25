import datetime
import json
import random
from typing import List

from django.test import tag
from django.utils.timezone import utc

from creditask.api import schema
from creditask.api.tests.creditask_test_base import CreditaskTestBase
from creditask.models import TaskState, ApprovalState, CreditsCalc, \
    ChangeableTaskProperty
from creditask.tests import create_user, create_group, create_task, \
    create_approval, PreventStdErr


@tag('integration')
class ResolveTaskTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.query_under_test = \
            '''
            query task($id: ID!) {
                task(id: $id) {
                    id
                    name
                }
            }
            '''
        self.op_name = 'task'

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = create_user(group=create_group(),
                                        **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'id': '1'})

    def test_should_require_task_id(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'id': None})

        self.assertEquals(response.status_code, 400)

    def test_should_return_task(self):
        mock_task = create_task(created_by=self.current_user,
                                group=self.current_user.group)

        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'id': str(mock_task.id)})

        self.assertResponseNoErrors(response)

        task: dict = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertIsNotNone(task)
        self.assertEquals(int(task.get('id')), mock_task.id)
        self.assertEquals(task.get('name'), mock_task.name)


@tag('integration')
class ResolveTodoTasksOfUserTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.query_under_test = \
            '''
            query todoTasksOfUser($userEmail: String!) {
                todoTasksOfUser(userEmail: $userEmail) {
                    id
                    name
                }
            }
            '''
        self.op_name = 'todoTasksOfUser'

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = create_user(group=create_group(),
                                        **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'userEmail': 'user@mail.com'})

    def test_should_require_user_email(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': None})

        response_content: dict = json.loads(response.content)
        errors: List = response_content.get('errors')

        self.assertEquals(response.status_code, 400)
        self.assertIsNotNone(errors)
        self.assertEquals(errors[0].get('message'),
                          "Variable \"$userEmail\" "
                          "of required type \"String!\" was not provided.")

    def test_should_succeed(self):
        group = create_group()
        user_1 = create_user(group=group)
        user_2 = create_user(group=group)

        now = datetime.datetime.utcnow().replace(tzinfo=utc).replace(tzinfo=utc)

        # all good
        task_1 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_DO,
            period_end=now
        )

        # all good
        task_2 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_DO,
            period_end=now + datetime.timedelta(days=-1)
        )

        # wrong state
        task_3 = create_task(
            group=group,
            user=user_1,
            state=TaskState.DONE
        )

        # wrong user
        task_4 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_DO
        )

        # wrong state
        task_5 = create_task(
            group=group,
            user=user_1,
            state=TaskState.DONE
        )

        # all good
        task_6 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_DO,
            period_end=now + datetime.timedelta(days=1)
        )

        # wrong user
        task_7 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_DO
        )

        # all good
        task_8 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_DO,
            period_end=now + datetime.timedelta(days=-2)
        )

        # wrong user
        task_9 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_DO
        )

        # all good
        task_10 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_DO,
            period_end=now + datetime.timedelta(days=2)
        )

        # all good
        task_11 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_DO,
            period_end=now + datetime.timedelta(days=3)
        )

        # all good
        task_12 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_DO,
            period_end=now + datetime.timedelta(days=-5)
        )

        # all good
        task_13 = create_task(
            group=group,
            user=user_1,
            state=TaskState.APPROVED,
            period_end=now + datetime.timedelta(days=4)
        )

        # all good
        task_14 = create_task(
            group=group,
            user=user_1,
            state=TaskState.DECLINED,
            period_end=now + datetime.timedelta(days=5)
        )

        # all good
        task_15 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE,
            period_end=now + datetime.timedelta(days=6)
        )

        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': user_1.email})

        self.assertResponseNoErrors(response)

        tasks: List[dict] = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertEquals(10, len(tasks))

        # checking sort order
        self.assertEquals(task_12.id, int(tasks[0].get('id')))
        self.assertEquals(task_8.id, int(tasks[1].get('id')))
        self.assertEquals(task_2.id, int(tasks[2].get('id')))
        self.assertEquals(task_1.id, int(tasks[3].get('id')))
        self.assertEquals(task_6.id, int(tasks[4].get('id')))
        self.assertEquals(task_10.id, int(tasks[5].get('id')))
        self.assertEquals(task_11.id, int(tasks[6].get('id')))

        self.assertEquals(task_12.name, tasks[0].get('name'))
        self.assertEquals(task_8.name, tasks[1].get('name'))
        self.assertEquals(task_2.name, tasks[2].get('name'))
        self.assertEquals(task_1.name, tasks[3].get('name'))
        self.assertEquals(task_6.name, tasks[4].get('name'))
        self.assertEquals(task_10.name, tasks[5].get('name'))
        self.assertEquals(task_11.name, tasks[6].get('name'))


@tag('integration')
class ResolveToApproveTasksOfUserTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.query_under_test = \
            '''
                query toApproveTasksOfUser($userEmail: String!) {
                    toApproveTasksOfUser(userEmail: $userEmail) {
                        id
                        name
                    }
                }
            '''
        self.op_name = 'toApproveTasksOfUser'

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = create_user(group=create_group(),
                                        **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'userEmail': 'user@mail.com'})

    def test_should_require_user_email(self):
        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': None})

        response_content: dict = json.loads(response.content)
        errors: List = response_content.get('errors')

        self.assertEquals(response.status_code, 400)
        self.assertIsNotNone(errors)
        self.assertEquals(errors[0].get('message'),
                          "Variable \"$userEmail\" "
                          "of required type \"String!\" was not provided.")

    def test_should_return_expected_resuls(self):
        group = create_group()
        user_1 = create_user(group=group)
        user_2 = create_user(group=group)
        user_3 = create_user(group=group)

        # wrong task state
        task_3 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_DO
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_3,
            user=user_1
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_3,
            user=user_2
        )
        create_approval(
            state=ApprovalState.DECLINED,
            task=task_3,
            user=user_3
        )

        # all good
        task_6 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_APPROVE
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_6,
            user=user_1
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_6,
            user=user_2
        )
        create_approval(
            state=ApprovalState.APPROVED,
            task=task_6,
            user=user_3
        )

        # wrong user in task
        task_9 = create_task(
            group=group,
            user=user_1,
            state=TaskState.TO_APPROVE
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_9,
            user=user_1
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_9,
            user=user_2
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_9,
            user=user_3
        )

        # all good
        task_12 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_APPROVE
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_12,
            user=user_1
        )
        create_approval(
            state=ApprovalState.APPROVED,
            task=task_12,
            user=user_2
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_12,
            user=user_3
        )

        # already approved
        task_13 = create_task(
            group=group,
            user=user_2,
            state=TaskState.TO_APPROVE
        )
        create_approval(
            state=ApprovalState.APPROVED,
            task=task_12,
            user=user_1
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_12,
            user=user_2
        )
        create_approval(
            state=ApprovalState.NONE,
            task=task_12,
            user=user_3
        )

        response = self.gql(self.query_under_test,
                            op_name=self.op_name,
                            variables={'userEmail': user_1.email})

        self.assertResponseNoErrors(response)

        tasks: List[dict] = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertEquals(2, len(tasks))

        # checking sort order
        self.assertEquals(task_6.id, int(tasks[0].get('id')))
        self.assertEquals(task_12.id, int(tasks[1].get('id')))


@tag('integration')
class ResolveUnassignedTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.query_under_test = \
            '''
                query unassignedTasks {
                  unassignedTasks {
                    id
                    name
                  }
                }
            '''
        self.op_name = 'unassignedTasks'

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = create_user(group=create_group(),
                                        **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'userEmail': 'user@mail.com'})

    def test_should_return_expected_results(self):
        group_1 = create_group()
        group_2 = create_group()
        group_3 = create_group()
        user_2 = create_user(group=self.current_user.group)
        user_3 = create_user(group=self.current_user.group)

        now = datetime.datetime.utcnow().replace(tzinfo=utc)

        # wrong user
        task_1 = create_task(
            group=group_1,
            user=user_2,
            period_end=now
        )

        # ok
        task_2 = create_task(
            group=self.current_user.group,
            user=None,
            period_end=now
        )

        # wrong group
        task_3 = create_task(
            group=group_2,
            user=None,
            period_end=now
        )

        # ok
        task_4 = create_task(
            group=self.current_user.group,
            user=None,
            period_end=now + datetime.timedelta(days=-1)
        )

        # wrong user and wrong group
        task_5 = create_task(
            group=group_2,
            user=user_3,
            period_end=now
        )

        # ok
        task_6 = create_task(
            group=self.current_user.group,
            user=None,
            period_end=now + datetime.timedelta(days=-2)
        )

        # ok
        task_7 = create_task(
            group=self.current_user.group,
            user=None,
            period_end=now + datetime.timedelta(days=2)
        )

        # ok
        task_8 = create_task(
            group=self.current_user.group,
            user=None,
            period_end=now + datetime.timedelta(days=1)
        )

        # wrong group
        task_9 = create_task(
            group=group_3,
            user=None,
            period_end=now + datetime.timedelta(days=1)
        )

        response = self.gql(self.query_under_test,
                            op_name=self.op_name)

        self.assertResponseNoErrors(response)

        tasks: List[dict] = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertEquals(5, len(tasks))

        # checking sort order
        self.assertEquals(task_6.id, int(tasks[0].get('id')))
        self.assertEquals(task_4.id, int(tasks[1].get('id')))
        self.assertEquals(task_2.id, int(tasks[2].get('id')))
        self.assertEquals(task_8.id, int(tasks[3].get('id')))
        self.assertEquals(task_7.id, int(tasks[4].get('id')))


@tag('integration')
class ResolveAllTasksTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.query_under_test = \
            '''
                query allTodoTasks {
                  allTodoTasks {
                    id
                    name
                  }
                }
            '''
        self.op_name = 'allTodoTasks'

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = create_user(group=create_group(),
                                        **self.current_user_credentials)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'userEmail': 'user@mail.com'})

    def test_should_return_expected_results(self):
        group_1 = create_group()
        group_2 = create_group()
        group_3 = create_group()
        user_2 = create_user(group=self.current_user.group)
        user_3 = create_user(group=self.current_user.group)

        now = datetime.datetime.utcnow().replace(tzinfo=utc)

        # ok
        task_1 = create_task(
            group=self.current_user.group,
            user=user_2,
            period_end=now + datetime.timedelta(days=3)
        )

        # ok
        task_2 = create_task(
            group=self.current_user.group,
            user=None,
            period_end=now
        )

        # wrong group
        create_task(
            group=group_2,
            user=None,
            period_end=now
        )

        # ok
        task_4 = create_task(
            group=self.current_user.group,
            user=None,
            period_end=now + datetime.timedelta(days=-1)
        )

        # wrong state
        create_task(
            group=self.current_user.group,
            user=None,
            state=TaskState.TO_APPROVE,
            period_end=now + datetime.timedelta(days=-1)
        )

        # wrong group
        create_task(
            group=group_2,
            user=user_3,
            period_end=now
        )

        # ok
        task_6 = create_task(
            group=self.current_user.group,
            user=user_2,
            period_end=now + datetime.timedelta(days=-2)
        )

        # ok
        task_7 = create_task(
            group=self.current_user.group,
            user=self.current_user,
            period_end=now + datetime.timedelta(days=2)
        )

        # wrong state
        create_task(
            group=self.current_user.group,
            state=TaskState.APPROVED,
            user=self.current_user,
            period_end=now + datetime.timedelta(days=2)
        )

        # ok
        task_8 = create_task(
            group=self.current_user.group,
            user=user_3,
            period_end=now + datetime.timedelta(days=1)
        )

        # wrong state
        create_task(
            group=self.current_user.group,
            state=TaskState.DECLINED,
            user=user_3,
            period_end=now + datetime.timedelta(days=1)
        )

        # wrong group
        create_task(
            group=group_3,
            user=None,
            period_end=now + datetime.timedelta(days=1)
        )

        response = self.gql(self.query_under_test,
                            op_name=self.op_name)

        self.assertResponseNoErrors(response)

        tasks: List[dict] = json.loads(response.content).get(
            'data').get(self.op_name)

        self.assertEquals(6, len(tasks))

        # checking sort order
        self.assertEquals(task_6.id, int(tasks[0].get('id')))
        self.assertEquals(task_4.id, int(tasks[1].get('id')))
        self.assertEquals(task_2.id, int(tasks[2].get('id')))
        self.assertEquals(task_8.id, int(tasks[3].get('id')))
        self.assertEquals(task_7.id, int(tasks[4].get('id')))
        self.assertEquals(task_1.id, int(tasks[5].get('id')))


@tag('integration')
class SaveTaskTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def get_valid_create_input(self, name='some name',
                               credits_calc=CreditsCalc.FIXED,
                               fixed_credits=100):
        return dict(
            name=name,
            creditsCalc=credits_calc,
            fixedCredits=fixed_credits
        )

    def get_valid_update_input(self, id=None):
        id = id if id is not None else self.existing_task.id
        return dict(
            id=id,
        )

    def setUp(self):
        self.op_name = 'saveTask'
        self.query_under_test = \
            f'''
            mutation {self.op_name}($createInput: TaskInputCreate) {{
              {self.op_name}(createInput: $createInput) {{
                task {{
                  id
                  name
                }}
              }}
            }}
            '''

        self.current_user_credentials = {
            'email': 'current_user@email.com',
            'password': 'pwuser1'
        }
        self.current_user = self.current_user = create_user(
            group=create_group(),
            **self.current_user_credentials)

        self.user_1 = create_user(
            group=self.current_user.group)
        self.user_2 = create_user(
            group=self.current_user.group)
        self.user_3 = create_user(
            group=self.current_user.group)

        self.existing_task = create_task(group=self.current_user.group)

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name),

    def test_validation(self):
        with self.subTest('should require only createInput or updateInput, '
                          'but not both'):
            self.query_under_test = \
                f'''
            mutation {self.op_name}($createInput: TaskInputCreate,
                                        $updateInput: TaskInputUpdate) {{
              {self.op_name}(createInput: $createInput, updateInput:
                                                            $updateInput) {{
                task {{
                  id
                  name
                }}
              }}
            }}
            '''
            with PreventStdErr():
                response = self.gql(self.query_under_test,
                                    op_name=self.op_name,
                                    variables=dict(createInput={
                                        **self.get_valid_create_input()},
                                        updateInput={
                                            **self.get_valid_update_input()}))

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              'Only one of create_input or update_input may be '
                              'set')

        with self.subTest('should require either createInput or updateInput'):
            self.query_under_test = \
                f'''
            mutation {self.op_name} {{
              {self.op_name} {{
                task {{
                  id
                  name
                }}
              }}
            }}
            '''
            with PreventStdErr():
                response = self.gql(self.query_under_test,
                                    op_name=self.op_name, )

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              'Either create_input or update_input need '
                              'to be set')

        with self.subTest(
                'on create, should require fixed_credits if credits_calc is FIXED'):
            self.query_under_test = \
                f'''
            mutation {self.op_name}($createInput: TaskInputCreate) {{
              {self.op_name}(createInput: $createInput) {{
                task {{
                  id
                  name
                }}
              }}
            }}
            '''
            with PreventStdErr():
                response = self.gql(self.query_under_test,
                                    op_name=self.op_name,
                                    variables=dict(createInput=dict(
                                        **self.get_valid_create_input(
                                            credits_calc=CreditsCalc.FIXED,
                                            fixed_credits=None),
                                        factor=1)))

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              'If CreditsCalc is FIXED, fixed_credits needs to '
                              'be set, but is None')

        with self.subTest(
                'on create, should require factor if credits_calc is BY_FACTOR'):
            self.query_under_test = \
                f'''
            mutation {self.op_name}($createInput: TaskInputCreate) {{
              {self.op_name}(createInput: $createInput) {{
                task {{
                  id
                  name
                }}
              }}
            }}
            '''
            with PreventStdErr():
                response = self.gql(self.query_under_test,
                                    op_name=self.op_name,
                                    variables={'createInput':
                                        dict(
                                            **self.get_valid_create_input(
                                                credits_calc=CreditsCalc.BY_FACTOR,
                                                fixed_credits=100))})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              'If CreditsCalc is BY_FACTOR, factor needs to be '
                              'set, but is None')

    def test_create_input(self):
        self.query_under_test = \
            f'''
            mutation {self.op_name}($createInput: TaskInputCreate) {{
              {self.op_name}(createInput: $createInput) {{
                task {{
                  id
                  name
                  state
                  user {{
                        id
                        }}
                  approvals {{
                        user {{
                        id
                        publicName
                        }}
                        state
                        }}
                  neededTimeSeconds
                  creditsCalc
                  factor
                  fixedCredits
                  taskChanges {{
                        changedProperty
                        previousValue
                        currentValue
                        }}
                }}
              }}
            }}
            '''

        with self.subTest('test_name_should_have_min_len_of_3'):
            create_input = dict(**self.get_valid_create_input(name='na'),
                                factor=1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              "['length of \"na\" (2) is shorter than min "
                              "length (3)']")

        with self.subTest('test_name_should_have_max_len_of_30'):
            create_input = dict(**self.get_valid_create_input(
                name='Very long task name, way too long'),
                                factor=1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              "['length of \"Very long task name, way too "
                              "long\" (33) may not be greater than 30)']")

        with self.subTest('test_name_should_be_non_null'):
            create_input = dict(name=None, factor=1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected \"CustomString!\", found null.",
                          errors[0].get('message'))

        with self.subTest('credits_calc should be non null'):
            create_input = dict(
                **self.get_valid_create_input(credits_calc=None))

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn('Variable "$createInput" got invalid value '
                          '{"creditsCalc": null, "fixedCredits": 100, "name": '
                          '"some name"}.\nIn field "creditsCalc": Expected '
                          '"CreditsCalc!", found null.',
                          errors[0].get('message'))

        with self.subTest('credits_calc should be valid Enum value'):
            create_input = dict(
                **self.get_valid_create_input(credits_calc='INVALID_VALUE'))

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn('Variable "$createInput" got invalid value '
                          '{"creditsCalc": "INVALID_VALUE", "fixedCredits": '
                          '100, "name": "some name"}.\nIn field "creditsCalc": '
                          'Expected type "CreditsCalc", found "INVALID_VALUE".',
                          errors[0].get('message'))

        with self.subTest('test_factor_should_be_float'):
            create_input = dict(
                **self.get_valid_create_input(name='Task Name'), factor='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn('Expected type "CustomFloatFactor", found "abc".',
                          errors[0].get('message'))

        with self.subTest('test_factor_should_have_min_value_of_0'):
            create_input = dict(
                **self.get_valid_create_input(name='Task Name'), factor=-1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEqual("['value -1.0 needs to be greater than 1.']",
                             errors[0].get('message'))

        with self.subTest('test_fixed_credits_should_have_min_value_of_0'):
            create_input = dict(**self.get_valid_create_input(fixed_credits=-1))

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEqual("['value -1.0 needs to be greater than 0.']",
                             errors[0].get('message'))

        with self.subTest('test_user_id_can_be_string'):
            create_input = dict(**self.get_valid_create_input(), factor=1,
                                userId=str(self.current_user.id))

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            self.assertResponseNoErrors(response)

        with self.subTest('test_period_start_should_be_date'):
            create_input = dict(**self.get_valid_create_input(), factor=1,
                                periodStart='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"Date\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_period_end_should_be_date'):
            create_input = dict(**self.get_valid_create_input(), factor=1,
                                periodEnd='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"Date\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('should create task'):
            task_name = str(random.randint(1, 99999999))
            create_input = dict(**self.get_valid_create_input(name=task_name))

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'createInput': create_input})

            self.assertResponseNoErrors(response)

            task: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('task')

            self.assertIsNotNone(task)
            self.assertEqual(task.get('name'), create_input.get('name'))
            self.assertEqual(task.get('state'), TaskState.TO_DO)
            self.assertEqual(task.get('user'), None)
            self.assertCountEqual(task.get('approvals'), [
                dict(user=dict(id=str(self.current_user.id),
                               publicName=self.current_user.public_name),
                     state=ApprovalState.NONE),
                dict(user=dict(id=str(self.user_1.id),
                               publicName=self.user_1.public_name),
                     state=ApprovalState.NONE),
                dict(user=dict(id=str(self.user_2.id),
                               publicName=self.user_2.public_name),
                     state=ApprovalState.NONE),
                dict(user=dict(id=str(self.user_3.id),
                               publicName=self.user_3.public_name),
                     state=ApprovalState.NONE)
            ])
            self.assertEqual(task.get('neededTimeSeconds'), 0)
            self.assertEqual(task.get('creditsCalc'),
                             create_input.get('creditsCalc'))
            self.assertEqual(task.get('factor'), 1)
            self.assertEqual(task.get('fixedCredits'),
                             create_input.get('fixedCredits'))
            self.assertCountEqual(task.get('taskChanges'), [
                dict(changedProperty=ChangeableTaskProperty.CreatedById,
                     previousValue=None,
                     currentValue=str(self.current_user.id)),
            ])

    def test_update_input(self):
        self.query_under_test = \
            f'''
                mutation {self.op_name}Task($updateInput: TaskInputUpdate) {{
                  {self.op_name}(updateInput: $updateInput) {{
                    task {{
                      id
                      name
                      state
                      user {{
                            id
                            }}
                      approvals {{
                            user {{
                            id
                            publicName
                            }}
                            state
                            }}
                      neededTimeSeconds
                      creditsCalc
                      factor
                      fixedCredits
                      taskChanges {{
                            changedProperty
                            previousValue
                            currentValue
                            }}
                    }}
                  }}
                }}
                '''

        with self.subTest('test_name_should_have_min_len_of_3'):
            update_input = dict(**self.get_valid_update_input(), name='na')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              "['length of \"na\" (2) is shorter than min "
                              "length (3)']")

        with self.subTest('test_name_should_have_max_len_of_30'):
            update_input = dict(**self.get_valid_update_input(),
                                name='Very long task name, way too long')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEquals(errors[0].get('message'),
                              "['length of \"Very long task name, way too "
                              "long\" (33) may not be greater than 30)']")

        with self.subTest('test_name_should_be_nullable'):
            update_input = dict(self.get_valid_update_input(), name=None)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

        with self.subTest('test_factor_should_be_float'):
            update_input = dict(**self.get_valid_update_input(), factor='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"CustomFloatFactor\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_factor_should_have_min_value_of_0'):
            update_input = dict(**self.get_valid_update_input(), factor=-1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEqual("['value -1.0 needs to be greater than 1.']",
                             errors[0].get('message'))

        with self.subTest('test_factor_should_be_nullable'):
            update_input = dict(**self.get_valid_update_input(), factor=None)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

        with self.subTest('credits_calc should be valid Enum value'):
            update_input = dict(
                **self.get_valid_update_input(), credits_calc='INVALID_VALUE')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn('field "credits_calc": Unknown field.',
                          errors[0].get('message'))

        with self.subTest('test_fixed_credits_should_have_min_value_of_0'):
            update_input = dict(**self.get_valid_update_input(),
                                fixedCredits=-1)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertEqual("['value -1.0 needs to be greater than 0.']",
                             errors[0].get('message'))

        with self.subTest('test_user_id_can_be_string'):
            update_input = dict(**self.get_valid_update_input(),
                                userId=str(self.current_user.id))

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertResponseNoErrors(response)

        with self.subTest('test_period_start_should_be_date'):
            update_input = dict(name='Task Name', factor=1, periodStart='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"Date\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('test_period_end_should_be_date'):
            update_input = dict(name='Task Name', factor=1, periodEnd='abc')

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertEquals(response.status_code, 400)
            self.assertIsNotNone(errors)
            self.assertIn("Expected type \"Date\", found \"abc\".",
                          errors[0].get('message'))

        with self.subTest('should update task (one property)'):
            task_to_update = create_task(group=self.current_user.group,
                                         name='this name should be updated')
            approval_1 = create_approval(task=task_to_update,
                                         user=self.current_user)
            approval_2 = create_approval(task=task_to_update, user=self.user_1)
            approval_3 = create_approval(task=task_to_update, user=self.user_2)
            approval_4 = create_approval(task=task_to_update, user=self.user_3)

            new_name = 'this is the new name'
            update_input = dict(
                **self.get_valid_update_input(id=task_to_update.id),
                name=new_name)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

            task: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('task')

            self.assertIsNotNone(task)
            self.assertEqual(task.get('name'), new_name)
            self.assertEqual(task.get('state'), TaskState.TO_DO)
            self.assertEqual(task.get('user'), None)
            self.assertCountEqual(list(map(
                lambda a: dict(state=a.get('state'),
                               user_id=a.get('user').get('id'),
                               public_name=a.get('user').get('publicName')),
                task.get('approvals'))), [
                dict(state=str(approval_1.state),
                     user_id=str(approval_1.user.id),
                     public_name=approval_1.user.public_name),
                dict(state=str(approval_2.state),
                     user_id=str(approval_2.user.id),
                     public_name=approval_2.user.public_name),
                dict(state=str(approval_3.state),
                     user_id=str(approval_3.user.id),
                     public_name=approval_3.user.public_name),
                dict(state=str(approval_4.state),
                     user_id=str(approval_4.user.id),
                     public_name=approval_4.user.public_name),
            ])
            self.assertEqual(task.get('creditsCalc'),
                             str(CreditsCalc.BY_FACTOR))
            self.assertEqual(task.get('factor'), 1)
            self.assertEqual(task.get('fixedCredits'), 0)
            self.assertCountEqual(task.get('taskChanges'), [
                dict(changedProperty=str(ChangeableTaskProperty.Name),
                     previousValue='this name should be updated',
                     currentValue=new_name),
            ])

        with self.subTest('should update task (multiple properties)'):
            task_to_update = create_task(group=self.current_user.group,
                                         name='this name should be updated')
            approval_1 = create_approval(task=task_to_update,
                                         user=self.current_user)
            approval_2 = create_approval(task=task_to_update, user=self.user_1)
            approval_3 = create_approval(task=task_to_update, user=self.user_2)
            approval_4 = create_approval(task=task_to_update, user=self.user_3)

            new_name = 'this is the new name'
            new_user_id = str(self.user_1.id)
            new_needed_time_seconds = 200
            new_factor = 2.0
            new_state = str(TaskState.TO_APPROVE)
            update_input = dict(
                **self.get_valid_update_input(id=task_to_update.id),
                name=new_name,
                userId=new_user_id,
                neededTimeSeconds=new_needed_time_seconds, factor=new_factor,
                state=new_state)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

            task: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('task')

            self.assertIsNotNone(task)
            self.assertEqual(task.get('name'), new_name)
            self.assertEqual(task.get('state'), new_state)
            self.assertEqual(task.get('user').get('id'), new_user_id)
            self.assertEqual(task.get('factor'), new_factor)
            self.assertCountEqual(list(map(
                lambda a: dict(state=a.get('state'),
                               user_id=a.get('user').get('id'),
                               public_name=a.get('user').get('publicName')),
                task.get('approvals'))), [
                dict(state=str(approval_1.state),
                     user_id=str(approval_1.user.id),
                     public_name=approval_1.user.public_name),
                dict(state=str(approval_3.state),
                     user_id=str(approval_3.user.id),
                     public_name=approval_3.user.public_name),
                dict(state=str(approval_4.state),
                     user_id=str(approval_4.user.id),
                     public_name=approval_4.user.public_name), ]
            )
            self.assertCountEqual(task.get('taskChanges'), [
                dict(changedProperty=str(ChangeableTaskProperty.Name),
                     previousValue='this name should be updated',
                     currentValue=new_name),
                dict(changedProperty=str(ChangeableTaskProperty.UserId),
                     previousValue=None,
                     currentValue=str(new_user_id)),
                dict(changedProperty=str(
                    ChangeableTaskProperty.NeededTimeSeconds),
                    previousValue='0',
                    currentValue=str(new_needed_time_seconds)),
                dict(changedProperty=str(ChangeableTaskProperty.Factor),
                     previousValue='1.0',
                     currentValue=str(new_factor)),
                dict(changedProperty=str(ChangeableTaskProperty.State),
                     previousValue=str(TaskState.TO_DO),
                     currentValue=str(new_state)),
            ])

        with self.subTest(
                'should update task state to DONE and update user\'s credits by '
                'fixed_credits'):
            user_1 = create_user(group=self.current_user.group, credits=200)
            task_to_update = create_task(group=self.current_user.group,
                                         credits_calc=CreditsCalc.FIXED,
                                         fixed_credits=500,
                                         state=TaskState.APPROVED,
                                         user=user_1)

            update_input = dict(
                **self.get_valid_update_input(id=task_to_update.id),
                state=TaskState.DONE)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

            task: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('task')

            self.assertIsNotNone(task)
            self.assertEqual(task.get('state'), TaskState.DONE)
            task_to_update.refresh_from_db()
            self.assertEqual(task_to_update.state, TaskState.DONE)

            user_1.refresh_from_db()
            self.assertEqual(user_1.credits, 700)

        with self.subTest(
                'should update task state to DONE and update user\'s credits by '
                'factor'):
            user_1 = create_user(group=self.current_user.group, credits=200)
            task_to_update = create_task(group=self.current_user.group,
                                         credits_calc=CreditsCalc.BY_FACTOR,
                                         factor=2.5,
                                         needed_time_seconds=2000,
                                         state=TaskState.APPROVED, user=user_1)

            update_input = dict(
                **self.get_valid_update_input(id=task_to_update.id),
                state=TaskState.DONE)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'updateInput': update_input})

            self.assertResponseNoErrors(response)

            task: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('task')

            self.assertIsNotNone(task)
            self.assertEqual(task.get('state'), TaskState.DONE)
            task_to_update.refresh_from_db()
            self.assertEqual(task_to_update.state, TaskState.DONE)

            user_1.refresh_from_db()
            self.assertEqual(user_1.credits, 284)

