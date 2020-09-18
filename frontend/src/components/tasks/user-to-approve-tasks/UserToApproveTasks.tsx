import React, { useState } from 'react';
import { useAuth } from '../../../hooks/auth/use-auth';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import {
  ApprovalState,
  ApprovalType,
  ToApproveTasksOfUserQueryVariables,
  UserType,
  useToApproveTasksOfUserQuery
} from '../../../graphql/types';
import { useNavigation } from '@react-navigation/native';
import { RootStackParamList } from '../../NavigationWrapper';
import { StackNavigationProp } from '@react-navigation/stack/lib/typescript/src/types';
import { RefreshControl, ScrollView, View } from 'react-native';
import { Avatar, List, Text, TouchableRipple, useTheme } from 'react-native-paper';
import { getApprovalStateIconProps } from '../../../utils/transformer';

function ApprovalsList(props: {
  approvals: Array<(
      { __typename?: 'ApprovalType' }
      & Pick<ApprovalType, 'state'>
      & {
    user: (
        { __typename?: 'UserType' }
        & Pick<UserType, 'id' | 'publicName'>
        )
  }
      )>
}) {
  const theme = useTheme()
  return <View {...props}>
    {props.approvals.map(approval => <View>
        <List.Icon icon="check"/>
        <Text {...props}
            key={approval.user.id}
            // left={props =>
            //     <List.Icon {...props} {...getApprovalStateIconProps(approval.state, theme)}/>}
        >{approval.user.publicName}</Text>
    </View>)}
  </View>
}
export default function UserToApproveTasks(props: any) {

  const {user} = useAuth();
  const theme = useTheme();
  const [refreshing, setRefreshing] = useState(false);
  const navigation = useNavigation<StackNavigationProp<RootStackParamList>>();

  const queryVariables: ToApproveTasksOfUserQueryVariables = {email: user.email};


  const {loading, data, refetch} = useToApproveTasksOfUserQuery({
    variables: queryVariables
  });

  function navigateToTaskDetail(taskGroupId: string, taskName: string): void {
    navigation.navigate('detailTask', {
      taskGroupId,
      taskName
    })
  }

  function onRefresh() {
    setRefreshing(true);
    refetch(queryVariables).then(() => setRefreshing(false))
  }

  if (loading) {
    return <LoadingSpinner/>
  }

  if (data) {
    if (!data.toApproveTasksOfUser || !data.toApproveTasksOfUser.length) {
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
                  fontSize: 20,
                  color: theme.colors.backdrop
                }}
            >Keine Aufgaben zu akzeptieren 🥳</Text>
          </View>
      )
    }

    return (
        <RefreshControl colors={[theme.colors.primary]} onRefresh={onRefresh}
                        refreshing={refreshing}>
          <ScrollView>
            {data.toApproveTasksOfUser.map(task =>
                <TouchableRipple
                    onPress={() => navigateToTaskDetail(task.taskGroup.id, task.name)}
                    key={task.id}
                >
                  <List.Item
                      key={task.id}
                      title={task.name}
                      left={props => <Avatar.Image {...props}
                                                   source={require('../../../../assets/dummy.jpg')}/>} // TODO image source
                      right={props => {
                        const ownApproval = task.approvals.find(a => a.user.id == user.id)
                        if (ownApproval && ownApproval.state !== ApprovalState.None) {
                          return <List.Icon {...props} {...getApprovalStateIconProps(ownApproval.state, theme)}/>
                        }
                      }}
                      description={props => <ApprovalsList {...props} approvals={task.approvals}/>}
                  />
                </TouchableRipple>
            )}
          </ScrollView>
        </RefreshControl>
    )
  }

  return null
}

