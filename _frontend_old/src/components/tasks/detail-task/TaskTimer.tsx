import React, { useReducer } from 'react';
import { Text, View } from 'react-native';
import { ActivityIndicator, IconButton, Theme } from 'react-native-paper';
import * as SecureStore from 'expo-secure-store';
import { secondsToElapsedTimeString } from '../../../utils/transformer';

interface TaskTimerProps {
  theme: Theme,
  onTimerStop: (elapsedSeconds: number) => void
  loading: boolean
}

type TimerState = {
  isTimerRunning: boolean,
  passedSeconds: number,
  interval?: NodeJS.Timeout
}

type ReducerAction = {
  type: 'start' | 'stop' | 'increment',
  interval?: NodeJS.Timeout
}

export default function TaskTimer(props: TaskTimerProps) {
  const {theme} = props;

  const initialState: TimerState = {
    isTimerRunning: false,
    passedSeconds: 0,
  };

  function reducer(prevState: TimerState, action: ReducerAction): TimerState {
    switch (action.type) {
      case 'increment':
        return {
          isTimerRunning: true,
          passedSeconds: prevState.passedSeconds + 1,
          interval: prevState.interval
        };
      case 'start':
        return {
          isTimerRunning: true,
          passedSeconds: 0,
          interval: action.interval
        };
      case 'stop':
        return {
          isTimerRunning: false,
          passedSeconds: prevState.passedSeconds,
          interval: prevState.interval
        }
    }
    return prevState
  }

  const [timerState, timerDispatch] = useReducer(reducer, initialState);

  function onTimerPress(): void {
    if (timerState.isTimerRunning) {
      if (timerState.interval) {
        clearInterval(timerState.interval);
      } else {
        console.error('No interval reference found. Time may not stop correctly.')
      }
      timerDispatch({type: 'stop'});
      SecureStore.deleteItemAsync('creditaskTimerSeconds');
      props.onTimerStop(timerState.passedSeconds)
    } else {
      SecureStore.setItemAsync('creditaskTimerSeconds', `${(Date.now() * 1000)}`)
      .then(() => {
        const interval = setInterval(() => timerDispatch({type: 'increment'}), 1000);
        timerDispatch({type: 'start', interval});
      })
    }
  }

  return (
      <View {...props} style={{flex: 0, flexDirection: 'row', alignItems: 'center'}}>
        {timerState.isTimerRunning &&
        <Text {...props}
              style={{color: theme.colors.primary}}>
          {secondsToElapsedTimeString(timerState.passedSeconds)}
        </Text>
        }
        {props.loading ? <ActivityIndicator {...props} animating={true}/> :
            <IconButton
                {...props}
                icon={timerState.isTimerRunning ? 'stop-circle-outline' : 'clock-start'}
                color={timerState.isTimerRunning ? theme.colors.error : theme.colors.primary}
                size={30}
                onPress={onTimerPress}
            />}
      </View>
  )
}
