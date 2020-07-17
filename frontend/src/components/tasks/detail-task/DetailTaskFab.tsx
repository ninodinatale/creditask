import * as React from 'react';
import { useReducer } from 'react';
import { StyleProp, View, ViewStyle } from 'react-native';
import { FAB, Portal, Theme } from 'react-native-paper';
import {
  ApprovalState,
  DetailTaskDocument,
  DetailTaskFragment,
  DetailTaskQuery,
  DetailTaskQueryVariables,
  TaskState,
  useUpdateApprovalMutation,
  useUpdateTaskMutation
} from '../../../graphql/types';
import { useAuth } from '../../../hooks/auth/use-auth';
import { IconSource } from 'react-native-paper/lib/typescript/src/components/Icon';

export interface DetailTaskFabProps {
  theme: Theme
  task: DetailTaskFragment
}

export interface FABAction {
  icon: IconSource;
  label?: string | undefined;
  color?: string | undefined;
  accessibilityLabel?: string | undefined;
  style?: StyleProp<ViewStyle>;
  onPress: () => void;
  testID?: string | undefined;
}

export function DetailTaskFab(props: DetailTaskFabProps) {
  const {user} = useAuth();
  const [updateTaskMutation] = useUpdateTaskMutation();
  const [updateApprovalMutation] = useUpdateApprovalMutation();
  const [isOpen, isOpenDispatch] = useReducer((prevState: boolean) => !prevState, false);
  const fabActions = getFabActions();

  function updateApprovalState(newState: ApprovalState) {
    updateApprovalMutation({
      variables: {
        approval: {
          taskGroupId: props.task.taskGroup.id,
          state: newState,
          userId: user.id
        }
      },
      optimisticResponse: {
        saveApproval: {
          approval: {
            state: newState
          },
          __typename: 'SaveApproval'
        }, __typename: 'Mutation'
      },
      update: (proxy, fetchResult) => {
        // TODO update lists
        proxy.writeQuery<DetailTaskQuery, DetailTaskQueryVariables>({
          query: DetailTaskDocument,
          data: {
            task: {
              ...props.task,
              approvals: props.task.approvals.map(a => {
                if (a.user.id === user.id) {
                  a.state = (fetchResult.data?.saveApproval?.approval.state || a.state)
                }
                return a
              })
            }
          },
          variables: {
            taskGroupId: props.task.taskGroup.id
          }
        });

      }
    })
    isOpenDispatch()
  }

  function updateTaskState(newState: TaskState) {
    updateTaskMutation({
      variables: {
        task: {
          taskGroupId: props.task.taskGroup.id,
          state: newState
        }
      },
      optimisticResponse: {
        saveTask: {
          task: {
            ...props.task,
            state: newState

          }, __typename: 'SaveTask'
        }, __typename: 'Mutation'
      },
      update: (proxy, fetchResult) => {
        if (fetchResult.data?.saveTask?.task) {
          proxy.writeQuery<DetailTaskQuery, DetailTaskQueryVariables>({
            query: DetailTaskDocument,
            data: {task: {...fetchResult.data.saveTask.task, id: props.task.id},},
            variables: {
              taskGroupId: props.task.taskGroup.id
            }
          })
        }
      }
    })
    isOpenDispatch()
  }

  function getFabActions(): FABAction[] {
    const FABActions: FABAction[] = [];

    const isMyTask = props.task.user?.id === user.id;
    if (isMyTask) {
      switch (props.task.state) {
        case TaskState.ToDo:
          FABActions.push({
            icon: 'check',
            label: 'Auf gemacht setzen',
            onPress: () => updateTaskState(TaskState.ToApprove)
          });
          break;
        case TaskState.ToApprove:
        case TaskState.Declined:
        case TaskState.Approved:
          FABActions.push({
            icon: 'circle',
            label: 'Auf zu machen setzen',
            onPress: () => updateTaskState(TaskState.ToDo)
          });
          break;
      }
    } else {
      switch (props.task.state) {
        case TaskState.Declined:
        case TaskState.ToApprove:
          const myApproval = props.task.approvals.find(a => a.user.id === user.id);

          if (myApproval) {
            switch (myApproval.state) {
              case ApprovalState.None:
                FABActions.push({
                      icon: 'check',
                      label: 'Akzeptieren',
                      onPress: () => updateApprovalState(ApprovalState.Approved)
                    },
                    {
                      icon: 'cross',
                      label: 'Ablehnen',
                      onPress: () => updateApprovalState(ApprovalState.Declined)
                    });
                break;
              case ApprovalState.Approved:
                FABActions.push({
                      icon: 'reset',
                      label: 'Zurücksetzen',
                      onPress: () => updateApprovalState(ApprovalState.None)
                    },
                    {
                      icon: 'cross',
                      label: 'Ablehnen',
                      onPress: () => updateApprovalState(ApprovalState.Declined)
                    });
                break;
              case ApprovalState.Declined:
                FABActions.push({
                      icon: 'check',
                      label: 'Akzeptieren',
                      onPress: () => updateApprovalState(ApprovalState.Approved)
                    },
                    {
                      icon: 'reset',
                      label: 'Zurücksetzen',
                      onPress: () => updateApprovalState(ApprovalState.None)
                    });
                break;
            }
          } else {
            FABActions.push({
                  icon: 'check',
                  label: 'Akzeptieren',
                  onPress: () => updateApprovalState(ApprovalState.Approved)
                },
                {
                  icon: 'cross',
                  label: 'Ablehnen',
                  onPress: () => updateApprovalState(ApprovalState.Declined)
                });
          }
          break;
        case TaskState.Approved:
          FABActions.push({
            icon: 'cross',
            label: 'Ablehnen',
            onPress: () => updateApprovalState(ApprovalState.Declined)
          });
          break;
      }
    }

    return FABActions
  }

  return (
      <FABImplementation
          theme={props.theme}
          isVisible={!!fabActions.length}
          isOpen={isOpen}
          onPress={isOpenDispatch}
          fabActions={fabActions}></FABImplementation>
  )
}

export interface FABImplementationProps {
  theme: Theme
  isVisible: boolean
  fabActions: FABAction[]
  isOpen: boolean
  onPress: () => void
}

function FABImplementation(props: FABImplementationProps) {

  return (
      <View>
        <Portal>
          <FAB.Group
              theme={props.theme}
              fabStyle={{backgroundColor: props.theme.colors.primary}}
              open={props.isOpen}
              visible={props.isVisible}
              icon={'dots-vertical'}
              actions={props.fabActions}
              onStateChange={(state) => {
              }}
              onPress={props.onPress}
          />
        </Portal>
      </View>)
}
