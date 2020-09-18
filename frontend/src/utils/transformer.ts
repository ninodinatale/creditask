import moment from 'moment';
import { ApprovalState, TaskState } from '../graphql/types';
import { Colors, Theme } from 'react-native-paper';

/**
 * Transforms date string `YYYY-MM-DD` to `DD.MM.YYYY`
 * @param dateString date in format of `YYYY-MM-DD` to be transformed to `DD.MM.YYYY`
 */
export function ISODateStringToLocaleDateString(dateString: string): string {
  return moment(dateString, 'YYYY-MM-DD').format('DD.MM.YYYY')
}

export function localeDateStringToDate(dateString: string): Date {
  return moment(dateString, 'DD.MM.YYYY').toDate()
}

export function localeDateStringToISOString(dateString: string): string {
  return moment(dateString, 'DD.MM.YYYY').format('YYYY-MM-DD')
}

export function dateToLocaleDateString(date: Date): string {
  return moment(date).format('DD.MM.YYYY')
}

export function dateToISODateString(date: Date): string {
  return moment(date).format('YYYY-MM-DD')
}

export function ISODateStringToMoment(dateString: string): moment.Moment {
  return moment(dateString, 'YYYY-MM-DD');
}

export function ISODateTimeStringToLocaleDateTimeTuple(dateTimeString: string): [string, string] {
  const mDate = moment(dateTimeString);
  return [mDate.format('DD.MM.YYYY'), mDate.format('HH:MM')]
}

export function getTaskStateIconProps(taskState: TaskState, theme: Theme): { icon: string, color?: string } {
  switch (taskState) {
    case TaskState.ToDo:
      return {icon: 'checkbox-blank-circle-outline', color: theme.colors.onSurface};
    case TaskState.ToApprove:
      return {icon: 'progress-check', color: Colors.green900};
    case TaskState.Approved:
      return {icon: 'check-circle-outline', color: Colors.green900};
    case TaskState.Declined:
      return {icon: 'close-circle-outline', color: Colors.red900};
    default:
      return {icon: 'help-circle-outline', color: theme.colors.onSurface};
  }
}

export function getApprovalStateIconProps(approvalState: ApprovalState, theme: Theme): { icon: string, color?: string } {
  switch (approvalState) {
    case ApprovalState.None:
      return {icon: 'checkbox-blank-circle-outline', color: theme.colors.onSurface};
    case ApprovalState.Approved:
      return {icon: 'check-circle-outline', color: Colors.green900};
    case ApprovalState.Declined:
      return {icon: 'close-circle-outline', color: Colors.red900};
    default:
      return {icon: 'help-circle-outline', color: theme.colors.onSurface};
  }
}

export function transformTaskState(taskState: TaskState): string {
  switch (taskState) {
    case TaskState.ToDo:
      return 'Noch zu machen';
    case TaskState.ToApprove:
      return 'Gemacht, zu bestätigen';
    case TaskState.Approved:
      return 'Gemacht und bestätigt';
    case TaskState.Declined:
      return 'Gemacht und abgelehnt';
    default:
      return 'Unbekannter Status';
  }
}

export function transformApprovalState(approvalState: ApprovalState | string): string {
  switch (approvalState) {
    case ApprovalState.None:
      return 'zu bestätigen';
    case ApprovalState.Approved:
      return 'bestätigt';
    case ApprovalState.Declined:
      return 'abgelehnt';
    default:
      return 'Unbekannter Status';
  }
}

/**
 * @param isoDateString to be transformed to:
 *        - x days ago
 *        - yesterday
 *        - today
 *        - tomorrow
 *        - in x days
 *        - ...
 */
export function relativeDateString(isoDateString: string): string {
  const now = moment(Date.now()).format('YYYY-MM-DD');
  const date = ISODateStringToMoment(isoDateString);

  const dayDifference = date.diff(now, 'days');
  if (dayDifference < -1) {
    return 'vor ' + dayDifference * -1 + ' Tagen'
  }
  if (dayDifference === -1) {
    return 'gestern';
  }
  if (dayDifference === 0) {
    return 'heute';
  }
  if (dayDifference === 1) {
    return 'morgen';
  }
  if (dayDifference === 2) {
    return 'übermorgen';
  }
  if (dayDifference > 2) {
    return 'in ' + dayDifference + ' Tagen'
  }

  return 'Some error...? 🙈'
}

export function dateToElapsedTimeString(date: Date, options?: { ceilMinutes: boolean }): string {
  const mDate = moment(date);
  const seconds = ((mDate.hours() * 3600) + (mDate.minutes() * 60) + mDate.seconds());
  return secondsToElapsedTimeString(seconds, options)
}

export function secondsToDate(seconds: string | number): Date {
  return new Date((+seconds * 1000) - 3600000);
}

export function dateToSeconds(date: Date, options?: { ceilMinutes: boolean }): number {
  const mDate = moment(date);
  if (options?.ceilMinutes) {
    ceilMinutes(mDate)
  }
  return  ((mDate.hours() * 3600) + (mDate.minutes() * 60));
}

/**
 * @param secondsToTransform
 * @param options
 * @returns Time string in format: "00h 00min 00s"
 */
export function secondsToElapsedTimeString(secondsToTransform: number, options?: { ceilMinutes: boolean }): string {
  if (secondsToTransform === 0) {
    return '0min'
  }

  const timeMoment = moment(0).utc();
  timeMoment.add(secondsToTransform, 'seconds');
  if (options?.ceilMinutes) {
    ceilMinutes(timeMoment)
  }

  const hours = timeMoment.hours();
  const minutes = timeMoment.minutes();
  const seconds = timeMoment.seconds();

  function valueStr(value: number, label: string): string {
    return value > 0 ? value + label + ' ' : '';
  }

  return valueStr(hours, 'h') + valueStr(minutes, 'min') + valueStr(seconds, 's');
}

function ceilMinutes(moment: moment.Moment): void {
    moment.add(1, 'minutes');
    moment.subtract(0);
}
