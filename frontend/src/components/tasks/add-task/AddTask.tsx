import * as React from 'react';
import { useApolloClient } from '@apollo/react-hooks';
import {
  SaveTaskDocument,
  SaveTaskMutationVariables,
  TaskInputCreate,
  UnapprovedTasksOfUserFragment,
  useOtherUsersQuery
} from '../../../graphql/graphql';
import { useAuth } from '../../../hooks/auth/use-auth';
import LoadingSpinner from '../../_shared/LoadingSpinner';
import PickerInput, { PickerChoices } from '../../_shared/PickerInput';
import {
  dateToLocaleDateString,
  localeDateStringToDate,
  localeDateStringToISOString
} from '../../../utils/transformer';
import { Formik, FormikErrors, FormikHelpers } from 'formik';
import { KeyboardAvoidingView, ScrollView, StyleSheet, View } from 'react-native';
import { Button, HelperText, TextInput } from 'react-native-paper';
import RNDateTimePicker from '@react-native-community/datetimepicker';
import moment from 'moment';
import { StackNavigationProp } from '@react-navigation/stack';

interface AddTaskProps {
  navigation: StackNavigationProp<any>
}

export default function AddTask(props: AddTaskProps) {
  const apolloClient = useApolloClient();
  const auth = useAuth();
  const {loading, error, data} = useOtherUsersQuery({
    variables: {
      userEmail: auth.user.email
    }
  });

  // used to set that no user should be assigned to this task, since `null` or `''` renders the
  // input as "empty", although the label is rendered
  const NO_USER_ASSIGNMENT = '__NO_USER_ASSIGNMENT__';

  const initialValues: AddTaskValues & DatePickerState = {
    name: '',
    assignedUser: NO_USER_ASSIGNMENT,
    factor: '1',
    periodStart: dateToLocaleDateString(new Date()),
    periodEnd: dateToLocaleDateString(new Date()),
    showPeriodStartDatePicker: false,
    showPeriodEndDatePicker: false
  };

  function validate(values: AddTaskValues): FormikErrors<AddTaskValues> {
    const errors: FormikErrors<AddTaskValues> = {};

    if (!values.name) {
      errors.name = 'Name darf nicht leer sein'
    } else if (values.name.length < 3) {
      errors.name = 'Name muss länger als 3 Zeichen sein'
    } else if (values.name.length > 30) {
      errors.name = 'Name darf länger als 30 Zeichen sein'
    }

    if (!values.factor) {
      errors.factor = 'Faktor darf nicht leer sein'
    } else if (isNaN(Number(values.factor))) {
      errors.factor = 'Faktor muss eine Zahl sein'
    }

    if (!values.periodStart) {
      errors.periodStart = 'Startdatum darf nicht leer sein'
    }

    if (!values.periodEnd) {
      errors.periodEnd = 'Enddatum darf nicht leer sein'
    } else {
      const periodStart = moment(localeDateStringToDate(values.periodStart));
      const periodEnd = moment(localeDateStringToDate(values.periodEnd));

      if (periodEnd.isBefore(periodStart)) {
        errors.periodEnd = 'Enddatum darf nicht vor Startdatum sein'
      }
    }

    return errors;
  }

  function onSubmit(values: AddTaskValues, formikHelpers: FormikHelpers<AddTaskValues>) {
    formikHelpers.setSubmitting(true);

    const createInput: TaskInputCreate = {
      name: values.name,
      factor: +values.factor,
      userId: values.assignedUser == NO_USER_ASSIGNMENT ? null : values.assignedUser,
      periodStart: localeDateStringToISOString(values.periodStart),
      periodEnd: localeDateStringToISOString(values.periodEnd)
    };

    apolloClient.mutate<UnapprovedTasksOfUserFragment, SaveTaskMutationVariables>({
      mutation: SaveTaskDocument,
      variables: {
        updateInput: null,
        createInput
      }
    })
    .then(_ => {
      formikHelpers.resetForm();
      props.navigation.goBack()
    })
  }

  if (data && !loading) {
    const assignUserChoices: PickerChoices = [
      {
        label: 'Keine Zuweisung',
        value: NO_USER_ASSIGNMENT
      }
    ];

    const otherUsersChoices: PickerChoices = data.otherUsers?.map(u => ({
      label: u.publicName,
      value: u.email
    })) || [];

    assignUserChoices.push(...otherUsersChoices);

    return (
        <Formik
            initialValues={initialValues}
            onSubmit={onSubmit}
            validate={validate}
            validateOnChange={false}
            validateOnBlur={true}
        >
          {formik => (
              <KeyboardAvoidingView
                  behavior={'padding'}
              >
                <ScrollView>
                  <View style={styles.inputContainer}>
                    <TextInput
                        label='Name'
                        value={formik.values.name}
                        onChangeText={formik.handleChange('name')}
                        onBlur={formik.handleBlur('name')}
                        error={!!formik.errors.name}
                        style={styles.afterInput}
                    />
                    <HelperText type="error"
                                visible={!!formik.errors.name}>{formik.errors.name}</HelperText>
                    <PickerInput
                        value={formik.values.assignedUser}
                        onBlur={formik.handleBlur('assignedUser')}

                        selectedValue={formik.values.assignedUser}
                        onValueChange={formik.handleChange('assignedUser')}
                        choices={assignUserChoices}
                        style={styles.afterHelperText}
                    />
                    <TextInput
                        label='Faktor'
                        value={formik.values.factor}
                        onChangeText={formik.handleChange('factor')}
                        onBlur={formik.handleBlur('factor')}
                        error={!!formik.errors.factor}
                        style={styles.afterInput}
                        keyboardType={'numeric'}
                    />
                    <HelperText type="error"
                                visible={!!formik.errors.factor}>{formik.errors.factor}</HelperText>
                    <TextInput
                        label='Frühestens machen am'
                        value={formik.values.periodStart}
                        onFocus={() => {
                          formik.setFieldValue('showPeriodStartDatePicker', true, false);
                        }}
                        onBlur={(event: any) => {
                          formik.setFieldValue('showPeriodStartDatePicker', false, false);
                          formik.handleBlur('periodStart')
                        }}
                        style={styles.afterHelperText}
                        error={!!formik.errors.periodStart}
                        caretHidden={true}
                    />
                    {formik.values.showPeriodStartDatePicker &&
                    <RNDateTimePicker
                        value={localeDateStringToDate(formik.values.periodStart)}
                        onChange={(event, date) => {
                          if (date) {
                            formik.setFieldValue('showPeriodStartDatePicker', false, false);
                            formik.setFieldValue('periodStart', dateToLocaleDateString(date))
                          }
                        }}
                        minimumDate={new Date()}
                    />}
                    <HelperText type="error"
                                visible={!!formik.errors.periodStart}>{formik.errors.periodStart}</HelperText>
                    <TextInput
                        label='Spätetens machen am'
                        value={formik.values.periodEnd}
                        onFocus={() => formik.setFieldValue('showPeriodEndDatePicker', true, false)}
                        onBlur={(event: any) => {
                          formik.setFieldValue('showPeriodEndDatePicker', false, false);
                          formik.handleBlur('periodEnd')
                        }}
                        style={styles.afterHelperText}
                        error={!!formik.errors.periodEnd}
                        caretHidden={true}
                    />
                    {formik.values.showPeriodEndDatePicker &&
                    <RNDateTimePicker
                        value={localeDateStringToDate(formik.values.periodEnd)}
                        onChange={(event, date) => {
                          if (date) {
                            formik.setFieldValue('showPeriodEndDatePicker', false, false);
                            formik.setFieldValue('periodEnd', dateToLocaleDateString(date));
                          }
                        }}
                        minimumDate={new Date()}
                    />}
                    <HelperText type="error"
                                visible={!!formik.errors.periodEnd}>{formik.errors.periodEnd}</HelperText>

                    <Button
                        mode="contained"
                        onPress={formik.handleSubmit}
                        style={styles.submitButton}
                        loading={formik.isSubmitting}
                        disabled={formik.isSubmitting}
                    >
                      Hinzufügen
                    </Button>
                  </View>
                </ScrollView>
              </KeyboardAvoidingView>
          )}
        </Formik>
    )
  } else {
    return <LoadingSpinner/>
  }
}

export interface AddTaskValues {
  name: string
  assignedUser: string
  factor: string
  periodStart: string
  periodEnd: string
}

export interface DatePickerState {
  showPeriodStartDatePicker?: boolean
  showPeriodEndDatePicker?: boolean
}

export interface InputState<T> {
  value: T
  error: InputError,
}

export interface InputError {
  isError: boolean,
  reason: string
}

const styles = StyleSheet.create({
  inputContainer: {
    flex: 1,
    marginLeft: 50,
    marginRight: 50,
  },
  afterInput: {
    marginTop: 30,
  },
  afterHelperText: {
    marginTop: 10,
  },
  submitButton: {
    marginTop: 20,
    marginBottom: 20
  }
});
