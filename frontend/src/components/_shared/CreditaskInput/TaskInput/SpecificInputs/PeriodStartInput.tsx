import React from 'react';
import { validatePeriodStart } from '../../../../../utils/validators';
import DatePickerInput from '../../DatePickerInput';
import { CreditaskTextInputProps } from '../../types';

export default function PeriodStartInput(props: CreditaskTextInputProps) {
  return (
      <DatePickerInput
          label={'Frühestens machen am'}
          {...props}
          validateFn={validatePeriodStart}
      />
  )
}
