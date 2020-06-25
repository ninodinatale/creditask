import React from 'react';
import { View } from 'react-native';
import { validateNeededTimeSeconds } from '../../../../../utils/validators';
import TaskInput from '../TaskInput';
import { CreditaskTimePickerInputProps } from '../../types'

export default function NeededTimeSecondsInput(props: CreditaskTimePickerInputProps) {

  return (
      <View>
        <TaskInput
            {...props}
            inputType={'timepicker'}
            selectedValue={undefined}
            choices={undefined}
            value={props.value}
            errorMsg={props.errorMsg}
            validateFn={validateNeededTimeSeconds}
            onTextChange={props.onTextChange}
            onTimePickerChange={props.onTimePickerChange}
            label={'Benötigte Zeit'}
        />
      </View>
  )
}
