import json
from typing import List

from django.test import tag

from creditask.api import schema
from creditask.api.tests.creditask_test_base import CreditaskTestBase
from creditask.models import TaskState, ApprovalState, CreditsCalc
from creditask.tests import create_user, create_group, create_task, \
    create_approval


@tag('integration')
class SaveApprovalTest(CreditaskTestBase):
    GRAPHQL_SCHEMA = schema

    def setUp(self):
        self.op_name = 'saveApproval'
        self.query_under_test = \
            f'''
                mutation {self.op_name}($approvalInput: ApprovalInput!) {{
                  {self.op_name}(approvalInput: $approvalInput) {{
                    approval {{
                      id
                      state
                      task {{
                        id
                      }}
                      user {{
                        id
                      }}
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

        self.login(self.current_user_credentials.get('email'),
                   self.current_user_credentials.get('password'))

    def test_should_require_login(self):
        self.should_require_login(self.query_under_test, op_name=self.op_name,
                                  variables={'approvalInput':
                                                 dict(
                                                     id='1',
                                                     state=ApprovalState.NONE)})

    def test_validation(self):
        with self.subTest('should require id'):
            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'approvalInput':
                                               dict(state=ApprovalState.NONE)})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertIn('In field "id": Expected "ID!", found null.',
                          errors[0].get('message'))

        with self.subTest('should require state'):
            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={'approvalInput':
                                               dict(id='1')})

            response_content: dict = json.loads(response.content)
            errors: List = response_content.get('errors')

            self.assertIsNotNone(errors)
            self.assertIn('In field "state": Expected "ApprovalState!", '
                          'found null.', errors[0].get('message'))

    def test_should_update_and_return_approval(self):
        with self.subTest('should update approval, but not task'):
            group = create_group()
            user_0 = create_user(group=group)
            user_1 = create_user(group=group)
            user_2 = create_user(group=group)
            user_3 = create_user(group=group)
            task = create_task(group=group,
                               state=TaskState.TO_APPROVE, user=user_1)
            approval_0 = create_approval(user=user_0,
                                         state=ApprovalState.NONE, task=task)
            approval_1 = create_approval(user=user_1, state=ApprovalState.NONE,
                                         task=task)
            approval_2 = create_approval(user=user_2, state=ApprovalState.NONE,
                                         task=task)
            approval_3 = create_approval(user=user_3, state=ApprovalState.NONE,
                                         task=task)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={
                                    'approvalInput': dict(id=approval_0.id,
                                                          state=str(
                                                              ApprovalState.APPROVED))})

            self.assertResponseNoErrors(response)

            approval: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('approval')

            self.assertIsNotNone(approval)
            self.assertEqual(approval.get('state'), str(
                ApprovalState.APPROVED))

            task.refresh_from_db()
            self.assertEqual(task.state, TaskState.TO_APPROVE)

        with self.subTest('should update approval and set task state to '
                          'DECLINED and not update the user\'s credits'):
            group = create_group()
            user_0 = create_user(group=group, credits=200)
            user_1 = create_user(group=group)
            user_2 = create_user(group=group)
            user_3 = create_user(group=group)
            task = create_task(group=group,
                               credits_calc=CreditsCalc.FIXED,
                               fixed_credits=500,
                               state=TaskState.TO_APPROVE, user=user_1)
            approval_0 = create_approval(user=user_0,
                                         state=ApprovalState.NONE, task=task)
            approval_1 = create_approval(user=user_1,
                                         state=ApprovalState.APPROVED,
                                         task=task)
            approval_2 = create_approval(user=user_2,
                                         state=ApprovalState.APPROVED,
                                         task=task)
            approval_3 = create_approval(user=user_3,
                                         state=ApprovalState.APPROVED,
                                         task=task)

            response = self.gql(self.query_under_test,
                                op_name=self.op_name,
                                variables={
                                    'approvalInput': dict(id=approval_0.id,
                                                          state=str(
                                                              ApprovalState.DECLINED),
                                                          message='Something wrong')})

            self.assertResponseNoErrors(response)

            approval: dict = json.loads(response.content).get(
                'data').get(self.op_name).get('approval')

            self.assertIsNotNone(approval)
            self.assertEqual(approval.get('state'), str(
                ApprovalState.DECLINED))

            task.refresh_from_db()
            self.assertEqual(task.state, TaskState.DECLINED)

            user_0.refresh_from_db()
            self.assertEqual(user_0.credits, 200)
