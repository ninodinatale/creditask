import React from 'react';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import { DetailTaskDocument, useDetailTaskQuery } from '../../../graphql/types';
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

interface DetailTaskProps {
  route: RouteProp<RootStackParamList, 'detailTask'>,
  navigation: NavigationProp<RootStackParamList, 'detailTask'>,
}

export default function DetailTask({route, navigation}: DetailTaskProps) {
  navigation.setOptions({headerTitle: route.params.taskName});

  const theme = useTheme();

  let {loading, data} = useDetailTaskQuery({
    query: DetailTaskDocument,
    variables: {
      taskId: route.params.taskId
    }
  });

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
