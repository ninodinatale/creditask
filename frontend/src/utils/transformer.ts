import moment from 'moment';

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
