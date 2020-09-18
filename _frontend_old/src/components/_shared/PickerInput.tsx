import React from 'react';
import { Picker as NativePicker, StyleSheet, TextInputProps } from 'react-native';
import { TextInput, } from 'react-native-paper';

/**
 * Wrapper for native datepicker in order to use with react natiive paper
 * @param props
 */
export default function PickerInput(props: PickerProps & TextInputProps & { ref?: (input: any) => void }) {
  const nativePickerProps = {
    selectedValue: props.selectedValue,
    onValueChange: props.onValueChange
  };

  return (
      <TextInput
          label="Zuweisung"
          ref={props.ref}
          value={props.selectedValue}
          style={props.style}
          render={() => (
              <NativePicker
                  {...nativePickerProps}
                  style={style.picker}
                  ref={props.ref}
              >
                {props.choices.map((choice, i) =>
                    <NativePicker.Item
                        key={i}
                        {...choice}
                    />)}
              </NativePicker>
          )}
      />
  )
}

export interface PickerProps {
  style: any
  selectedValue: string
  onValueChange: (value: string, itemIndex: number) => void
  choices: PickerChoices
}

export type PickerChoices = {
  label: string
  value: string
}[]

const style = StyleSheet.create({
  picker: {
    height: 54, marginTop: 10, marginLeft: 4
  }
});
