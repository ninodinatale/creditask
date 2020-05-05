import React from 'react';
import { useAuth } from '../../../hooks/auth/use-auth';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import { useTodoTasksOfUserQuery } from '../../../graphql/types';
import UserAssignedTasksView from './view/UserAssignedTasksView'

export default function UserAssignedTasks() {

  const {user} = useAuth();

  let {loading, data} = useTodoTasksOfUserQuery({
    variables: {
      email: user.email
    }
  });

  if (loading) {
    return <LoadingSpinner/>
  }

  if (data) {
    return <UserAssignedTasksView tasks={data?.todoTasksOfUser}/>
  }
}
