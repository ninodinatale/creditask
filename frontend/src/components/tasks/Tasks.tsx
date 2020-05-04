import * as React from 'react';
import { useState } from 'react';
import { BottomNavigation, Text } from 'react-native-paper';
import UserAssignedTasks from './user-assigned-tasks/UserAssignedTasks';

const AlbumsRoute = () => <Text>Albums</Text>;

const RecentsRoute = () => <Text>Recents</Text>;

export default function Tasks() {
  const [navigationIndex, setNavigationIndex] = useState(0);
  const routes = [
    {key: 'UserAssignedTasks', title: 'Meine Tasks', icon: 'music'},
    {key: 'albums', title: 'Albums', icon: 'album'},
    {key: 'recents', title: 'Recents', icon: 'history'},
  ];

  const handleIndexChange = (index: number) => setNavigationIndex(index);

  const renderScene = BottomNavigation.SceneMap({
    UserAssignedTasks,
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
