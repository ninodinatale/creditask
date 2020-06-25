import React from 'react';
import { View } from 'react-native';
import { validateFactor } from '../../../../../utils/validators';
import TaskInput from '../TaskInput';
import { CreditaskTextInputProps } from '../../types'

export default function FactorInput(props: CreditaskTextInputProps) {

  return (
      <View>
        <TaskInput
            {...props}
            inputType={'text'}
            selectedValue={undefined}
            choices={undefined}
            value={props.value}
            errorMsg={props.errorMsg}
            validateFn={validateFactor}
            onTextChange={props.onTextChange}
            onTimePickerChange={undefined}
            label={'Faktor'}
            keyboardType={'numeric'}
        />
      </View>
  )
}
