# import json
# from typing import List
#
# from graphene_django.utils import GraphQLTestCase
#
#
# class CreditaskTestBase(GraphQLTestCase):
#     def login(self, user_email: str = None, password: str = None):
#         if user_email is None or password is None:
#             self.fail('Credentials for login are missing')
#
#         # used in `self.should_require_login()` to log back in after logging
#         # out.
#         self.last_login_credentials = {
#             'user_email': user_email,
#             'password': password
#         }
#         response = self.query(
#             '''
#             mutation TokenAuth($email: String!, $password: String!) {
#               tokenAuth(email: $email, password: $password) {
#                 token
#               }
#             }
#             ''',
#             op_name='TokenAuth',
#             variables={'email': user_email,
#                        'password': password})
#
#         self.auth_token = json.loads(response.content).get('data').get(
#             'tokenAuth').get('token')
#
#         # TODO why do i have to set defaults to this instead of headers {
#         #  'Authorization': auth_token } ???
#         self.client.defaults['HTTP_AUTHORIZATION'] = 'JWT ' + self.auth_token
#
#     def logout(self):
#         self.client.defaults['HTTP_AUTHORIZATION'] = ''
#
#     # TODO somehow GraphQLTestCase's self.query() does not apply the
#     #  authorization header (neither as self.client.defaults[
#     #  'HTTP_AUTHORIZATION'] like above, nor as headers={'Authorization': xxx).
#     #  Last does apply, but the self.client.post() puts it in its `META`
#     #  property instead of the `headers` property, which may be the reason it
#     #  won't apply? Question to be asked or issue to be raised.
#     def gql(self, query, op_name=None, input_data=None, variables=None):
#         """
#         Args:
#             query (string)    - GraphQL query to run
#             op_name (string)  - If the query is a mutation or named query, you
#                                 must supply the op_name.  For annon queries
#                                 ("{ ... }"), should be None (default).
#             input_data (dict) - If provided, the $input variable in GraphQL will
#                                 be set to this value. If both ``input_data``
#                                 and ``variables``, are provided, field in the
#                                 ``variables`` dict will be overwritten with
#                                 this value.
#             variables (dict)  - If provided, the "variables" field in GraphQL
#                                 will be set to this value.
#
#         Returns:
#             Response object from client
#         """
#         body = {"query": query}
#         if op_name:
#             body["operation_name"] = op_name
#         if variables:
#             body["variables"] = variables
#         if input_data:
#             if variables in body:
#                 body["variables"]["input"] = input_data
#             else:
#                 body["variables"] = {"input": input_data}
#         resp = self.client.post(
#             self.GRAPHQL_URL, json.dumps(body), content_type="application/json"
#         )
#         return resp
#
#     def should_require_login(self, query, op_name=None, variables=None):
#         r"""Asserts that resolver is protected by login
#
#         :param query:
#             The graphql query to test authentication upon
#         :type query: ``str``
#         :param op_name:
#             The operation name
#         :type op_name: ``str``
#         :param variables:
#             The operation name
#         :type variables: ``dict``
#         """
#         self.logout()
#
#         response = self.gql(query, op_name=op_name, variables=variables)
#
#         response_content: dict = json.loads(response.content)
#         errors: List = response_content.get('errors')
#
#         self.assertIsNotNone(errors)
#         self.assertEqual(errors[0].get('message'), 'You do not have permission '
#                                                    'to perform this action')
#
#         self.login(self.last_login_credentials.get('user_email'),
#                    self.last_login_credentials.get('password'))
