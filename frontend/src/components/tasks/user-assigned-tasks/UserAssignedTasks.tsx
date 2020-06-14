import React from 'react';
import { useAuth } from '../../../hooks/auth/use-auth';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import { useTodoTasksOfUserQuery } from '../../../graphql/types';
import UserAssignedTasksView from './view/UserAssignedTasksView'
import { useNavigation } from '@react-navigation/native';
import { RootStackParamList } from '../../NavigationWrapper';
import { StackNavigationProp } from '@react-navigation/stack/lib/typescript/src/types';

export default function UserAssignedTasks() {

  const {user} = useAuth();
  const navigation = useNavigation<StackNavigationProp<RootStackParamList>>();


  let {loading, data} = useTodoTasksOfUserQuery({
    variables: {
      email: user.email
    }
  });

  function navigateToTaskDetail(taskGroupId: string, taskName: string): void {
    navigation.navigate('detailTask', {
      taskGroupId,
      taskName
    })
  }

  if (loading) {
    return <LoadingSpinner/>
  }

  if (data) {
    return <UserAssignedTasksView
        tasks={data?.todoTasksOfUser || []}
        onTaskPress={navigateToTaskDetail}
    />
  }

  return null
}
