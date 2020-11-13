import 'package:intl/intl.dart';

// TODO get locale from device and format by that
final DateFormat _localDateFormat = DateFormat('dd.MM.yyyy');
final DateFormat _localDateTimeFormat = DateFormat('dd.MM.yyyy hh:mm');
final DateFormat _isoDateFormat = DateFormat('yyyy-MM-dd');

/// Transforms an ISO date string to a local date string based _localDateFormat.
/// For exemaple, for Switzerland, that would be DD.MM.YYYY.
String localDateStringOfIsoDateString(String isoDateString) {
  return _localDateFormat.format(DateTime.parse(isoDateString));
}

/// Transforms a DateTime to an ISO date string based _localDateFormat.
String dateTimeToIsoDateString(DateTime dateTime) {
  return _isoDateFormat.format(dateTime);
}

/// Transforms an ISO date string to a local date time string based
/// _localDateTimeFormat. For exemaple, for Switzerland, that would be
/// DD.MM.YYYY HH:MM
String localDateTimeStringOfIsoDateTimeString(String isoDateTimeString) {
  return _localDateTimeFormat.format(DateTime.parse(isoDateTimeString));
}

/// Transforms DateTime to a local date string based _localDateFormat.
/// For exemaple, for Switzerland, that would be DD.MM.YYYY.
String localDateStringOfDateTime(DateTime dateTime) {
  return _localDateFormat.format(dateTime);
}

/// @param isoDateString to be transformed to:
///        - x days ago
///        - yesterday
///        - today
///        - tomorrow
///        - in x days
///        - ...
String relativeDateStringOf(String isoDateString) {
  final now = floorDay(DateTime.now());
  final sourceDate = DateTime.parse(isoDateString);

  final dayDifference = sourceDate.difference(now).inDays;
  if (dayDifference < -1) {
    return 'vor  ${dayDifference * -1} Tagen';
  }
  if (dayDifference == -1) {
    return 'gestern';
  }
  if (dayDifference == 0) {
    return 'heute';
  }
  if (dayDifference == 1) {
    return 'morgen';
  }
  if (dayDifference == 2) {
    return 'übermorgen';
  }
  if (dayDifference > 2) {
    return 'in $dayDifference Tagen';
  }

  return 'Some error...? 🙈';
}

/// Floors DateTime to the start of the day
DateTime floorDay(DateTime dateTime) {
  return dateTime.subtract(Duration(
      hours: dateTime.hour,
      minutes: dateTime.minute,
      seconds: dateTime.second,
      milliseconds: dateTime.millisecond,
      microseconds: dateTime.microsecond));
}

///
/// @param secondsToTransform
/// @param options
/// @returns Time string in format: "00h 00min 00s"
///
String secondsToElapsedTimeString(int secondsToTransform) {
  if (secondsToTransform == 0) {
    return '0min';
  }

  final duration = Duration(seconds: secondsToTransform);

  final hoursStr = duration.inHours > 0 ? duration.inHours.toString() + 'h ' : '';
  final minutesStr = duration.inMinutes.remainder(60) > 0 ? duration.inMinutes.remainder(60).toString() + 'min ' : '';
  final secondsStr = duration.inSeconds.remainder(60) > 0 ? duration.inSeconds.remainder(60).toString() + 's' : '';

  return '$hoursStr$minutesStr$secondsStr';
}
