import React, { useState } from 'react';
import { useAuth } from '../../../hooks/auth/use-auth';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import { TodoTasksOfUserQueryVariables, useTodoTasksOfUserQuery } from '../../../graphql/types';
import UserAssignedTasksView from './view/UserAssignedTasksView'
import { useNavigation } from '@react-navigation/native';
import { RootStackParamList } from '../../NavigationWrapper';
import { StackNavigationProp } from '@react-navigation/stack/lib/typescript/src/types';
import { RefreshControl } from 'react-native';
import { useTheme } from 'react-native-paper';

export default function UserAssignedTasks() {

  const {user} = useAuth();
  const theme = useTheme();
  const [refreshing, setRefreshing] = useState(false);
  const navigation = useNavigation<StackNavigationProp<RootStackParamList>>();

  const queryVariables: TodoTasksOfUserQueryVariables = {email: user.email};


  let {loading, data, refetch} = useTodoTasksOfUserQuery({
    variables: queryVariables
  });

  function navigateToTaskDetail(taskGroupId: string, taskName: string): void {
    navigation.navigate('detailTask', {
      taskGroupId,
      taskName
    })
  }

  function onRefresh() {
    setRefreshing(true);
    refetch(queryVariables).then(() => setRefreshing(false))
  }

  if (loading) {
    return <LoadingSpinner/>
  }

  if (data) {
    return (
        <RefreshControl colors={[theme.colors.primary]} onRefresh={onRefresh} refreshing={refreshing}>
          <UserAssignedTasksView
              tasks={data?.todoTasksOfUser || []}
              onTaskPress={navigateToTaskDetail}
          />
        </RefreshControl>)
  }

  return null
}
