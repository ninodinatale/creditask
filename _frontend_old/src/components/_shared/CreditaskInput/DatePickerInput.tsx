import React, { useState } from 'react';
import { Keyboard, NativeSyntheticEvent, TextInputFocusEventData, View } from 'react-native';
import { ValidateFn } from '../../../utils/validators';
import TaskInput from './TaskInput/TaskInput';
import {
  dateToISODateString,
  dateToLocaleDateString,
  localeDateStringToDate
} from '../../../utils/transformer';
import RNDateTimePicker from '@react-native-community/datetimepicker';
import { CreditaskTextInputProps } from './types';

export interface CreditaskDatePickerInputProps extends CreditaskTextInputProps {
  validateFn: ValidateFn
}

export default function DatePickerInput(props: CreditaskDatePickerInputProps) {
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [displayedValue, setDisplayedValue] = useState(props.value);

  function onFocus(e: NativeSyntheticEvent<TextInputFocusEventData>) {
    setShowDatePicker(true);
    props.onFocus?.(e)
  }

  function onBlur(e: NativeSyntheticEvent<TextInputFocusEventData>) {
    setShowDatePicker(false);
    props.onBlur?.(e)
  }

  return (
      <View>
        <TaskInput
            {...props}
            inputType={'text'}
            selectedValue={undefined}
            choices={undefined}
            value={displayedValue}
            errorMsg={props.errorMsg}
            onTextChange={props.onTextChange}
            onFocus={onFocus}
            onBlur={onBlur}
            onTimePickerChange={undefined}
            caretHidden={true}
        />
        {showDatePicker &&
        <RNDateTimePicker
            value={localeDateStringToDate(props.value)}
            onChange={(event, date) => {
              Keyboard.dismiss();
              if (date) {
                setShowDatePicker(false);

                const isoDateString = dateToISODateString(date);
                setDisplayedValue(dateToLocaleDateString(date));

                props.onTextChange(isoDateString, props.validateFn(isoDateString))
              }
            }}
            minimumDate={new Date()}
        />
        }
      </View>
  )
}
