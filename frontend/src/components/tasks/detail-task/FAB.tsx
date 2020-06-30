import * as React from 'react';
import { useState } from 'react';
import { StyleProp, StyleSheet, View, ViewStyle } from 'react-native';
import { FAB, Portal, Theme, useTheme } from 'react-native-paper';
import { DetailTaskFragment, TaskState } from '../../../graphql/types';
import { useAuth } from '../../../hooks/auth/use-auth';
import { IconSource } from 'react-native-paper/lib/typescript/src/components/Icon';

export interface DetailTaskFAB {
  theme: Theme
  task: DetailTaskFragment
}

interface FABAction {
  icon: IconSource;
  label?: string | undefined;
  color?: string | undefined;
  accessibilityLabel?: string | undefined;
  style?: StyleProp<ViewStyle>;
  onPress: () => void;
  testID?: string | undefined;
}

export function DetailTaskFAB(props: DetailTaskFAB) {
  const theme = useTheme();
  const {user} = useAuth();

  const [state, setState] = useState({
    isOpen: false,
    isVisible: true, // TODO
    fabActions: getActions()
  });

  function getActions(): FABAction[] {
    const FABActions: FABAction[] = [];

    const isMyTask = props.task.user?.id === user.id;
    if (isMyTask) {
      switch (props.task.state) {
        case TaskState.ToDo:
          FABActions.push({
            icon: 'check',
            label: 'Auf gemacht setzen',
            onPress: () => console.log('set done')
          });
          break;
        case TaskState.ToApprove:
        case TaskState.Declined:
        case TaskState.Approved:
          FABActions.push({
            icon: 'circle',
            label: 'Auf zu machen setzen',
            onPress: () => console.log('set not done')
          });
          break;
      }
    } else {
      switch (props.task.state) {
        case TaskState.Declined:
        case TaskState.ToApprove:
          // TODO we need approvals first
          FABActions.push({
                icon: 'check',
                label: 'Akzeptieren',
                onPress: () => console.log('set approved')
              },
              {
                icon: 'cross',
                label: 'Ablehnen',
                onPress: () => console.log('set not approved')
              });
          break;
        case TaskState.Approved:
          FABActions.push({
            icon: 'cross',
            label: 'Ablehnen',
            onPress: () => console.log('set not approved')
          });
          break;
      }
    }

    return FABActions
  }

  return (
      <View>
        <Portal>
          <FAB.Group
              open={state.isOpen}
              visible={state.isVisible}
              icon={state.isOpen ? 'calendar-today' : 'plus'}
              actions={state.fabActions}
              onStateChange={() => {
              }}
              onPress={() => {
                if (state.isOpen) {
                  setState({...state, isOpen: false})
                  // do something if the speed dial is isOpen
                } else {
                  setState({...state, isOpen: true})
                }
              }}
          />
        </Portal>
      </View>
  )
}

const styles = StyleSheet.create({
  fab: {
    zIndex: 999999999999,
    position: 'absolute',
    margin: 16,
    right: 0,
    top: 0,
  },
});
