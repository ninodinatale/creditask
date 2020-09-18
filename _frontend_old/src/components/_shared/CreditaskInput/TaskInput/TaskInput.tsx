import { HelperText, Text, TextInput, useTheme } from 'react-native-paper';
import React, { useState } from 'react';
import { Picker, View } from 'react-native';
import { ValidateFn, ValidationError } from '../../../../utils/validators';
import { PickerChoices } from '../../PickerInput';
import { OnTextChangeFn, PaperTextInputProps } from '../types';
import DateTimePicker, { Event } from '@react-native-community/datetimepicker';
import moment from 'moment';
import { secondsToDate, secondsToElapsedTimeString } from '../../../../utils/transformer';

type InputTypes = 'text' | 'datepicker' | 'timepicker'

export interface TaskInputProps<T extends InputTypes> extends PaperTextInputProps {
  inputType: T
  selectedValue: T extends 'datepicker' ? string : undefined
  choices: T extends 'datepicker' ? PickerChoices : undefined
  value: string
  errorMsg: ValidationError
  validateFn?: ValidateFn
  onTextChange: OnTextChangeFn
  onTimePickerChange: T extends 'timepicker' ? (event: Event, date?: Date) => void : undefined
}

export default function TaskInput<T extends InputTypes>(props: TaskInputProps<T>) {

  const theme = useTheme();

  const [showTimePicker, setShowTimePicker] = useState(false);

  function onTextChange(newValue: string): void {
    const error = props.validateFn?.(newValue) || '';
    props.onTextChange(newValue, error)
  }

  function onPickerValueChange(itemValue: string, itemPosition: number): void {
    props.onTextChange(itemValue, '')
  }

  function onTimePickerChange(event: Event, date?: Date): void {
    setShowTimePicker(false);
    props.onTimePickerChange?.(event, date);
  }

  function getRenderedElement(): JSX.Element | undefined {

    if (props.inputType === 'datepicker') {
      return (
          <Picker
              selectedValue={props.selectedValue}
              onValueChange={onPickerValueChange}
              ref={props.ref}
              style={props.style}
          >
            {props.choices?.map((choice, i) =>
                <Picker.Item
                    key={i}
                    {...choice}
                />)}
          </Picker>
      )
    } else if (props.inputType === 'timepicker') {
      return <Text {...props} onPress={() => setShowTimePicker(true)} style={{
        paddingTop: 17,
        paddingLeft: 15
      }}>{secondsToElapsedTimeString(+props.value)}</Text>
    }
  }

  return (
      <View>
        <TextInput
            {...props}
            mode={'outlined'}
            value={props.value}
            onChangeText={onTextChange}
            error={!!props.errorMsg}
            render={props.inputType === 'text' ? undefined : getRenderedElement}
        />
        <HelperText type="error"
                    visible={!!props.errorMsg}>{props.errorMsg}</HelperText>

        {showTimePicker &&
        <DateTimePicker
            value={secondsToDate(props.value)}
            mode={'time'}
            is24Hour={true}
            onChange={onTimePickerChange}
            display={'spinner'}
        />}
      </View>
  )
}
