import React from 'react';
import { View } from 'react-native';
import { ActivityIndicator } from 'react-native-paper';

export default function LoadingSpinner() {
  return (
      <View style={{
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'center',
      }}>
        <ActivityIndicator animating={true} size={'large'}/>
      </View>
  )
}
