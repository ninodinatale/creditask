import { IconButton, useTheme } from 'react-native-paper';
import React from 'react';
import Tasks from './tasks/Tasks';
import { createStackNavigator, StackNavigationProp } from '@react-navigation/stack';
import AddTask from './tasks/add-task/AddTask';
import DetailTask from './tasks/detail-task/DetailTask';

export type RootStackParamList = {
  tasks: undefined;
  taskAdd: undefined;
  detailTask: { taskGroupId: string, taskName: string };
};

export default function NavigationWrapper() {
  const Stack = createStackNavigator<RootStackParamList>();
  const theme = useTheme();

  function stackScreenOptions({navigation}: { navigation: StackNavigationProp<RootStackParamList> }) {
    return ({
      headerTitle: 'Aufgaben',
      headerRight: () => (
          <IconButton
              icon="plus"
              color={theme.colors.surface}
              onPress={() => navigation.navigate('taskAdd')}
          />
      ),
    })
  }

  return (
      <Stack.Navigator
          screenOptions={{
            headerStyle: {
              backgroundColor: theme.colors.primary
            },
            headerTintColor: theme.colors.surface,
          }}>
        <Stack.Screen name="tasks"
                      component={Tasks}
                      options={stackScreenOptions}
        />
        <Stack.Screen name="taskAdd"
                      component={AddTask}
                      options={{headerTitle: 'Task hinzufügen'}}
        />
        <Stack.Screen name="detailTask"
                      component={DetailTask}
        />
      </Stack.Navigator>
  );
}
