import gql from 'graphql-tag';
import * as ApolloReactCommon from '@apollo/react-common';
import * as ApolloReactHooks from '@apollo/react-hooks';
export type Maybe<T> = T | null;
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
  CustomFloat: number;
  CustomString: string;
  Date: string;
  DateTime: string;
  GenericScalar: any;
};

export type ApprovalInput = {
  state: ApprovalState;
  taskGroupId: Scalars['ID'];
  userId: Scalars['ID'];
};

export enum ApprovalState {
  None = 'NONE',
  Approved = 'APPROVED',
  Declined = 'DECLINED'
}

export type ApprovalType = {
   __typename?: 'ApprovalType';
  id: Scalars['ID'];
  createdAt: Scalars['DateTime'];
  createdBy: UserType;
  isDeleted: Scalars['Boolean'];
  state: ApprovalState;
  task: TaskType;
  user: UserType;
};

export enum ChangeableTaskProperty {
  Name = 'Name',
  NeededTimeSeconds = 'NeededTimeSeconds',
  State = 'State',
  Factor = 'Factor',
  UserId = 'UserId',
  PeriodStart = 'PeriodStart',
  PeriodEnd = 'PeriodEnd',
  Approval = 'Approval'
}

export type CurrentUserType = {
   __typename?: 'CurrentUserType';
  id: Scalars['ID'];
  email: Scalars['String'];
  publicName: Scalars['String'];
};






export type Mutation = {
   __typename?: 'Mutation';
  saveApproval?: Maybe<SaveApproval>;
  saveTask?: Maybe<SaveTask>;
  tokenAuth?: Maybe<ObtainJsonWebToken>;
  verifyToken?: Maybe<Verify>;
  refreshToken?: Maybe<Refresh>;
};


export type MutationSaveApprovalArgs = {
  input: ApprovalInput;
};


export type MutationSaveTaskArgs = {
  createInput?: Maybe<TaskInputCreate>;
  updateInput?: Maybe<TaskInputUpdate>;
};


export type MutationTokenAuthArgs = {
  email: Scalars['String'];
  password: Scalars['String'];
};


export type MutationVerifyTokenArgs = {
  token: Scalars['String'];
};


export type MutationRefreshTokenArgs = {
  token: Scalars['String'];
};

export type ObtainJsonWebToken = {
   __typename?: 'ObtainJSONWebToken';
  token?: Maybe<Scalars['String']>;
  user?: Maybe<UserType>;
};

export type Query = {
   __typename?: 'Query';
  task: TaskType;
  todoTasksOfUser: Array<TaskType>;
  toApproveTasksOfUser: Array<TaskType>;
  taskGroup?: Maybe<TaskGroupType>;
  user?: Maybe<UserType>;
  users?: Maybe<Array<UserType>>;
  otherUsers?: Maybe<Array<UserType>>;
};


export type QueryTaskArgs = {
  taskGroupId: Scalars['ID'];
};


export type QueryTodoTasksOfUserArgs = {
  userEmail: Scalars['String'];
};


export type QueryToApproveTasksOfUserArgs = {
  userEmail: Scalars['String'];
};


export type QueryTaskGroupArgs = {
  id: Scalars['ID'];
};


export type QueryUserArgs = {
  id: Scalars['Int'];
};


export type QueryOtherUsersArgs = {
  userEmail: Scalars['String'];
};

export type Refresh = {
   __typename?: 'Refresh';
  token?: Maybe<Scalars['String']>;
  payload?: Maybe<Scalars['GenericScalar']>;
};

export type SaveApproval = {
   __typename?: 'SaveApproval';
  approval: ApprovalType;
};

export type SaveTask = {
   __typename?: 'SaveTask';
  task: TaskType;
};

export type TaskChangeType = {
   __typename?: 'TaskChangeType';
  currentValue?: Maybe<Scalars['String']>;
  previousValue?: Maybe<Scalars['String']>;
  user: UserType;
  timestamp: Scalars['DateTime'];
  changedProperty?: Maybe<ChangeableTaskProperty>;
};

export type TaskGroupType = {
   __typename?: 'TaskGroupType';
  id: Scalars['ID'];
  taskSet: Array<TaskType>;
};

export type TaskInputCreate = {
  name: Scalars['CustomString'];
  factor: Scalars['CustomFloat'];
  userId?: Maybe<Scalars['ID']>;
  periodStart?: Maybe<Scalars['Date']>;
  periodEnd?: Maybe<Scalars['Date']>;
};

export type TaskInputUpdate = {
  taskGroupId: Scalars['ID'];
  state?: Maybe<TaskState>;
  name?: Maybe<Scalars['CustomString']>;
  factor?: Maybe<Scalars['CustomFloat']>;
  userId?: Maybe<Scalars['ID']>;
  neededTimeSeconds?: Maybe<Scalars['Int']>;
  periodStart?: Maybe<Scalars['Date']>;
  periodEnd?: Maybe<Scalars['Date']>;
};

export enum TaskState {
  ToDo = 'TO_DO',
  ToApprove = 'TO_APPROVE',
  Declined = 'DECLINED',
  Approved = 'APPROVED'
}

export type TaskType = {
   __typename?: 'TaskType';
  createdAt: Scalars['DateTime'];
  createdBy: UserType;
  isDeleted: Scalars['Boolean'];
  id: Scalars['ID'];
  taskGroup: TaskGroupType;
  name: Scalars['String'];
  neededTimeSeconds: Scalars['Int'];
  state: TaskState;
  factor: Scalars['Float'];
  user?: Maybe<UserType>;
  periodStart: Scalars['Date'];
  periodEnd: Scalars['Date'];
  approvals: Array<ApprovalType>;
  changes: Array<TaskChangeType>;
};

export type UserType = {
   __typename?: 'UserType';
  id: Scalars['ID'];
  password: Scalars['String'];
  lastLogin?: Maybe<Scalars['DateTime']>;
  email: Scalars['String'];
  publicName: Scalars['String'];
  credits: Scalars['Int'];
  isStaff: Scalars['Boolean'];
  isSuperuser: Scalars['Boolean'];
  isActive: Scalars['Boolean'];
  taskSet: Array<TaskType>;
  approvalSet: Array<ApprovalType>;
};

export type Verify = {
   __typename?: 'Verify';
  user?: Maybe<CurrentUserType>;
};

export type TokenAuthMutationVariables = {
  email: Scalars['String'];
  password: Scalars['String'];
};


export type TokenAuthMutation = (
  { __typename?: 'Mutation' }
  & { tokenAuth?: Maybe<(
    { __typename?: 'ObtainJSONWebToken' }
    & Pick<ObtainJsonWebToken, 'token'>
    & { user?: Maybe<(
      { __typename?: 'UserType' }
      & Pick<UserType, 'id' | 'email' | 'publicName'>
    )> }
  )> }
);

export type SaveTaskMutationVariables = {
  createInput?: Maybe<TaskInputCreate>;
  updateInput?: Maybe<TaskInputUpdate>;
};


export type SaveTaskMutation = (
  { __typename?: 'Mutation' }
  & { saveTask?: Maybe<(
    { __typename?: 'SaveTask' }
    & { task: (
      { __typename?: 'TaskType' }
      & UnapprovedTasksOfUserFragment
    ) }
  )> }
);

export type DetailTaskQueryVariables = {
  taskGroupId: Scalars['ID'];
};


export type DetailTaskQuery = (
  { __typename?: 'Query' }
  & { task: (
    { __typename?: 'TaskType' }
    & DetailTaskFragment
  ) }
);

export type UpdateTaskMutationVariables = {
  task: TaskInputUpdate;
};


export type UpdateTaskMutation = (
  { __typename?: 'Mutation' }
  & { saveTask?: Maybe<(
    { __typename?: 'SaveTask' }
    & { task: (
      { __typename?: 'TaskType' }
      & DetailTaskFragment
    ) }
  )> }
);

export type UpdateApprovalMutationVariables = {
  approval: ApprovalInput;
};


export type UpdateApprovalMutation = (
  { __typename?: 'Mutation' }
  & { saveApproval?: Maybe<(
    { __typename?: 'SaveApproval' }
    & { approval: (
      { __typename?: 'ApprovalType' }
      & Pick<ApprovalType, 'state'>
    ) }
  )> }
);

export type DetailTaskFragment = (
  { __typename?: 'TaskType' }
  & Pick<TaskType, 'id' | 'factor' | 'name' | 'neededTimeSeconds' | 'periodStart' | 'periodEnd' | 'state'>
  & { taskGroup: (
    { __typename?: 'TaskGroupType' }
    & Pick<TaskGroupType, 'id'>
  ), user?: Maybe<(
    { __typename?: 'UserType' }
    & Pick<UserType, 'publicName' | 'id'>
  )>, changes: Array<(
    { __typename?: 'TaskChangeType' }
    & TaskChangesFragment
  )>, approvals: Array<(
    { __typename?: 'ApprovalType' }
    & Pick<ApprovalType, 'state'>
    & { user: (
      { __typename?: 'UserType' }
      & Pick<UserType, 'id' | 'publicName'>
    ) }
  )> }
);

export type TaskChangesFragment = (
  { __typename?: 'TaskChangeType' }
  & Pick<TaskChangeType, 'changedProperty' | 'currentValue' | 'previousValue' | 'timestamp'>
  & { user: (
    { __typename?: 'UserType' }
    & Pick<UserType, 'publicName'>
  ) }
);

export type OtherUsersQueryVariables = {
  userEmail: Scalars['String'];
};


export type OtherUsersQuery = (
  { __typename?: 'Query' }
  & { otherUsers?: Maybe<Array<(
    { __typename?: 'UserType' }
    & OtherUsersFragment
  )>> }
);

export type OtherUsersFragment = (
  { __typename?: 'UserType' }
  & Pick<UserType, 'id' | 'publicName'>
);

export type UnapprovedTasksOfUserFragment = (
  { __typename?: 'TaskType' }
  & Pick<TaskType, 'id' | 'name' | 'periodEnd' | 'state'>
  & { taskGroup: (
    { __typename?: 'TaskGroupType' }
    & Pick<TaskGroupType, 'id'>
  ) }
);

export type ToApproveTasksOfUserQueryVariables = {
  email: Scalars['String'];
};


export type ToApproveTasksOfUserQuery = (
  { __typename?: 'Query' }
  & { toApproveTasksOfUser: Array<(
    { __typename?: 'TaskType' }
    & ToApproveTasksOfUserFragment
  )> }
);

export type ToApproveTasksOfUserFragment = (
  { __typename?: 'TaskType' }
  & Pick<TaskType, 'id' | 'name' | 'periodEnd' | 'state'>
  & { taskGroup: (
    { __typename?: 'TaskGroupType' }
    & Pick<TaskGroupType, 'id'>
  ), approvals: Array<(
    { __typename?: 'ApprovalType' }
    & Pick<ApprovalType, 'state'>
    & { user: (
      { __typename?: 'UserType' }
      & Pick<UserType, 'id' | 'publicName'>
    ) }
  )> }
);

export type TodoTasksOfUserQueryVariables = {
  email: Scalars['String'];
};


export type TodoTasksOfUserQuery = (
  { __typename?: 'Query' }
  & { todoTasksOfUser: Array<(
    { __typename?: 'TaskType' }
    & UnapprovedTasksOfUserFragment
  )> }
);

export type UsersQueryVariables = {};


export type UsersQuery = (
  { __typename?: 'Query' }
  & { users?: Maybe<Array<(
    { __typename?: 'UserType' }
    & UsersFragment
  )>> }
);

export type UsersFragment = (
  { __typename?: 'UserType' }
  & Pick<UserType, 'id' | 'email' | 'publicName'>
);

export type RefreshTokenMutationVariables = {
  token: Scalars['String'];
};


export type RefreshTokenMutation = (
  { __typename?: 'Mutation' }
  & { refreshToken?: Maybe<(
    { __typename?: 'Refresh' }
    & Pick<Refresh, 'token' | 'payload'>
  )> }
);

export const TaskChangesFragmentDoc = gql`
    fragment taskChanges on TaskChangeType {
  changedProperty
  currentValue
  previousValue
  timestamp
  user {
    publicName
  }
}
    `;
export const DetailTaskFragmentDoc = gql`
    fragment detailTask on TaskType {
  id
  taskGroup {
    id
  }
  factor
  name
  neededTimeSeconds
  periodStart
  periodEnd
  state
  user {
    publicName
    id
  }
  changes {
    ...taskChanges
  }
  approvals {
    state
    user {
      id
      publicName
    }
  }
}
    ${TaskChangesFragmentDoc}`;
export const OtherUsersFragmentDoc = gql`
    fragment otherUsers on UserType {
  id
  publicName
}
    `;
export const UnapprovedTasksOfUserFragmentDoc = gql`
    fragment unapprovedTasksOfUser on TaskType {
  id
  taskGroup {
    id
  }
  name
  periodEnd
  state
}
    `;
export const ToApproveTasksOfUserFragmentDoc = gql`
    fragment toApproveTasksOfUser on TaskType {
  id
  taskGroup {
    id
  }
  name
  periodEnd
  state
  approvals {
    user {
      id
      publicName
    }
    state
  }
}
    `;
export const UsersFragmentDoc = gql`
    fragment users on UserType {
  id
  email
  publicName
}
    `;
export const TokenAuthDocument = gql`
    mutation tokenAuth($email: String!, $password: String!) {
  tokenAuth(email: $email, password: $password) {
    token
    user {
      id
      email
      publicName
    }
  }
}
    `;
export type TokenAuthMutationFn = ApolloReactCommon.MutationFunction<TokenAuthMutation, TokenAuthMutationVariables>;

/**
 * __useTokenAuthMutation__
 *
 * To run a mutation, you first call `useTokenAuthMutation` within a React component and pass it any options that fit your needs.
 * When your component renders, `useTokenAuthMutation` returns a tuple that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - An object with fields that represent the current status of the mutation's execution
 *
 * @param baseOptions options that will be passed into the mutation, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options-2;
 *
 * @example
 * const [tokenAuthMutation, { data, loading, error }] = useTokenAuthMutation({
 *   variables: {
 *      email: // value for 'email'
 *      password: // value for 'password'
 *   },
 * });
 */
export function useTokenAuthMutation(baseOptions?: ApolloReactHooks.MutationHookOptions<TokenAuthMutation, TokenAuthMutationVariables>) {
        return ApolloReactHooks.useMutation<TokenAuthMutation, TokenAuthMutationVariables>(TokenAuthDocument, baseOptions);
      }
export type TokenAuthMutationHookResult = ReturnType<typeof useTokenAuthMutation>;
export type TokenAuthMutationResult = ApolloReactCommon.MutationResult<TokenAuthMutation>;
export type TokenAuthMutationOptions = ApolloReactCommon.BaseMutationOptions<TokenAuthMutation, TokenAuthMutationVariables>;
export const SaveTaskDocument = gql`
    mutation saveTask($createInput: TaskInputCreate, $updateInput: TaskInputUpdate) {
  saveTask(createInput: $createInput, updateInput: $updateInput) {
    task {
      ...unapprovedTasksOfUser
    }
  }
}
    ${UnapprovedTasksOfUserFragmentDoc}`;
export type SaveTaskMutationFn = ApolloReactCommon.MutationFunction<SaveTaskMutation, SaveTaskMutationVariables>;

/**
 * __useSaveTaskMutation__
 *
 * To run a mutation, you first call `useSaveTaskMutation` within a React component and pass it any options that fit your needs.
 * When your component renders, `useSaveTaskMutation` returns a tuple that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - An object with fields that represent the current status of the mutation's execution
 *
 * @param baseOptions options that will be passed into the mutation, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options-2;
 *
 * @example
 * const [saveTaskMutation, { data, loading, error }] = useSaveTaskMutation({
 *   variables: {
 *      createInput: // value for 'createInput'
 *      updateInput: // value for 'updateInput'
 *   },
 * });
 */
export function useSaveTaskMutation(baseOptions?: ApolloReactHooks.MutationHookOptions<SaveTaskMutation, SaveTaskMutationVariables>) {
        return ApolloReactHooks.useMutation<SaveTaskMutation, SaveTaskMutationVariables>(SaveTaskDocument, baseOptions);
      }
export type SaveTaskMutationHookResult = ReturnType<typeof useSaveTaskMutation>;
export type SaveTaskMutationResult = ApolloReactCommon.MutationResult<SaveTaskMutation>;
export type SaveTaskMutationOptions = ApolloReactCommon.BaseMutationOptions<SaveTaskMutation, SaveTaskMutationVariables>;
export const DetailTaskDocument = gql`
    query detailTask($taskGroupId: ID!) {
  task(taskGroupId: $taskGroupId) {
    ...detailTask
  }
}
    ${DetailTaskFragmentDoc}`;

/**
 * __useDetailTaskQuery__
 *
 * To run a query within a React component, call `useDetailTaskQuery` and pass it any options that fit your needs.
 * When your component renders, `useDetailTaskQuery` returns an object from Apollo Client that contains loading, error, and data properties
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useDetailTaskQuery({
 *   variables: {
 *      taskGroupId: // value for 'taskGroupId'
 *   },
 * });
 */
export function useDetailTaskQuery(baseOptions?: ApolloReactHooks.QueryHookOptions<DetailTaskQuery, DetailTaskQueryVariables>) {
        return ApolloReactHooks.useQuery<DetailTaskQuery, DetailTaskQueryVariables>(DetailTaskDocument, baseOptions);
      }
export function useDetailTaskLazyQuery(baseOptions?: ApolloReactHooks.LazyQueryHookOptions<DetailTaskQuery, DetailTaskQueryVariables>) {
          return ApolloReactHooks.useLazyQuery<DetailTaskQuery, DetailTaskQueryVariables>(DetailTaskDocument, baseOptions);
        }
export type DetailTaskQueryHookResult = ReturnType<typeof useDetailTaskQuery>;
export type DetailTaskLazyQueryHookResult = ReturnType<typeof useDetailTaskLazyQuery>;
export type DetailTaskQueryResult = ApolloReactCommon.QueryResult<DetailTaskQuery, DetailTaskQueryVariables>;
export const UpdateTaskDocument = gql`
    mutation updateTask($task: TaskInputUpdate!) {
  saveTask(updateInput: $task) {
    task {
      ...detailTask
    }
  }
}
    ${DetailTaskFragmentDoc}`;
export type UpdateTaskMutationFn = ApolloReactCommon.MutationFunction<UpdateTaskMutation, UpdateTaskMutationVariables>;

/**
 * __useUpdateTaskMutation__
 *
 * To run a mutation, you first call `useUpdateTaskMutation` within a React component and pass it any options that fit your needs.
 * When your component renders, `useUpdateTaskMutation` returns a tuple that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - An object with fields that represent the current status of the mutation's execution
 *
 * @param baseOptions options that will be passed into the mutation, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options-2;
 *
 * @example
 * const [updateTaskMutation, { data, loading, error }] = useUpdateTaskMutation({
 *   variables: {
 *      task: // value for 'task'
 *   },
 * });
 */
export function useUpdateTaskMutation(baseOptions?: ApolloReactHooks.MutationHookOptions<UpdateTaskMutation, UpdateTaskMutationVariables>) {
        return ApolloReactHooks.useMutation<UpdateTaskMutation, UpdateTaskMutationVariables>(UpdateTaskDocument, baseOptions);
      }
export type UpdateTaskMutationHookResult = ReturnType<typeof useUpdateTaskMutation>;
export type UpdateTaskMutationResult = ApolloReactCommon.MutationResult<UpdateTaskMutation>;
export type UpdateTaskMutationOptions = ApolloReactCommon.BaseMutationOptions<UpdateTaskMutation, UpdateTaskMutationVariables>;
export const UpdateApprovalDocument = gql`
    mutation updateApproval($approval: ApprovalInput!) {
  saveApproval(input: $approval) {
    approval {
      state
    }
  }
}
    `;
export type UpdateApprovalMutationFn = ApolloReactCommon.MutationFunction<UpdateApprovalMutation, UpdateApprovalMutationVariables>;

/**
 * __useUpdateApprovalMutation__
 *
 * To run a mutation, you first call `useUpdateApprovalMutation` within a React component and pass it any options that fit your needs.
 * When your component renders, `useUpdateApprovalMutation` returns a tuple that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - An object with fields that represent the current status of the mutation's execution
 *
 * @param baseOptions options that will be passed into the mutation, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options-2;
 *
 * @example
 * const [updateApprovalMutation, { data, loading, error }] = useUpdateApprovalMutation({
 *   variables: {
 *      approval: // value for 'approval'
 *   },
 * });
 */
export function useUpdateApprovalMutation(baseOptions?: ApolloReactHooks.MutationHookOptions<UpdateApprovalMutation, UpdateApprovalMutationVariables>) {
        return ApolloReactHooks.useMutation<UpdateApprovalMutation, UpdateApprovalMutationVariables>(UpdateApprovalDocument, baseOptions);
      }
export type UpdateApprovalMutationHookResult = ReturnType<typeof useUpdateApprovalMutation>;
export type UpdateApprovalMutationResult = ApolloReactCommon.MutationResult<UpdateApprovalMutation>;
export type UpdateApprovalMutationOptions = ApolloReactCommon.BaseMutationOptions<UpdateApprovalMutation, UpdateApprovalMutationVariables>;
export const OtherUsersDocument = gql`
    query otherUsers($userEmail: String!) {
  otherUsers(userEmail: $userEmail) {
    ...otherUsers
  }
}
    ${OtherUsersFragmentDoc}`;

/**
 * __useOtherUsersQuery__
 *
 * To run a query within a React component, call `useOtherUsersQuery` and pass it any options that fit your needs.
 * When your component renders, `useOtherUsersQuery` returns an object from Apollo Client that contains loading, error, and data properties
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useOtherUsersQuery({
 *   variables: {
 *      userEmail: // value for 'userEmail'
 *   },
 * });
 */
export function useOtherUsersQuery(baseOptions?: ApolloReactHooks.QueryHookOptions<OtherUsersQuery, OtherUsersQueryVariables>) {
        return ApolloReactHooks.useQuery<OtherUsersQuery, OtherUsersQueryVariables>(OtherUsersDocument, baseOptions);
      }
export function useOtherUsersLazyQuery(baseOptions?: ApolloReactHooks.LazyQueryHookOptions<OtherUsersQuery, OtherUsersQueryVariables>) {
          return ApolloReactHooks.useLazyQuery<OtherUsersQuery, OtherUsersQueryVariables>(OtherUsersDocument, baseOptions);
        }
export type OtherUsersQueryHookResult = ReturnType<typeof useOtherUsersQuery>;
export type OtherUsersLazyQueryHookResult = ReturnType<typeof useOtherUsersLazyQuery>;
export type OtherUsersQueryResult = ApolloReactCommon.QueryResult<OtherUsersQuery, OtherUsersQueryVariables>;
export const ToApproveTasksOfUserDocument = gql`
    query toApproveTasksOfUser($email: String!) {
  toApproveTasksOfUser(userEmail: $email) {
    ...toApproveTasksOfUser
  }
}
    ${ToApproveTasksOfUserFragmentDoc}`;

/**
 * __useToApproveTasksOfUserQuery__
 *
 * To run a query within a React component, call `useToApproveTasksOfUserQuery` and pass it any options that fit your needs.
 * When your component renders, `useToApproveTasksOfUserQuery` returns an object from Apollo Client that contains loading, error, and data properties
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useToApproveTasksOfUserQuery({
 *   variables: {
 *      email: // value for 'email'
 *   },
 * });
 */
export function useToApproveTasksOfUserQuery(baseOptions?: ApolloReactHooks.QueryHookOptions<ToApproveTasksOfUserQuery, ToApproveTasksOfUserQueryVariables>) {
        return ApolloReactHooks.useQuery<ToApproveTasksOfUserQuery, ToApproveTasksOfUserQueryVariables>(ToApproveTasksOfUserDocument, baseOptions);
      }
export function useToApproveTasksOfUserLazyQuery(baseOptions?: ApolloReactHooks.LazyQueryHookOptions<ToApproveTasksOfUserQuery, ToApproveTasksOfUserQueryVariables>) {
          return ApolloReactHooks.useLazyQuery<ToApproveTasksOfUserQuery, ToApproveTasksOfUserQueryVariables>(ToApproveTasksOfUserDocument, baseOptions);
        }
export type ToApproveTasksOfUserQueryHookResult = ReturnType<typeof useToApproveTasksOfUserQuery>;
export type ToApproveTasksOfUserLazyQueryHookResult = ReturnType<typeof useToApproveTasksOfUserLazyQuery>;
export type ToApproveTasksOfUserQueryResult = ApolloReactCommon.QueryResult<ToApproveTasksOfUserQuery, ToApproveTasksOfUserQueryVariables>;
export const TodoTasksOfUserDocument = gql`
    query todoTasksOfUser($email: String!) {
  todoTasksOfUser(userEmail: $email) {
    ...unapprovedTasksOfUser
  }
}
    ${UnapprovedTasksOfUserFragmentDoc}`;

/**
 * __useTodoTasksOfUserQuery__
 *
 * To run a query within a React component, call `useTodoTasksOfUserQuery` and pass it any options that fit your needs.
 * When your component renders, `useTodoTasksOfUserQuery` returns an object from Apollo Client that contains loading, error, and data properties
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useTodoTasksOfUserQuery({
 *   variables: {
 *      email: // value for 'email'
 *   },
 * });
 */
export function useTodoTasksOfUserQuery(baseOptions?: ApolloReactHooks.QueryHookOptions<TodoTasksOfUserQuery, TodoTasksOfUserQueryVariables>) {
        return ApolloReactHooks.useQuery<TodoTasksOfUserQuery, TodoTasksOfUserQueryVariables>(TodoTasksOfUserDocument, baseOptions);
      }
export function useTodoTasksOfUserLazyQuery(baseOptions?: ApolloReactHooks.LazyQueryHookOptions<TodoTasksOfUserQuery, TodoTasksOfUserQueryVariables>) {
          return ApolloReactHooks.useLazyQuery<TodoTasksOfUserQuery, TodoTasksOfUserQueryVariables>(TodoTasksOfUserDocument, baseOptions);
        }
export type TodoTasksOfUserQueryHookResult = ReturnType<typeof useTodoTasksOfUserQuery>;
export type TodoTasksOfUserLazyQueryHookResult = ReturnType<typeof useTodoTasksOfUserLazyQuery>;
export type TodoTasksOfUserQueryResult = ApolloReactCommon.QueryResult<TodoTasksOfUserQuery, TodoTasksOfUserQueryVariables>;
export const UsersDocument = gql`
    query users {
  users {
    ...users
  }
}
    ${UsersFragmentDoc}`;

/**
 * __useUsersQuery__
 *
 * To run a query within a React component, call `useUsersQuery` and pass it any options that fit your needs.
 * When your component renders, `useUsersQuery` returns an object from Apollo Client that contains loading, error, and data properties
 * you can use to render your UI.
 *
 * @param baseOptions options that will be passed into the query, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options;
 *
 * @example
 * const { data, loading, error } = useUsersQuery({
 *   variables: {
 *   },
 * });
 */
export function useUsersQuery(baseOptions?: ApolloReactHooks.QueryHookOptions<UsersQuery, UsersQueryVariables>) {
        return ApolloReactHooks.useQuery<UsersQuery, UsersQueryVariables>(UsersDocument, baseOptions);
      }
export function useUsersLazyQuery(baseOptions?: ApolloReactHooks.LazyQueryHookOptions<UsersQuery, UsersQueryVariables>) {
          return ApolloReactHooks.useLazyQuery<UsersQuery, UsersQueryVariables>(UsersDocument, baseOptions);
        }
export type UsersQueryHookResult = ReturnType<typeof useUsersQuery>;
export type UsersLazyQueryHookResult = ReturnType<typeof useUsersLazyQuery>;
export type UsersQueryResult = ApolloReactCommon.QueryResult<UsersQuery, UsersQueryVariables>;
export const RefreshTokenDocument = gql`
    mutation refreshToken($token: String!) {
  refreshToken(token: $token) {
    token
    payload
  }
}
    `;
export type RefreshTokenMutationFn = ApolloReactCommon.MutationFunction<RefreshTokenMutation, RefreshTokenMutationVariables>;

/**
 * __useRefreshTokenMutation__
 *
 * To run a mutation, you first call `useRefreshTokenMutation` within a React component and pass it any options that fit your needs.
 * When your component renders, `useRefreshTokenMutation` returns a tuple that includes:
 * - A mutate function that you can call at any time to execute the mutation
 * - An object with fields that represent the current status of the mutation's execution
 *
 * @param baseOptions options that will be passed into the mutation, supported options are listed on: https://www.apollographql.com/docs/react/api/react-hooks/#options-2;
 *
 * @example
 * const [refreshTokenMutation, { data, loading, error }] = useRefreshTokenMutation({
 *   variables: {
 *      token: // value for 'token'
 *   },
 * });
 */
export function useRefreshTokenMutation(baseOptions?: ApolloReactHooks.MutationHookOptions<RefreshTokenMutation, RefreshTokenMutationVariables>) {
        return ApolloReactHooks.useMutation<RefreshTokenMutation, RefreshTokenMutationVariables>(RefreshTokenDocument, baseOptions);
      }
export type RefreshTokenMutationHookResult = ReturnType<typeof useRefreshTokenMutation>;
export type RefreshTokenMutationResult = ApolloReactCommon.MutationResult<RefreshTokenMutation>;
export type RefreshTokenMutationOptions = ApolloReactCommon.BaseMutationOptions<RefreshTokenMutation, RefreshTokenMutationVariables>;