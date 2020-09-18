import React from 'react';
import { View } from 'react-native';
import { validateFactor } from '../../../../../utils/validators';
import TaskInput from '../TaskInput';
import { PickerChoices } from '../../../PickerInput';
import { useAuth } from '../../../../../hooks/auth/use-auth';
import { useUsersQuery } from '../../../../../graphql/types';
import { CreditaskTextInputProps } from '../../types';

// used to set that no user should be assigned to this task, since `null` or `''` renders the
// input as "empty", although the label is rendered
export const NO_USER_ASSIGNMENT = '__NO_USER_ASSIGNMENT__';

export default function UserAssignmentInput(props: CreditaskTextInputProps) {

  const auth = useAuth();
  const {loading, data} = useUsersQuery({
    variables: {
      userEmail: auth.user.email
    }
  });

  const assignUserChoices: PickerChoices = [
    {
      label: 'Keine Zuweisung',
      value: NO_USER_ASSIGNMENT
    },
    {
      label: 'Mir',
      value: '' + auth.user.id
    },
  ];

  if (data && !loading) {

    const otherUsersChoices: PickerChoices = data.users
    ?.filter(u => {
      return u.id != auth.user.id
    })
    .map(u => ({
      label: u.publicName,
      value: u.id
    })) || [];

    assignUserChoices.push(...otherUsersChoices);
  } else {
    assignUserChoices.push({value: '', label: 'Benutzer werden geladen...'})
  }

  return (
      <View>
        <TaskInput
            {...props}
            inputType={'datepicker'}
            choices={assignUserChoices}
            value={props.value}
            selectedValue={props.value}
            errorMsg={props.errorMsg}
            validateFn={validateFactor}
            onTextChange={props.onTextChange}
            label={'Zuweisung'}
            onTimePickerChange={undefined}
        />
      </View>
  )
}
