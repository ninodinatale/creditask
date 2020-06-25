import React, { PropsWithChildren, useState } from 'react';
import { View } from 'react-native';
import { Button, Dialog, IconButton, Portal, Theme } from 'react-native-paper';
import { ValidateFn, ValidationError } from '../../../utils/validators';
import FactorInput from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/FactorInput';
import UserAssignmentInput
  from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/UserAssignmentInput';
import { CreditaskTextInputProps } from '../../_shared/CreditaskInput/types';
import { TaskInputProps } from '../../_shared/CreditaskInput/TaskInput/TaskInput';
import NeededTimeSecondsInput
  from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/NeededTimeSecondsInput';
import { Event } from '@react-native-community/datetimepicker';
import { dateToSeconds, ISODateStringToLocaleDateString } from '../../../utils/transformer';
import { CreditaskDatePickerInputProps } from '../../_shared/CreditaskInput/DatePickerInput';
import PeriodStartInput
  from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/PeriodStartInput';
import PeriodEndInput from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/PeriodEndInput';

interface EditButtonProps {
  theme: Theme
  title: string
  initialValue: string
  onSubmit: (newValue: string) => void
  inputType: keyof TaskInputTypes
  validateFn?: ValidateFn
  hidden?: boolean
}

interface TaskInputTypes {
  factor: React.FunctionComponent<CreditaskTextInputProps>
  neededTimeSeconds: React.FunctionComponent<CreditaskTextInputProps>
  periodStart: React.FunctionComponent<CreditaskDatePickerInputProps>
  periodEnd: React.FunctionComponent<CreditaskDatePickerInputProps>
  userAssignment: React.FunctionComponent<TaskInputProps<'datepicker'>>
}

export default function EditButton(props: PropsWithChildren<EditButtonProps>) {

  const [isOpen, setIsOpen] = useState(false);
  const initialState = {
    value: props.initialValue,
    error: ''
  };
  const [state, setState] = useState(initialState);

  function onDismiss() {
    setIsOpen(false);
    setState(initialState)
  }

  function onSubmit() {
    onDismiss();
    props.onSubmit(state.value)
  }

  function onTextChange(value: string, error: ValidationError): void {
    error = error || props.validateFn?.(value) || '';
    setState({value, error})
  }

  function onTimePickerChange(event: Event, date?: Date): void {
    if (date) {
      setState({value: dateToSeconds(date) + '', error: ''})
    }
  }

  if (props.hidden) {
    return null
  } else {

    return (
        <View {...props} style={{
          flex: 0,
          flexDirection: 'row',
          alignItems: 'center'
        }}>
          <IconButton
              {...props}
              icon={'pencil-outline'}
              color={props.theme.colors.primary}
              size={30}
              onPress={() => setIsOpen(true)}
          />
          <Portal>
            <Dialog
                visible={isOpen}
                onDismiss={onDismiss}>
              <Dialog.Title>Faktor</Dialog.Title>
              <Dialog.Content>
                {props.inputType === 'factor' &&
                <FactorInput value={state.value}
                             errorMsg={state.error}
                             onTextChange={onTextChange}/>
                }
                {props.inputType === 'neededTimeSeconds' &&
                <NeededTimeSecondsInput onTimePickerChange={onTimePickerChange}
                                        value={state.value}
                                        errorMsg={state.error}
                                        onTextChange={onTextChange}/>
                }
                {props.inputType === 'userAssignment' &&
                <UserAssignmentInput value={state.value}
                                     errorMsg={state.error}
                                     onTextChange={onTextChange}/>
                }
                {props.inputType === 'periodStart' &&
                <PeriodStartInput value={ISODateStringToLocaleDateString(state.value)}
                                  errorMsg={state.error}
                                  onTextChange={onTextChange}
                />
                }
                {props.inputType === 'periodEnd' &&
                <PeriodEndInput value={ISODateStringToLocaleDateString(state.value)}
                                errorMsg={state.error}
                                onTextChange={onTextChange}
                />
                }
              </Dialog.Content>
              <Dialog.Actions>
                <Button onPress={onDismiss}>Abbrechen</Button>
                <Button onPress={onSubmit} disabled={!!state.error}>Speichern</Button>
              </Dialog.Actions>
            </Dialog>
          </Portal>
        </View>
    )
  }
}
