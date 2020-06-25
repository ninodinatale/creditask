import React, { useState } from 'react';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import {
  DetailTaskDocument,
  DetailTaskQuery,
  DetailTaskQueryVariables,
  TaskInputUpdate,
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
import EditButton from './EditButton';
import { canEditTaskProperty, validatePeriods } from '../../../utils/validators';

interface DetailTaskProps {
  route: RouteProp<RootStackParamList, 'detailTask'>,
  navigation: NavigationProp<RootStackParamList, 'detailTask'>,
}

export default function DetailTask({route, navigation}: DetailTaskProps) {
  navigation.setOptions({headerTitle: route.params.taskName});

  const theme = useTheme();

  const [dummyValue, setDummyValue] = useState(false);

  const [updateTaskMutation] = useUpdateTaskMutation();
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
      onEditTask('neededTimeSeconds', data.task.neededTimeSeconds + elapsedSeconds)
    }
  }

  function onEditTask<T extends TaskInputUpdate, K extends keyof T>(propertyToUpdate: K, newValue: T[K]): void {
    if (data?.task) {
      updateTaskMutation({
        variables: {
          task: {
            taskGroupId: data.task.taskGroup.id,
            [propertyToUpdate]: newValue
          }
        },
        optimisticResponse: {
          saveTask: {
            task: {
              ...data.task,
              [propertyToUpdate]: newValue
            }, __typename: 'SaveTask'
          }, __typename: 'Mutation'
        },
        update: (proxy, fetchResult) => {
          if (fetchResult.data?.saveTask?.task && data?.task) {
            proxy.writeQuery<DetailTaskQuery, DetailTaskQueryVariables>({
              query: DetailTaskDocument,
              data: {task: {...fetchResult.data.saveTask.task, id: data.task.id},},
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
                     right={props => <EditButton {...props}
                                                 hidden={!canEditTaskProperty('userId', task.state)}
                                                 title={'Zuweisung'}
                                                 onSubmit={(newValue) => onEditTask('userId', newValue)}
                                                 initialValue={task.user?.id || ''} theme={theme}
                                                 inputType={'userAssignment'}/>}
                     description={task.user?.publicName || 'Niemandem zugewiesen'}
          />
          <List.Item style={styles.listItem}
                     title="Faktor"
                     left={props => <List.Icon {...props} icon="chart-line"/>}
                     right={props => <EditButton {...props} title={'Faktor'}
                                                 hidden={!canEditTaskProperty('factor', task.state)}
                                                 onSubmit={(newValue) => onEditTask('factor', +newValue)}
                                                 initialValue={task.factor + ''} theme={theme}
                                                 inputType={'factor'}/>}
                     description={task.factor + 'x'}
          />
          <List.Item style={styles.listItem}
                     title="Benötigte Zeit"
                     left={props => <List.Icon {...props} icon="clock-outline"/>}
                     right={props => canEditTaskProperty('neededTimeSeconds', task.state) ?
                         <View {...props} style={{
                           flex: 0,
                           flexDirection: 'row',
                           alignItems: 'center'
                         }}>
                           <TaskTimer
                               {...props}
                               loading={false}
                               theme={theme}
                               onTimerStop={onTimerStop}
                           />
                           <EditButton {...props} title={'Benötigte Zeit'}
                                       hidden={!canEditTaskProperty('neededTimeSeconds', task.state)}
                                       onSubmit={(newValue) => onEditTask('neededTimeSeconds', +newValue)}
                                       initialValue={task.neededTimeSeconds + ''} theme={theme}
                                       inputType={'neededTimeSeconds'}/>
                         </View> : undefined}
                     description={secondsToElapsedTimeString(task.neededTimeSeconds)}
          />
          <List.Item style={styles.listItem}
                     title="Frühestens machen am"
                     left={props => <List.Icon {...props} icon="calendar-check"/>}
                     right={props => <EditButton {...props}
                                                 hidden={!canEditTaskProperty('periodStart', task.state)}
                                                 title={'Frühstens machen am'}
                                                 validateFn={(value) => validatePeriods(moment(value), moment(task.periodEnd))}
                                                 onSubmit={(newValue) => onEditTask('periodStart', newValue)}
                                                 initialValue={task.periodStart} theme={theme}
                                                 inputType={'periodStart'}/>}
                     description={ISODateStringToLocaleDateString(task.periodStart) + ` (${relativeDateString(task.periodStart)})`}
          />
          <List.Item style={styles.listItem}
                     title="Spätestens machen am"
                     left={props =>
                         <List.Icon {...{...props, ...(overdue ? {color: theme.colors.error} : {})}}
                                    icon="calendar-clock"/>}
                     right={props => <EditButton {...props}
                                                 hidden={!canEditTaskProperty('periodEnd', task.state)}
                                                 title={'Spätestens machen am'}
                                                 validateFn={(value) => validatePeriods(moment(task.periodStart), moment(value))}
                                                 onSubmit={(newValue) => onEditTask('periodEnd', newValue)}
                                                 initialValue={task.periodEnd} theme={theme}
                                                 inputType={'periodEnd'}/>}
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
