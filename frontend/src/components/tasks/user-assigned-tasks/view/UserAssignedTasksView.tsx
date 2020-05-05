import React from 'react';
import { Avatar, List } from 'react-native-paper';
import { UnapprovedTasksOfUserFragment } from '../../../../graphql/types';
import { View } from 'react-native';
import { ISODateStringToLocaleDateString } from '../../../../utils/transformer';

export type UserAssignedTasksProps = { tasks?: UnapprovedTasksOfUserFragment[] }

export default function UserAssignedTasksView({tasks}: UserAssignedTasksProps) {
  if (!tasks || !tasks.length) {
    return (
        <View>
          Keine Aufgaben von dir 🥳
        </View>
    )
  }

  return (
      <View>
        {tasks?.map((task) =>
            <List.Item
                key={task.id}
                title={task.name}
                left={props => <Avatar.Image {...props}
                                             source={require('../../../../../assets/dummy.jpg')}/>} // TODO image source
                description={`Fällig am ${ISODateStringToLocaleDateString(task.periodEnd)}`}
            />
        )}
      </View>
  )
}
