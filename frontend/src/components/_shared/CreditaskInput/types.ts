import { ValidationError } from '../../../utils/validators';
import { TextInputProps } from 'react-native-paper/lib/typescript/src/components/TextInput/TextInput';
import { Event } from '@react-native-community/datetimepicker'

export type PaperTextInputProps = Omit<TextInputProps, 'theme'>
export type OnTextChangeFn = (newValue: string, error: ValidationError) => void

export interface CreditaskTextInputProps extends PaperTextInputProps {
  value: string
  errorMsg: string
  onTextChange: OnTextChangeFn
}

export interface CreditaskTimePickerInputProps extends CreditaskTextInputProps {
  onTimePickerChange: (event: Event, date?: Date) => void
}
