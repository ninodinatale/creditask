import moment from 'moment';
import { TaskState } from '../graphql/types';
import { Theme, Colors } from 'react-native-paper';

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

export function ISODateStringToMoment(dateString: string): moment.Moment {
  return moment(dateString, 'YYYY-MM-DD');
}

export function getTaskStateIconProps(taskState: TaskState, theme: Theme): { icon: string, color?: string } {
  switch (taskState) {
    case TaskState.ToDo:
      return {icon: 'checkbox-blank-circle-outline', color: theme.colors.onSurface};
    case TaskState.ToApprove:
      return {icon: 'progress-check', color: Colors.green900};
    case TaskState.Approved:
      return {icon: 'check-circle-outline', color: Colors.green900};
    case TaskState.UnderConditions:
      return {icon: 'check-circle-outline', color: Colors.yellow800};
    case TaskState.Declined:
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
    case TaskState.UnderConditions:
      return 'Gemacht und unter Bedingungen bestätigt';
    case TaskState.Declined:
      return 'Gemacht und abgelehnt';
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
  const now = moment();
  const date = moment(isoDateString, 'YYYY-MM-DD');

  const dayDifference = date.diff(now, 'days');
  if (dayDifference < -1) {
    return 'vor ' + dayDifference * -1 + ' Tagen'
  }
  if (dayDifference === -1) {
    return 'gestern';
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
    timeMoment.add(1, 'minutes');
    timeMoment.subtract(0);
  }

  const hours = timeMoment.hours();
  const minutes = timeMoment.minutes();
  const seconds = timeMoment.seconds();

  function valueStr(value: number, label: string): string {
    return value > 0 ? value + label + ' ' : '';
  }

  return valueStr(hours, 'h') + valueStr(minutes, 'min') + valueStr(seconds, 's');
}

// type InputFormatType = 'seconds' | 'minutes' | 'hours' | 'HH:MM'
// type OutputFormatType = 'HHh MMmin' | 'HH:MM' | 'seconds' | 'object'

// export function transform<InputFormat extends InputFormatType, OutputFormat extends OutputFormatType>(value: number | string, inputFormat: InputFormat, options: {
//   outputFormat: OutputFormat,
//   ceilMinutes?: boolean
// }): OutputFormat extends 'object' ? { hours: string, minutes: string, seconds: string } : OutputFormat extends 'seconds' ? number : string {
//   let multiplier = 0;
//   switch (inputFormat) {
//     case 'seconds': {
//       multiplier = 1000;
//       break;
//     }
//     case 'minutes': {
//       multiplier = 60000;
//       break;
//     }
//     case 'hours': {
//       multiplier = 3600000;
//       break;
//     }
//     case 'HH:MM': {
//       if (typeof value !== 'string') {
//         throw Error('inputFormat was defined "HH:MM", but value was not of type string.');
//       }
//       if (options) {
//         console.error('The `options` parameter has been defined, but with `inputFormat` = "HH:MM", the `options` have no effect.')
//       }
//
//       const [hours, minutes] = [...value.split(':')];
//
//       let seconds = Number(hours) * 60 * 60;
//       seconds += Number(minutes) * 60;
//
//       if (options?.outputFormat === 'seconds') {
//         return seconds;
//       }
//     }
//   }
//
//   const rawtime: Date = new Date(Number(value) * multiplier);
//
//   if (options && options.ceilMinutes) {
//     rawtime.setSeconds(0);
//     rawtime.setMinutes(rawtime.getMinutes() + 1);
//   }
//
//   // format: 00:00:00
//   const rawTimeStr = rawtime.toISOString().substr(11, 8);
//   const hoursStr = rawTimeStr.substr(0, 2);
//   const minutesStr = rawTimeStr.substr(3, 2);
//   const secondsStr = rawTimeStr.substr(6, 2);
//
//   // format: 00h 00min 00s
//   if (options?.outputFormat === 'HHh MMmin') {
//     let returnStr = '';
//     const hours = Number(hoursStr);
//     const minutes = Number(minutesStr);
//     const seconds = Number(secondsStr);
//
//     if (hours > 0) {
//       returnStr += `${hours}h `;
//     }
//     if (minutes > 0) {
//       returnStr += `${minutes}min `;
//     }
//     if (seconds > 0) {
//       returnStr += `${seconds}s`;
//     }
//
//     return returnStr.length > 0 ? returnStr : '0s';
//
//     // format: 00:00
//   } else if (options && options.outputFormat === 'HH:MM') {
//     return `${hoursStr}:${minutesStr}}`;
//
//     // format: {hours, minutes, seconds}
//   } else if (options && options.outputFormat === 'object') {
//     return {hours: hoursStr, minutes: minutesStr, seconds: secondsStr};
//   } else {
//     throw new Error('TimePipe could not retrieve output format.');
//   }
// }
