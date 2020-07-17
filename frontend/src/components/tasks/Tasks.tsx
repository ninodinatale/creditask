import * as React from 'react';
import { useState } from 'react';
import { BottomNavigation, Text } from 'react-native-paper';
import UserTodoTasks from './user-todo-tasks/UserTodoTasks';

const AlbumsRoute = () => <Text>Albums</Text>;

const RecentsRoute = () => <Text>Recents</Text>;

export default function Tasks() {
  const [navigationIndex, setNavigationIndex] = useState(0);
  const routes = [
    {key: 'UserTodoTasks', title: 'Meine Tasks', icon: 'calendar-check'},
    {key: 'albums', title: 'Albums', icon: 'album'},
    {key: 'recents', title: 'Recents', icon: 'history'},
  ];

  const handleIndexChange = (index: number) => setNavigationIndex(index);

  const renderScene = BottomNavigation.SceneMap({
    UserTodoTasks,
    albums: AlbumsRoute,
    recents: RecentsRoute,
  });

  return (
      <BottomNavigation
          navigationState={{index: navigationIndex, routes}}
          onIndexChange={handleIndexChange}
          renderScene={renderScene}
      />
  );
}
