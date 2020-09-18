import * as React from 'react';
import {
  TaskInputCreate,
  TodoTasksOfUserDocument,
  TodoTasksOfUserQuery,
  TodoTasksOfUserQueryVariables,
  useSaveTaskMutation
} from '../../../graphql/types';
import {
  dateToLocaleDateString,
  localeDateStringToDate,
  localeDateStringToISOString
} from '../../../utils/transformer';
import { Formik, FormikErrors, FormikHelpers, FormikProps } from 'formik';
import { View } from 'react-native';
import { Button } from 'react-native-paper';
import moment from 'moment';
import { StackNavigationProp } from '@react-navigation/stack';
import { RootStackParamList } from '../../NavigationWrapper';
import UserAssignmentInput, { NO_USER_ASSIGNMENT } from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/UserAssignmentInput';
import FactorInput from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/FactorInput';
import NameInput from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/NameInput';
import PeriodStartInput
  from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/PeriodStartInput';
import PeriodEndInput from '../../_shared/CreditaskInput/TaskInput/SpecificInputs/PeriodEndInput';
import { KeyboardScrollView } from '../../_shared/KeyboardScrollView';
import { validatePeriods } from '../../../utils/validators';
import { useAuth } from '../../../hooks/auth/use-auth';

interface AddTaskProps {
  navigation: StackNavigationProp<RootStackParamList, 'taskAdd'>
}

export default function AddTask(props: AddTaskProps) {
  const [mutate] = useSaveTaskMutation();
  const auth = useAuth();

  const initialValues: AddTaskValues = {
    name: '',
    assignedUserId: NO_USER_ASSIGNMENT,
    factor: '1',
    periodStart: dateToLocaleDateString(new Date()),
    periodEnd: dateToLocaleDateString(new Date()),
  };

  function validate(values: AddTaskValues): FormikErrors<AddTaskValues> {
    const errors: FormikErrors<AddTaskValues> = {};

    const periodStartDate = moment(localeDateStringToDate(values.periodStart));
    const periodEndDate = moment(localeDateStringToDate(values.periodEnd));
    const error = validatePeriods(periodStartDate, periodEndDate) || undefined;

    if (error) {
      errors.periodStart = error;
      errors.periodEnd = error;
    }
    return errors;
  }

  function onSubmit(values: AddTaskValues, formikHelpers: FormikHelpers<AddTaskValues>) {
    formikHelpers.setSubmitting(true);

    const createInput: TaskInputCreate = {
      name: values.name,
      factor: +values.factor,
      userId: values.assignedUserId == NO_USER_ASSIGNMENT ? null : values.assignedUserId,
      periodStart: localeDateStringToISOString(values.periodStart),
      periodEnd: localeDateStringToISOString(values.periodEnd)
    };

    mutate({
      variables: {
        updateInput: null,
        createInput
      },
      update: (proxy, fetchResult) => {
        // TODO add update logic to other lists
        if (values.assignedUserId === auth.user.id) {
          const addedTask = fetchResult.data?.saveTask?.task;
          if (addedTask) {
            const query = proxy.readQuery<TodoTasksOfUserQuery, TodoTasksOfUserQueryVariables>({
              query: TodoTasksOfUserDocument,
              variables: {
                email: auth.user.email
              }
            });

            if (query?.todoTasksOfUser) {
              proxy.writeQuery<TodoTasksOfUserQuery, TodoTasksOfUserQueryVariables>({
                query: TodoTasksOfUserDocument,
                data: {todoTasksOfUser: query.todoTasksOfUser.concat(addedTask)},
                variables: {
                  email: auth.user.email
                }
              })
            }
          }
        }
      }

    })
    .then(_ => {
      formikHelpers.resetForm();
      props.navigation.goBack()
    })
  }

  function handleChangeForFormik(formik: FormikProps<AddTaskValues>, input: keyof AddTaskValues, value: string, error: string): void {
    formik.handleChange(input)(value);
    formik.errors[input] = error
  }

  return (
      <Formik
          initialValues={initialValues}
          onSubmit={onSubmit}
          validate={validate}
          validateOnChange={false}
          validateOnBlur={true}
      >
        {formik => (
            <KeyboardScrollView>
              <View style={{
                flex: 1,
                marginTop: 20,
                marginLeft: 50,
                marginRight: 50,
              }}>
                <NameInput {...props}
                           value={formik.values.name}
                           errorMsg={formik.errors.name || ''}
                           onTextChange={(newValue, error) => handleChangeForFormik(formik, 'name', newValue, error)}
                           onBlur={formik.handleBlur('name')}
                />
                <UserAssignmentInput {...props} value={formik.values.assignedUserId}
                                     errorMsg={formik.errors.assignedUserId || ''}
                                     onTextChange={(newValue, error) => handleChangeForFormik(formik, 'assignedUserId', newValue, error)}
                />
                <FactorInput {...props}
                             value={formik.values.factor}
                             errorMsg={formik.errors.factor || ''}
                             onTextChange={(newValue, error) => handleChangeForFormik(formik, 'factor', newValue, error)}
                             onBlur={formik.handleBlur('factor')}
                />
                <PeriodStartInput value={formik.values.periodStart}
                                  errorMsg={formik.errors.periodStart || ''}
                                  onTextChange={(newValue, error) => handleChangeForFormik(formik, 'periodStart', newValue, error)}
                                  onBlur={formik.handleBlur('periodStart')}
                />
                <PeriodEndInput value={formik.values.periodEnd}
                                errorMsg={formik.errors.periodEnd || ''}
                                onTextChange={(newValue, error) => handleChangeForFormik(formik, 'periodEnd', newValue, error)}
                                onBlur={formik.handleBlur('periodEnd')}
                />
                <Button
                    mode="contained"
                    onPress={() => formik.handleSubmit()}
                    style={{
                      marginTop: 20,
                      marginBottom: 20
                    }}
                    loading={formik.isSubmitting}
                    disabled={formik.isSubmitting}
                >
                  Hinzufügen
                </Button>
              </View>
            </KeyboardScrollView>
        )}
      </Formik>
  )
}

export interface AddTaskValues {
  name: string
  assignedUserId: string
  factor: string
  periodStart: string
  periodEnd: string
}
