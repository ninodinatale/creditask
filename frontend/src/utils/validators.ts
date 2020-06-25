import moment from 'moment';
import { TaskInputUpdate, TaskState } from '../graphql/types';

export type ValidationError = string
export type ValidateFn = (value: string) => ValidationError

export function validateTaskName(name: string): ValidationError {
  if (!name) {
    return 'Name darf nicht leer sein'
  } else if (name.length < 3) {
    return 'Name muss länger als 3 Zeichen sein'
  } else if (name.length > 30) {
    return 'Name darf länger als 30 Zeichen sein'
  }
  return ''
}

export function validateFactor(factor: string): ValidationError {
  if (!factor) {
    return 'Faktor darf nicht leer sein'
  } else if (isNaN(Number(factor))) {
    return 'Faktor muss eine Zahl sein'
  } else if (Number(factor) <= 0) {
    return 'Faktor muss über 0 sein'
  }
  return ''
}

export function validateNeededTimeSeconds(factor: string): ValidationError {
  if (!factor) {
    return 'Faktor darf nicht leer sein'
  } else if (isNaN(Number(factor))) {
    return 'Faktor muss eine Zahl sein'
  } else if (Number(factor) <= 0) {
    return 'Faktor muss über 0 sein'
  }
  return ''
}

export function validatePeriodStart(periodStart: string): ValidationError {
  if (!periodStart) {
    return 'Startdatum darf nicht leer sein'
  }
  return ''
}

export function validatePeriodEnd(periodEnd: string): ValidationError {
  if (!periodEnd) {
    return 'Enddatum darf nicht leer sein'
  }
  return ''
}

export function validatePeriods(periodStart: moment.Moment, periodEnd: moment.Moment): ValidationError {
  if (periodEnd.isBefore(periodStart)) {
    return 'Enddatum darf nicht vor Startdatum sein'
  }
  return ''

}

export function canEditTaskProperty(property: keyof TaskInputUpdate, taskState: TaskState): boolean {
  switch (taskState) {
    case TaskState.ToDo:
      return true;
    case TaskState.ToApprove:
      return property === 'name';
    case TaskState.Declined:
      return property === 'name' || property === 'neededTimeSeconds' || property === 'factor';
    case TaskState.UnderConditions:
      return false;
    case TaskState.Approved:
      return false;
    default:
      return false
  }
}
