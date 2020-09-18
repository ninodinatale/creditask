import React from 'react';
import { validatePeriodEnd } from '../../../../../utils/validators';
import DatePickerInput from '../../DatePickerInput';
import { CreditaskTextInputProps } from '../../types';

export default function PeriodEndInput(props: CreditaskTextInputProps) {
  return (
      <DatePickerInput
          label={'Spätestens machen am'}
          {...props}
          validateFn={validatePeriodEnd}
      />
  )
}
