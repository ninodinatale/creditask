import React from 'react';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import { DetailTaskDocument, useDetailTaskQuery } from '../../../graphql/types';
import { View, Text } from 'react-native';
import { useNavigation, useRoute, RouteProp, NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../../NavigationWrapper';

interface DetailTaskProps {
  route: RouteProp<RootStackParamList, 'detailTask'>,
  navigation: NavigationProp<RootStackParamList, 'detailTask'>,
}

export default function DetailTask({route, navigation}: DetailTaskProps) {
  navigation.setOptions({headerTitle: route.params.taskName});

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
    return (
        <View>
          <Text>{data?.task.name}</Text>
        </View>
    )
  }

  return null;
}
