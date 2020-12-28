import 'package:creditask/graphql/api.dart';
import 'package:flutter/foundation.dart';

String transformApprovalState(String approvalStateString) {
  ApprovalState approvalState = ApprovalState.values
      .firstWhere((e) => describeEnum(e) == approvalStateString);
  switch (approvalState) {
    case ApprovalState.none:
      return 'zu bestätigen';
    case ApprovalState.approved:
      return 'bestätigt';
    case ApprovalState.declined:
      return 'abgelehnt';
    default:
      return 'Unbekannter Status';
  }
}

String transformTaskState(TaskState taskState) {
  switch (taskState) {
    case TaskState.done:
      return 'Gemacht';
    case TaskState.toDo:
      return 'Noch zu machen';
    case TaskState.toApprove:
      return 'Gemacht, zu bestätigen';
    case TaskState.approved:
      return 'Gemacht und bestätigt';
    case TaskState.declined:
      return 'Gemacht und abgelehnt';
    default:
      return 'Unbekannter Status';
  }
}
