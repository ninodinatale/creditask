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
  Date: any;
  DateTime: Date;
  GenericScalar: any;
};






export type Mutation = {
  saveTask: Maybe<SaveTask>;
  tokenAuth: Maybe<ObtainJsonWebToken>;
  verifyToken: Maybe<Verify>;
  refreshToken: Maybe<Refresh>;
};


export type MutationSaveTaskArgs = {
  createInput: Maybe<TaskInputCreate>;
  updateInput: Maybe<TaskInputUpdate>;
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
  token: Maybe<Scalars['String']>;
  user: Maybe<UserType>;
};

export type Query = {
  task: TaskType;
  todoTasksOfUser: Maybe<Array<TaskType>>;
  user: Maybe<UserType>;
  users: Maybe<Array<UserType>>;
  otherUsers: Maybe<Array<UserType>>;
};


export type QueryTaskArgs = {
  taskId: Scalars['ID'];
};


export type QueryTodoTasksOfUserArgs = {
  userEmail: Scalars['String'];
};


export type QueryUserArgs = {
  id: Scalars['Int'];
};


export type QueryOtherUsersArgs = {
  userEmail: Scalars['String'];
};

export type Refresh = {
  token: Maybe<Scalars['String']>;
  payload: Maybe<Scalars['GenericScalar']>;
};

export type SaveTask = {
  task: TaskType;
};

export type TaskInputCreate = {
  name: Scalars['CustomString'];
  factor: Scalars['CustomFloat'];
  userId: Maybe<Scalars['ID']>;
  periodStart: Maybe<Scalars['Date']>;
  periodEnd: Maybe<Scalars['Date']>;
};

export type TaskInputUpdate = {
  name: Maybe<Scalars['CustomString']>;
  factor: Maybe<Scalars['CustomFloat']>;
  userId: Maybe<Scalars['ID']>;
  periodStart: Maybe<Scalars['Date']>;
  periodEnd: Maybe<Scalars['Date']>;
};

export enum TaskState {
  Unknown = 'UNKNOWN',
  ToDo = 'TO_DO',
  ToApprove = 'TO_APPROVE',
  Declined = 'DECLINED',
  UnderConditions = 'UNDER_CONDITIONS',
  Approved = 'APPROVED'
}

export type TaskType = {
  id: Scalars['ID'];
  createdAt: Scalars['DateTime'];
  createdBy: Maybe<UserType>;
  isDeleted: Scalars['Boolean'];
  name: Scalars['String'];
  neededTimeSeconds: Scalars['Int'];
  state: TaskState;
  factor: Scalars['Int'];
  user: Maybe<UserType>;
  periodStart: Scalars['Date'];
  periodEnd: Scalars['Date'];
  done: Scalars['Boolean'];
};

export type UserType = {
  id: Scalars['ID'];
  password: Scalars['String'];
  lastLogin: Maybe<Scalars['DateTime']>;
  email: Scalars['String'];
  publicName: Scalars['String'];
  credits: Scalars['Int'];
  isStaff: Scalars['Boolean'];
  isSuperuser: Scalars['Boolean'];
  isActive: Scalars['Boolean'];
  taskSet: Array<TaskType>;
};

export type Verify = {
  payload: Maybe<Scalars['GenericScalar']>;
};

export type TokenAuthMutationVariables = {
  email: Scalars['String'];
  password: Scalars['String'];
};


export type TokenAuthMutation = { tokenAuth: Maybe<(
    Pick<ObtainJsonWebToken, 'token'>
    & { user: Maybe<Pick<UserType, 'id' | 'email' | 'publicName'>> }
  )> };

export type SaveTaskMutationVariables = {
  createInput: Maybe<TaskInputCreate>;
  updateInput: Maybe<TaskInputUpdate>;
};


export type SaveTaskMutation = { saveTask: Maybe<{ task: UnapprovedTasksOfUserFragment }> };

export type DetailTaskQueryVariables = {
  taskId: Scalars['ID'];
};


export type DetailTaskQuery = { task: DetailTaskFragment };

export type DetailTaskFragment = (
  Pick<TaskType, 'id' | 'done' | 'factor' | 'name' | 'neededTimeSeconds' | 'periodStart' | 'periodEnd' | 'state'>
  & { user: Maybe<Pick<UserType, 'publicName'>> }
);

export type OtherUsersQueryVariables = {
  userEmail: Scalars['String'];
};


export type OtherUsersQuery = { otherUsers: Maybe<Array<OtherUsersFragment>> };

export type OtherUsersFragment = Pick<UserType, 'id' | 'publicName'>;

export type UnapprovedTasksOfUserFragment = Pick<TaskType, 'id' | 'name' | 'done' | 'periodEnd'>;

export type TodoTasksOfUserQueryVariables = {
  email: Scalars['String'];
};


export type TodoTasksOfUserQuery = { todoTasksOfUser: Maybe<Array<UnapprovedTasksOfUserFragment>> };

export type UsersQueryVariables = {};


export type UsersQuery = { users: Maybe<Array<UsersFragment>> };

export type UsersFragment = Pick<UserType, 'id' | 'email' | 'publicName'>;

export type RefreshTokenMutationVariables = {
  token: Scalars['String'];
};


export type RefreshTokenMutation = { refreshToken: Maybe<Pick<Refresh, 'token' | 'payload'>> };

export const DetailTaskFragmentDoc = gql`
    fragment detailTask on TaskType {
  id
  done
  factor
  name
  neededTimeSeconds
  periodStart
  periodEnd
  state
  user {
    publicName
  }
}
    `;
export const OtherUsersFragmentDoc = gql`
    fragment otherUsers on UserType {
  id
  publicName
}
    `;
export const UnapprovedTasksOfUserFragmentDoc = gql`
    fragment unapprovedTasksOfUser on TaskType {
  id
  name
  done
  periodEnd
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
    query detailTask($taskId: ID!) {
  task(taskId: $taskId) {
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
 *      taskId: // value for 'taskId'
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