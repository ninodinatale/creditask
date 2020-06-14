import React from 'react';
import { Avatar, List, TouchableRipple, useTheme } from 'react-native-paper';
import { UnapprovedTasksOfUserFragment } from '../../../../graphql/types';
import { Text, View } from 'react-native';
import {
  ISODateStringToLocaleDateString,
  ISODateStringToMoment,
  relativeDateString
} from '../../../../utils/transformer';
import moment from 'moment';

export type UserAssignedTasksProps = {
  tasks?: UnapprovedTasksOfUserFragment[]
  onTaskPress: (taskId: string, taskName: string) => void
}

export default function UserAssignedTasksView(props: UserAssignedTasksProps) {

  const {tasks, onTaskPress} = props;

  const theme = useTheme();

  if (!tasks || !tasks.length) {
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
                fontSize: 20
              }}
          >Keine Aufgaben von dir 🥳</Text>
        </View>
    )
  }

  const overdueTasks = [];
  const todayTasks = [];
  const next7DaysTasks = [];
  const fartherTasks = [];

  for (let task of tasks) {
    const now = moment(new Date());
    const periodEndMoment = ISODateStringToMoment(task.periodEnd);

    if (periodEndMoment.isBefore(now)) {
      overdueTasks.push(task)
    } else if (periodEndMoment.isSame(now)) {
      todayTasks.push(task)
    } else if (periodEndMoment.isBefore(now.add(7, 'days'))) {
      next7DaysTasks.push(task)
    } else {
      fartherTasks.push(task)
    }
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
              onPress={() => onTaskPress(task.taskGroup.id, task.name)}
              key={task.id}
          >
            <List.Item
                key={task.id}
                title={task.name}
                left={props => <Avatar.Image {...props}
                                             source={require('../../../../../assets/dummy.jpg')}/>} // TODO image source
                right={props => overdue ?
                    <List.Icon {...props} color={theme.colors.error} icon="calendar-clock"/> : null}
                description={<Text style={overdue ? {color: theme.colors.error} : undefined}>
                  {`Fällig am ${ISODateStringToLocaleDateString(task.periodEnd)} (${relativeDateString(task.periodEnd)})`}</Text>}
            />
          </TouchableRipple>
        </View>
    )
  }

  return (
      <View>
        {
          overdueTasks.length > 0 &&
          overdueTasks.map((task, index) => getItem({
            task,
            headerText: 'Overdue Tasks',
            index,
            overdue: true
          }))
        }
        {
          todayTasks.length > 0 &&
          todayTasks.map((task, index) => getItem({task, headerText: 'todayTasks', index}))
        }
        {
          next7DaysTasks.length > 0 &&
          next7DaysTasks.map((task, index) => getItem({task, headerText: 'next7DaysTasks', index}))
        }
        {
          fartherTasks.length > 0 &&
          fartherTasks.map((task, index) => getItem({task, headerText: 'fartherTasks', index}))
        }
      </View>
  )
}
