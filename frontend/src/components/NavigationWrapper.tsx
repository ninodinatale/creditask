import { IconButton, useTheme } from 'react-native-paper';
import React from 'react';
import Tasks from './tasks/Tasks';
import { createStackNavigator, StackNavigationProp } from '@react-navigation/stack';
import AddTask from './tasks/add-task/AddTask';

export default function NavigationWrapper() {
  const Stack = createStackNavigator();
  const theme = useTheme();

  function stackScreenOptions({navigation}: { navigation: StackNavigationProp<any> }) {
    return ({
      headerTitle: 'Aufgaben',
      headerRight: () => (
          <IconButton
              icon="plus"
              color={theme.colors.surface}
              onPress={() => navigation.navigate('add-task')}
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
        <Stack.Screen name="add-task"
                      component={AddTask}
                      options={{headerTitle: 'Task hinzufügen'}}
        />
      </Stack.Navigator>
  );
}
