import React, { useState } from 'react';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import {
  DetailTaskDocument,
  DetailTaskQuery,
  DetailTaskQueryVariables,
  useDetailTaskQuery,
  useUpdateTaskMutation
} from '../../../graphql/types';
import { StyleSheet, Text, View } from 'react-native';
import { NavigationProp, RouteProp } from '@react-navigation/native';
import { RootStackParamList } from '../../NavigationWrapper';
import { Avatar, List, useTheme } from 'react-native-paper';
import {
  getTaskStateIconProps,
  ISODateStringToLocaleDateString,
  relativeDateString,
  secondsToElapsedTimeString,
  transformTaskState
} from '../../../utils/transformer';
import moment from 'moment';
import TaskTimer from './TaskTimer';

interface DetailTaskProps {
  route: RouteProp<RootStackParamList, 'detailTask'>,
  navigation: NavigationProp<RootStackParamList, 'detailTask'>,
}

export default function DetailTask({route, navigation}: DetailTaskProps) {
  navigation.setOptions({headerTitle: route.params.taskName});

  const theme = useTheme();

  const [dummyValue, setDummyValue] = useState(false);

  const [saveTaskMutation] = useUpdateTaskMutation();
  let {loading, data} = useDetailTaskQuery({
    query: DetailTaskDocument,
    variables: {
      taskGroupId: route.params.taskGroupId
    },
  });

  function updateView() {
    setDummyValue(!dummyValue)
  }

  function onTimerStop(elapsedSeconds: number): void {
    if (data?.task) {
      saveTaskMutation({
        variables: {
          task: {
            taskGroupId: data.task.taskGroup.id,
            neededTimeSeconds: data.task.neededTimeSeconds + elapsedSeconds
          }
        },
        optimisticResponse: {
          saveTask: {
            task: {
              ...data.task,
              neededTimeSeconds: data.task.neededTimeSeconds + elapsedSeconds,
            }, __typename: 'SaveTask'
          }, __typename: 'Mutation'
        },
        update: (proxy, fetchResult) => {
          if (fetchResult.data?.saveTask?.task && data?.task) {
            proxy.writeQuery<DetailTaskQuery, DetailTaskQueryVariables>({
              query: DetailTaskDocument,
              data: {task: {...fetchResult.data.saveTask.task}},
              variables: {
                taskGroupId: data.task.taskGroup.id
              }
            })
          }
          updateView() // TODO updateQuery should update view (updating the optimisticResponse)
        }
      }).then(() => updateView()); // TODO updateQuery should update view (updating the actual response)
    }
  }

  if (loading) {
    return <LoadingSpinner/>
  }

  if (data) {
    const task = data.task;
    const overdue = moment(task.periodEnd).isBefore(moment());
    return (
        <View>
          <List.Item style={styles.listItem}
                     title="Status"
                     left={props => <Avatar.Icon{...props}
                                                style={styles.statusAvatar}
                                                size={80}
                                                {...getTaskStateIconProps(task.state, theme)}
                     />}
                     description={transformTaskState(task.state)}
          />
          <List.Item style={styles.listItem}
                     title="Zuweisung"
                     left={props => <List.Icon {...props} icon="account"/>}
                     description={task.user?.publicName || 'Niemandem zugewiesen'}
          />
          <List.Item style={styles.listItem}
                     title="Faktor"
                     left={props => <List.Icon {...props} icon="chart-line"/>}
                     description={task.factor + 'x'}
          />
          <List.Item style={styles.listItem}
                     title="Benötigte Zeit"
                     left={props => <List.Icon {...props} icon="clock-outline"/>}
                     right={props => <TaskTimer
                         {...props}
                         loading={false}
                         theme={theme}
                         onTimerStop={onTimerStop}
                     />}
                     description={secondsToElapsedTimeString(task.neededTimeSeconds)}
          />
          <List.Item style={styles.listItem}
                     title="Frühestens machen am"
                     left={props => <List.Icon {...props} icon="calendar-check"/>}
                     description={ISODateStringToLocaleDateString(task.periodStart) + ` (${relativeDateString(task.periodStart)})`}
          />
          <List.Item style={styles.listItem}
                     title="Spätestens machen am"
                     left={props =>
                         <List.Icon {...{...props, ...(overdue ? {color: theme.colors.error} : {})}}
                                    icon="calendar-clock"/>}
                     description={<Text style={overdue ? {color: theme.colors.error} : undefined}>
                       {ISODateStringToLocaleDateString(task.periodEnd) + ` (${relativeDateString(task.periodEnd)})`}
                     </Text>}
          />
        </View>
    )
  }

  return null;
}

const styles = StyleSheet.create({
  listItem: {
    marginTop: -10,
    marginLeft: 10
  },
  statusAvatar: {
    backgroundColor: 'transparent',
    marginLeft: -20,
    marginRight: -5,
    marginBottom: -5
  }
});
