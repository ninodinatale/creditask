import React, { useState } from 'react';
import { useAuth } from '../../../hooks/auth/use-auth';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import {
  TaskState,
  TodoTasksOfUserQueryVariables,
  UnapprovedTasksOfUserFragment,
  useTodoTasksOfUserQuery
} from '../../../graphql/types';
import { useNavigation } from '@react-navigation/native';
import { RootStackParamList } from '../../NavigationWrapper';
import { StackNavigationProp } from '@react-navigation/stack/lib/typescript/src/types';
import { RefreshControl, View } from 'react-native';
import { Avatar, List, Text, TouchableRipple, useTheme } from 'react-native-paper';
import {
  getTaskStateIconProps,
  ISODateStringToLocaleDateString,
  ISODateStringToMoment,
  relativeDateString
} from '../../../utils/transformer';
import moment from 'moment';

export default function UserTodoTasks(props: any) {

  const {user} = useAuth();
  const theme = useTheme();
  const [refreshing, setRefreshing] = useState(false);
  const navigation = useNavigation<StackNavigationProp<RootStackParamList>>();

  const queryVariables: TodoTasksOfUserQueryVariables = {email: user.email};


  const {loading, data, refetch} = useTodoTasksOfUserQuery({
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

  function getItem(args: {
    headerText: string,
    index: number,
    overdue?: boolean
    task: UnapprovedTasksOfUserFragment,
  }) {
    const {headerText, task, index, overdue} = args;
    return (
        <View key={task.id}>
          {index == 0 ? <List.Subheader>{headerText}</List.Subheader> : null}
          <TouchableRipple
              onPress={() => navigateToTaskDetail(task.taskGroup.id, task.name)}
              key={task.id}
          >
            <List.Item
                key={task.id}
                title={task.name}
                left={props => <Avatar.Image {...props}
                                             source={require('../../../../assets/dummy.jpg')}/>} // TODO image source
                right={props => {
                  if (task.state === TaskState.ToApprove) {
                    return <List.Icon {...props} {...getTaskStateIconProps(task.state, theme)}/>
                  }
                  if (overdue) {
                    return <List.Icon {...props} color={theme.colors.error} icon="calendar-clock"/>
                  }
                }}
                description={<Text
                    style={task.state === TaskState.ToDo && overdue ? {color: theme.colors.error} : undefined}>
                  {`Fällig am ${ISODateStringToLocaleDateString(task.periodEnd)} (${relativeDateString(task.periodEnd)})`}</Text>}
            />
          </TouchableRipple>
        </View>
    )
  }

  if (loading) {
    return <LoadingSpinner/>
  }

  if (data) {
    if (!data.todoTasksOfUser || !data.todoTasksOfUser.length) {
      return (
          <View {...props}
                style={{
                  flex: 1,
                  flexDirection: 'row',
                  justifyContent: 'center',
                  alignItems: 'center'
                }}>
            <Text
                {...props}
                style={{
                  fontSize: 20,
                  color: theme.colors.backdrop
                }}
            >Keine Aufgaben von dir 🥳</Text>
          </View>
      )
    }

    const toApproveTasks = [];
    const overdueTasks = [];
    const todayTasks = [];
    const next7DaysTasks = [];
    const fartherTasks = [];

    for (let task of data.todoTasksOfUser) {
      const now = moment().startOf('day');
      const periodEndMoment = ISODateStringToMoment(task.periodEnd);

      if (task.state !== TaskState.ToDo) {
        toApproveTasks.push(task)
      } else if (periodEndMoment.isBefore(now)) {
        overdueTasks.push(task)
      } else if (periodEndMoment.isSame(now)) {
        todayTasks.push(task)
      } else if (periodEndMoment.isBefore(now.add(7, 'days'))) {
        next7DaysTasks.push(task)
      } else {
        fartherTasks.push(task)
      }
    }

    return (
        <RefreshControl colors={[theme.colors.primary]} onRefresh={onRefresh}
                        refreshing={refreshing}>
          <View>
            {
              toApproveTasks.length > 0 &&
              toApproveTasks.map((task, index) => getItem({
                task,
                headerText: 'Zu bestätigen',
                index,
                overdue: true
              }))
            }
            {
              overdueTasks.length > 0 &&
              overdueTasks.map((task, index) => getItem({
                task,
                headerText: 'Überfällig',
                index,
                overdue: true
              }))
            }
            {
              todayTasks.length > 0 &&
              todayTasks.map((task, index) => getItem({task, headerText: 'Heute zu machen', index}))
            }
            {
              next7DaysTasks.length > 0 &&
              next7DaysTasks.map((task, index) => getItem({
                task,
                headerText: 'In den nächsten 7 Tagen',
                index
              }))
            }
            {
              fartherTasks.length > 0 &&
              fartherTasks.map((task, index) => getItem({task, headerText: 'Später', index}))
            }
          </View>
        </RefreshControl>
    )
  }

  return null
}
