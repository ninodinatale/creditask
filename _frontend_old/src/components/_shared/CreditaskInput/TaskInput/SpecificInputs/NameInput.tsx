import React from 'react';
import { View } from 'react-native';
import { validateFactor, validateTaskName, ValidationError } from '../../../../../utils/validators';
import TaskInput from '../TaskInput';
import { TextInputProps } from 'react-native-paper/lib/typescript/src/components/TextInput/TextInput';
import { CreditaskTextInputProps } from '../../types';

export default function NameInput(props: CreditaskTextInputProps) {

  return (
      <View>
        <TaskInput
            {...props}
            inputType={'text'}
            selectedValue={undefined}
            choices={undefined}
            value={props.value}
            errorMsg={props.errorMsg}
            validateFn={validateTaskName}
            onTextChange={props.onTextChange}
            label={'Name'}
            onTimePickerChange={undefined}
        />
      </View>
  )
}
