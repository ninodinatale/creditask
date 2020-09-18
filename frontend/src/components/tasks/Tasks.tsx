import * as React from 'react';
import { useState } from 'react';
import { BottomNavigation, Button, Text } from 'react-native-paper';
import UserTodoTasks from './user-todo-tasks/UserTodoTasks';
import UserToApproveTasks from './user-to-approve-tasks/UserToApproveTasks';
import { View } from 'react-native';
import { useNavigation, useTheme } from '@react-navigation/native';
import { useAuth } from '../../hooks/auth/use-auth';

const AlbumsRoute = () => <Text>Albums</Text>;

const RecentsRoute = () => <Text>Recents</Text>;

function ToDelete() {
  const theme = useTheme()
  const auth = useAuth()
  const nav = useNavigation()


  return (
      <View>
        <Button theme={theme} onPress={() => {
          auth.logout()
          // nav.navigate('/')
        }}>
          Logout
        </Button>
      </View>
  );
}

export default function Tasks() {
  const [navigationIndex, setNavigationIndex] = useState(0);
  const routes = [
    {key: 'UserTodoTasks', title: 'Meine Tasks', icon: 'calendar-check'},
    {key: 'UserToApproveTasks', title: 'Zu akzeptieren', icon: 'progress-check'},
    {key: 'ToDelete', title: 'ToDelete', icon: ''}
  ];

  const handleIndexChange = (index: number) => setNavigationIndex(index);

  const renderScene = BottomNavigation.SceneMap({
    UserTodoTasks,
    UserToApproveTasks,
    ToDelete
  });

  return (
      <BottomNavigation
          navigationState={{index: navigationIndex, routes}}
          onIndexChange={handleIndexChange}
          renderScene={renderScene}
      />
  );
}

