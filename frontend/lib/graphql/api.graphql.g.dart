// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateApproval$Mutation$SaveApproval$Approval
    _$UpdateApproval$Mutation$SaveApproval$ApprovalFromJson(
        Map<String, dynamic> json) {
  return UpdateApproval$Mutation$SaveApproval$Approval()
    ..id = json['id'] as String
    ..state = _$enumDecodeNullable(_$ApprovalStateEnumMap, json['state'],
        unknownValue: ApprovalState.artemisUnknown);
}

Map<String, dynamic> _$UpdateApproval$Mutation$SaveApproval$ApprovalToJson(
        UpdateApproval$Mutation$SaveApproval$Approval instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': _$ApprovalStateEnumMap[instance.state],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ApprovalStateEnumMap = {
  ApprovalState.none: 'NONE',
  ApprovalState.approved: 'APPROVED',
  ApprovalState.declined: 'DECLINED',
  ApprovalState.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

UpdateApproval$Mutation$SaveApproval
    _$UpdateApproval$Mutation$SaveApprovalFromJson(Map<String, dynamic> json) {
  return UpdateApproval$Mutation$SaveApproval()
    ..approval = json['approval'] == null
        ? null
        : UpdateApproval$Mutation$SaveApproval$Approval.fromJson(
            json['approval'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UpdateApproval$Mutation$SaveApprovalToJson(
        UpdateApproval$Mutation$SaveApproval instance) =>
    <String, dynamic>{
      'approval': instance.approval?.toJson(),
    };

UpdateApproval$Mutation _$UpdateApproval$MutationFromJson(
    Map<String, dynamic> json) {
  return UpdateApproval$Mutation()
    ..saveApproval = json['saveApproval'] == null
        ? null
        : UpdateApproval$Mutation$SaveApproval.fromJson(
            json['saveApproval'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UpdateApproval$MutationToJson(
        UpdateApproval$Mutation instance) =>
    <String, dynamic>{
      'saveApproval': instance.saveApproval?.toJson(),
    };

ApprovalInput _$ApprovalInputFromJson(Map<String, dynamic> json) {
  return ApprovalInput(
    id: json['id'] as String,
    state: _$enumDecodeNullable(_$ApprovalStateEnumMap, json['state'],
        unknownValue: ApprovalState.artemisUnknown),
  );
}

Map<String, dynamic> _$ApprovalInputToJson(ApprovalInput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': _$ApprovalStateEnumMap[instance.state],
    };

UsersTodoTasks$Query$TodoTasksOfUser
    _$UsersTodoTasks$Query$TodoTasksOfUserFromJson(Map<String, dynamic> json) {
  return UsersTodoTasks$Query$TodoTasksOfUser()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..periodEnd = json['periodEnd'] as String
    ..state = _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown)
    ..user = json['user'] == null
        ? null
        : SimpleTaskMixin$User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UsersTodoTasks$Query$TodoTasksOfUserToJson(
        UsersTodoTasks$Query$TodoTasksOfUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'periodEnd': instance.periodEnd,
      'state': _$TaskStateEnumMap[instance.state],
      'user': instance.user?.toJson(),
    };

const _$TaskStateEnumMap = {
  TaskState.toDo: 'TO_DO',
  TaskState.toApprove: 'TO_APPROVE',
  TaskState.declined: 'DECLINED',
  TaskState.approved: 'APPROVED',
  TaskState.done: 'DONE',
  TaskState.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

UsersTodoTasks$Query _$UsersTodoTasks$QueryFromJson(Map<String, dynamic> json) {
  return UsersTodoTasks$Query()
    ..todoTasksOfUser = (json['todoTasksOfUser'] as List)
        ?.map((e) => e == null
            ? null
            : UsersTodoTasks$Query$TodoTasksOfUser.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UsersTodoTasks$QueryToJson(
        UsersTodoTasks$Query instance) =>
    <String, dynamic>{
      'todoTasksOfUser':
          instance.todoTasksOfUser?.map((e) => e?.toJson())?.toList(),
    };

SimpleTaskMixin$User _$SimpleTaskMixin$UserFromJson(Map<String, dynamic> json) {
  return SimpleTaskMixin$User()..publicName = json['publicName'] as String;
}

Map<String, dynamic> _$SimpleTaskMixin$UserToJson(
        SimpleTaskMixin$User instance) =>
    <String, dynamic>{
      'publicName': instance.publicName,
    };

ToApproveTasksOfUser$Query$ToApproveTasksOfUser
    _$ToApproveTasksOfUser$Query$ToApproveTasksOfUserFromJson(
        Map<String, dynamic> json) {
  return ToApproveTasksOfUser$Query$ToApproveTasksOfUser()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..periodEnd = json['periodEnd'] as String
    ..state = _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown)
    ..user = json['user'] == null
        ? null
        : SimpleTaskMixin$User.fromJson(json['user'] as Map<String, dynamic>)
    ..$$typename = json['__typename'] as String
    ..approvals = (json['approvals'] as List)
        ?.map((e) => e == null
            ? null
            : TaskWithApprovalsMixin$Approvals.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ToApproveTasksOfUser$Query$ToApproveTasksOfUserToJson(
        ToApproveTasksOfUser$Query$ToApproveTasksOfUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'periodEnd': instance.periodEnd,
      'state': _$TaskStateEnumMap[instance.state],
      'user': instance.user?.toJson(),
      '__typename': instance.$$typename,
      'approvals': instance.approvals?.map((e) => e?.toJson())?.toList(),
    };

ToApproveTasksOfUser$Query _$ToApproveTasksOfUser$QueryFromJson(
    Map<String, dynamic> json) {
  return ToApproveTasksOfUser$Query()
    ..toApproveTasksOfUser = (json['toApproveTasksOfUser'] as List)
        ?.map((e) => e == null
            ? null
            : ToApproveTasksOfUser$Query$ToApproveTasksOfUser.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ToApproveTasksOfUser$QueryToJson(
        ToApproveTasksOfUser$Query instance) =>
    <String, dynamic>{
      'toApproveTasksOfUser':
          instance.toApproveTasksOfUser?.map((e) => e?.toJson())?.toList(),
    };

TaskWithApprovalsMixin$Approvals _$TaskWithApprovalsMixin$ApprovalsFromJson(
    Map<String, dynamic> json) {
  return TaskWithApprovalsMixin$Approvals()
    ..id = json['id'] as String
    ..user = json['user'] == null
        ? null
        : SimpleApprovalMixin$User.fromJson(
            json['user'] as Map<String, dynamic>)
    ..state = _$enumDecodeNullable(_$ApprovalStateEnumMap, json['state'],
        unknownValue: ApprovalState.artemisUnknown);
}

Map<String, dynamic> _$TaskWithApprovalsMixin$ApprovalsToJson(
        TaskWithApprovalsMixin$Approvals instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'state': _$ApprovalStateEnumMap[instance.state],
    };

SimpleApprovalMixin$User _$SimpleApprovalMixin$UserFromJson(
    Map<String, dynamic> json) {
  return SimpleApprovalMixin$User()
    ..id = json['id'] as String
    ..publicName = json['publicName'] as String;
}

Map<String, dynamic> _$SimpleApprovalMixin$UserToJson(
        SimpleApprovalMixin$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicName': instance.publicName,
    };

TokenAuth$Mutation$TokenAuth$User _$TokenAuth$Mutation$TokenAuth$UserFromJson(
    Map<String, dynamic> json) {
  return TokenAuth$Mutation$TokenAuth$User()
    ..id = json['id'] as String
    ..publicName = json['publicName'] as String
    ..email = json['email'] as String;
}

Map<String, dynamic> _$TokenAuth$Mutation$TokenAuth$UserToJson(
        TokenAuth$Mutation$TokenAuth$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicName': instance.publicName,
      'email': instance.email,
    };

TokenAuth$Mutation$TokenAuth _$TokenAuth$Mutation$TokenAuthFromJson(
    Map<String, dynamic> json) {
  return TokenAuth$Mutation$TokenAuth()
    ..token = json['token'] as String
    ..user = json['user'] == null
        ? null
        : TokenAuth$Mutation$TokenAuth$User.fromJson(
            json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TokenAuth$Mutation$TokenAuthToJson(
        TokenAuth$Mutation$TokenAuth instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user?.toJson(),
    };

TokenAuth$Mutation _$TokenAuth$MutationFromJson(Map<String, dynamic> json) {
  return TokenAuth$Mutation()
    ..tokenAuth = json['tokenAuth'] == null
        ? null
        : TokenAuth$Mutation$TokenAuth.fromJson(
            json['tokenAuth'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TokenAuth$MutationToJson(TokenAuth$Mutation instance) =>
    <String, dynamic>{
      'tokenAuth': instance.tokenAuth?.toJson(),
    };

UpdateDetailTask$Mutation$SaveTask$Task
    _$UpdateDetailTask$Mutation$SaveTask$TaskFromJson(
        Map<String, dynamic> json) {
  return UpdateDetailTask$Mutation$SaveTask$Task()
    ..$$typename = json['__typename'] as String
    ..id = json['id'] as String
    ..creditsCalc = _$enumDecodeNullable(
        _$CreditsCalcEnumMap, json['creditsCalc'],
        unknownValue: CreditsCalc.artemisUnknown)
    ..fixedCredits = json['fixedCredits'] as int
    ..factor = (json['factor'] as num)?.toDouble()
    ..name = json['name'] as String
    ..neededTimeSeconds = json['neededTimeSeconds'] as int
    ..periodStart = json['periodStart'] as String
    ..periodEnd = json['periodEnd'] as String
    ..state = _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown)
    ..user = json['user'] == null
        ? null
        : DetailTaskMixin$User.fromJson(json['user'] as Map<String, dynamic>)
    ..approvals = (json['approvals'] as List)
        ?.map((e) => e == null
            ? null
            : DetailTaskMixin$Approvals.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UpdateDetailTask$Mutation$SaveTask$TaskToJson(
        UpdateDetailTask$Mutation$SaveTask$Task instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'creditsCalc': _$CreditsCalcEnumMap[instance.creditsCalc],
      'fixedCredits': instance.fixedCredits,
      'factor': instance.factor,
      'name': instance.name,
      'neededTimeSeconds': instance.neededTimeSeconds,
      'periodStart': instance.periodStart,
      'periodEnd': instance.periodEnd,
      'state': _$TaskStateEnumMap[instance.state],
      'user': instance.user?.toJson(),
      'approvals': instance.approvals?.map((e) => e?.toJson())?.toList(),
    };

const _$CreditsCalcEnumMap = {
  CreditsCalc.byFactor: 'BY_FACTOR',
  CreditsCalc.fixed: 'FIXED',
  CreditsCalc.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

UpdateDetailTask$Mutation$SaveTask _$UpdateDetailTask$Mutation$SaveTaskFromJson(
    Map<String, dynamic> json) {
  return UpdateDetailTask$Mutation$SaveTask()
    ..task = json['task'] == null
        ? null
        : UpdateDetailTask$Mutation$SaveTask$Task.fromJson(
            json['task'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UpdateDetailTask$Mutation$SaveTaskToJson(
        UpdateDetailTask$Mutation$SaveTask instance) =>
    <String, dynamic>{
      'task': instance.task?.toJson(),
    };

UpdateDetailTask$Mutation _$UpdateDetailTask$MutationFromJson(
    Map<String, dynamic> json) {
  return UpdateDetailTask$Mutation()
    ..saveTask = json['saveTask'] == null
        ? null
        : UpdateDetailTask$Mutation$SaveTask.fromJson(
            json['saveTask'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UpdateDetailTask$MutationToJson(
        UpdateDetailTask$Mutation instance) =>
    <String, dynamic>{
      'saveTask': instance.saveTask?.toJson(),
    };

DetailTaskMixin$User _$DetailTaskMixin$UserFromJson(Map<String, dynamic> json) {
  return DetailTaskMixin$User()
    ..id = json['id'] as String
    ..publicName = json['publicName'] as String;
}

Map<String, dynamic> _$DetailTaskMixin$UserToJson(
        DetailTaskMixin$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicName': instance.publicName,
    };

DetailTaskMixin$Approvals _$DetailTaskMixin$ApprovalsFromJson(
    Map<String, dynamic> json) {
  return DetailTaskMixin$Approvals()
    ..id = json['id'] as String
    ..user = json['user'] == null
        ? null
        : SimpleApprovalMixin$User.fromJson(
            json['user'] as Map<String, dynamic>)
    ..state = _$enumDecodeNullable(_$ApprovalStateEnumMap, json['state'],
        unknownValue: ApprovalState.artemisUnknown);
}

Map<String, dynamic> _$DetailTaskMixin$ApprovalsToJson(
        DetailTaskMixin$Approvals instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'state': _$ApprovalStateEnumMap[instance.state],
    };

TaskInputCreate _$TaskInputCreateFromJson(Map<String, dynamic> json) {
  return TaskInputCreate(
    name: json['name'] as String,
    creditsCalc: _$enumDecodeNullable(_$CreditsCalcEnumMap, json['creditsCalc'],
        unknownValue: CreditsCalc.artemisUnknown),
    fixedCredits: (json['fixedCredits'] as num)?.toDouble(),
    factor: (json['factor'] as num)?.toDouble(),
    userId: json['userId'] as String,
    periodStart: json['periodStart'] as String,
    periodEnd: json['periodEnd'] as String,
  );
}

Map<String, dynamic> _$TaskInputCreateToJson(TaskInputCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'creditsCalc': _$CreditsCalcEnumMap[instance.creditsCalc],
      'fixedCredits': instance.fixedCredits,
      'factor': instance.factor,
      'userId': instance.userId,
      'periodStart': instance.periodStart,
      'periodEnd': instance.periodEnd,
    };

TaskInputUpdate _$TaskInputUpdateFromJson(Map<String, dynamic> json) {
  return TaskInputUpdate(
    id: json['id'] as String,
    state: _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown),
    name: json['name'] as String,
    creditsCalc: _$enumDecodeNullable(_$CreditsCalcEnumMap, json['creditsCalc'],
        unknownValue: CreditsCalc.artemisUnknown),
    fixedCredits: (json['fixedCredits'] as num)?.toDouble(),
    factor: (json['factor'] as num)?.toDouble(),
    userId: json['userId'] as String,
    neededTimeSeconds: json['neededTimeSeconds'] as int,
    periodStart: json['periodStart'] as String,
    periodEnd: json['periodEnd'] as String,
  );
}

Map<String, dynamic> _$TaskInputUpdateToJson(TaskInputUpdate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': _$TaskStateEnumMap[instance.state],
      'name': instance.name,
      'creditsCalc': _$CreditsCalcEnumMap[instance.creditsCalc],
      'fixedCredits': instance.fixedCredits,
      'factor': instance.factor,
      'userId': instance.userId,
      'neededTimeSeconds': instance.neededTimeSeconds,
      'periodStart': instance.periodStart,
      'periodEnd': instance.periodEnd,
    };

TaskDetail$Query$Task _$TaskDetail$Query$TaskFromJson(
    Map<String, dynamic> json) {
  return TaskDetail$Query$Task()
    ..$$typename = json['__typename'] as String
    ..id = json['id'] as String
    ..creditsCalc = _$enumDecodeNullable(
        _$CreditsCalcEnumMap, json['creditsCalc'],
        unknownValue: CreditsCalc.artemisUnknown)
    ..fixedCredits = json['fixedCredits'] as int
    ..factor = (json['factor'] as num)?.toDouble()
    ..name = json['name'] as String
    ..neededTimeSeconds = json['neededTimeSeconds'] as int
    ..periodStart = json['periodStart'] as String
    ..periodEnd = json['periodEnd'] as String
    ..state = _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown)
    ..user = json['user'] == null
        ? null
        : DetailTaskMixin$User.fromJson(json['user'] as Map<String, dynamic>)
    ..approvals = (json['approvals'] as List)
        ?.map((e) => e == null
            ? null
            : DetailTaskMixin$Approvals.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TaskDetail$Query$TaskToJson(
        TaskDetail$Query$Task instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'creditsCalc': _$CreditsCalcEnumMap[instance.creditsCalc],
      'fixedCredits': instance.fixedCredits,
      'factor': instance.factor,
      'name': instance.name,
      'neededTimeSeconds': instance.neededTimeSeconds,
      'periodStart': instance.periodStart,
      'periodEnd': instance.periodEnd,
      'state': _$TaskStateEnumMap[instance.state],
      'user': instance.user?.toJson(),
      'approvals': instance.approvals?.map((e) => e?.toJson())?.toList(),
    };

TaskDetail$Query _$TaskDetail$QueryFromJson(Map<String, dynamic> json) {
  return TaskDetail$Query()
    ..task = json['task'] == null
        ? null
        : TaskDetail$Query$Task.fromJson(json['task'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TaskDetail$QueryToJson(TaskDetail$Query instance) =>
    <String, dynamic>{
      'task': instance.task?.toJson(),
    };

Credits$Query$Users _$Credits$Query$UsersFromJson(Map<String, dynamic> json) {
  return Credits$Query$Users()
    ..id = json['id'] as String
    ..publicName = json['publicName'] as String
    ..credits = json['credits'] as int;
}

Map<String, dynamic> _$Credits$Query$UsersToJson(
        Credits$Query$Users instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicName': instance.publicName,
      'credits': instance.credits,
    };

Credits$Query _$Credits$QueryFromJson(Map<String, dynamic> json) {
  return Credits$Query()
    ..users = (json['users'] as List)
        ?.map((e) => e == null
            ? null
            : Credits$Query$Users.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$Credits$QueryToJson(Credits$Query instance) =>
    <String, dynamic>{
      'users': instance.users?.map((e) => e?.toJson())?.toList(),
    };

TaskChanges$Query$Task$TaskChanges _$TaskChanges$Query$Task$TaskChangesFromJson(
    Map<String, dynamic> json) {
  return TaskChanges$Query$Task$TaskChanges()
    ..changedProperty = _$enumDecodeNullable(
        _$TaskChangeChangedPropertyEnumMap, json['changedProperty'],
        unknownValue: TaskChangeChangedProperty.artemisUnknown)
    ..currentValue = json['currentValue'] as String
    ..previousValue = json['previousValue'] as String
    ..timestamp = json['timestamp'] as String
    ..user = json['user'] == null
        ? null
        : TaskChangesMixin$User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TaskChanges$Query$Task$TaskChangesToJson(
        TaskChanges$Query$Task$TaskChanges instance) =>
    <String, dynamic>{
      'changedProperty':
          _$TaskChangeChangedPropertyEnumMap[instance.changedProperty],
      'currentValue': instance.currentValue,
      'previousValue': instance.previousValue,
      'timestamp': instance.timestamp,
      'user': instance.user?.toJson(),
    };

const _$TaskChangeChangedPropertyEnumMap = {
  TaskChangeChangedProperty.name: 'NAME',
  TaskChangeChangedProperty.neededTimeSeconds: 'NEEDED_TIME_SECONDS',
  TaskChangeChangedProperty.state: 'STATE',
  TaskChangeChangedProperty.creditsCalc: 'CREDITS_CALC',
  TaskChangeChangedProperty.fixedCredits: 'FIXED_CREDITS',
  TaskChangeChangedProperty.factor: 'FACTOR',
  TaskChangeChangedProperty.userId: 'USER_ID',
  TaskChangeChangedProperty.periodStart: 'PERIOD_START',
  TaskChangeChangedProperty.periodEnd: 'PERIOD_END',
  TaskChangeChangedProperty.approval: 'APPROVAL',
  TaskChangeChangedProperty.createdById: 'CREATED_BY_ID',
  TaskChangeChangedProperty.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

TaskChanges$Query$Task _$TaskChanges$Query$TaskFromJson(
    Map<String, dynamic> json) {
  return TaskChanges$Query$Task()
    ..taskChanges = (json['taskChanges'] as List)
        ?.map((e) => e == null
            ? null
            : TaskChanges$Query$Task$TaskChanges.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TaskChanges$Query$TaskToJson(
        TaskChanges$Query$Task instance) =>
    <String, dynamic>{
      'taskChanges': instance.taskChanges?.map((e) => e?.toJson())?.toList(),
    };

TaskChanges$Query _$TaskChanges$QueryFromJson(Map<String, dynamic> json) {
  return TaskChanges$Query()
    ..task = json['task'] == null
        ? null
        : TaskChanges$Query$Task.fromJson(json['task'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TaskChanges$QueryToJson(TaskChanges$Query instance) =>
    <String, dynamic>{
      'task': instance.task?.toJson(),
    };

TaskChangesMixin$User _$TaskChangesMixin$UserFromJson(
    Map<String, dynamic> json) {
  return TaskChangesMixin$User()
    ..id = json['id'] as String
    ..publicName = json['publicName'] as String;
}

Map<String, dynamic> _$TaskChangesMixin$UserToJson(
        TaskChangesMixin$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicName': instance.publicName,
    };

UsersDoneToApproveTasks$Query$DoneTasksOfUser
    _$UsersDoneToApproveTasks$Query$DoneTasksOfUserFromJson(
        Map<String, dynamic> json) {
  return UsersDoneToApproveTasks$Query$DoneTasksOfUser()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..periodEnd = json['periodEnd'] as String
    ..state = _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown)
    ..user = json['user'] == null
        ? null
        : SimpleTaskMixin$User.fromJson(json['user'] as Map<String, dynamic>)
    ..$$typename = json['__typename'] as String
    ..approvals = (json['approvals'] as List)
        ?.map((e) => e == null
            ? null
            : TaskWithApprovalsMixin$Approvals.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UsersDoneToApproveTasks$Query$DoneTasksOfUserToJson(
        UsersDoneToApproveTasks$Query$DoneTasksOfUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'periodEnd': instance.periodEnd,
      'state': _$TaskStateEnumMap[instance.state],
      'user': instance.user?.toJson(),
      '__typename': instance.$$typename,
      'approvals': instance.approvals?.map((e) => e?.toJson())?.toList(),
    };

UsersDoneToApproveTasks$Query _$UsersDoneToApproveTasks$QueryFromJson(
    Map<String, dynamic> json) {
  return UsersDoneToApproveTasks$Query()
    ..doneTasksOfUser = (json['doneTasksOfUser'] as List)
        ?.map((e) => e == null
            ? null
            : UsersDoneToApproveTasks$Query$DoneTasksOfUser.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UsersDoneToApproveTasks$QueryToJson(
        UsersDoneToApproveTasks$Query instance) =>
    <String, dynamic>{
      'doneTasksOfUser':
          instance.doneTasksOfUser?.map((e) => e?.toJson())?.toList(),
    };

VerifyToken$Mutation$VerifyToken$User
    _$VerifyToken$Mutation$VerifyToken$UserFromJson(Map<String, dynamic> json) {
  return VerifyToken$Mutation$VerifyToken$User()
    ..id = json['id'] as String
    ..publicName = json['publicName'] as String
    ..email = json['email'] as String;
}

Map<String, dynamic> _$VerifyToken$Mutation$VerifyToken$UserToJson(
        VerifyToken$Mutation$VerifyToken$User instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicName': instance.publicName,
      'email': instance.email,
    };

VerifyToken$Mutation$VerifyToken _$VerifyToken$Mutation$VerifyTokenFromJson(
    Map<String, dynamic> json) {
  return VerifyToken$Mutation$VerifyToken()
    ..user = json['user'] == null
        ? null
        : VerifyToken$Mutation$VerifyToken$User.fromJson(
            json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$VerifyToken$Mutation$VerifyTokenToJson(
        VerifyToken$Mutation$VerifyToken instance) =>
    <String, dynamic>{
      'user': instance.user?.toJson(),
    };

VerifyToken$Mutation _$VerifyToken$MutationFromJson(Map<String, dynamic> json) {
  return VerifyToken$Mutation()
    ..verifyToken = json['verifyToken'] == null
        ? null
        : VerifyToken$Mutation$VerifyToken.fromJson(
            json['verifyToken'] as Map<String, dynamic>);
}

Map<String, dynamic> _$VerifyToken$MutationToJson(
        VerifyToken$Mutation instance) =>
    <String, dynamic>{
      'verifyToken': instance.verifyToken?.toJson(),
    };

UnassignedTasks$Query$UnassignedTasks
    _$UnassignedTasks$Query$UnassignedTasksFromJson(Map<String, dynamic> json) {
  return UnassignedTasks$Query$UnassignedTasks()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..periodEnd = json['periodEnd'] as String
    ..state = _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown)
    ..user = json['user'] == null
        ? null
        : SimpleTaskMixin$User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UnassignedTasks$Query$UnassignedTasksToJson(
        UnassignedTasks$Query$UnassignedTasks instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'periodEnd': instance.periodEnd,
      'state': _$TaskStateEnumMap[instance.state],
      'user': instance.user?.toJson(),
    };

UnassignedTasks$Query _$UnassignedTasks$QueryFromJson(
    Map<String, dynamic> json) {
  return UnassignedTasks$Query()
    ..unassignedTasks = (json['unassignedTasks'] as List)
        ?.map((e) => e == null
            ? null
            : UnassignedTasks$Query$UnassignedTasks.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$UnassignedTasks$QueryToJson(
        UnassignedTasks$Query instance) =>
    <String, dynamic>{
      'unassignedTasks':
          instance.unassignedTasks?.map((e) => e?.toJson())?.toList(),
    };

SaveTask$Mutation$SaveTask$Task _$SaveTask$Mutation$SaveTask$TaskFromJson(
    Map<String, dynamic> json) {
  return SaveTask$Mutation$SaveTask$Task()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..periodEnd = json['periodEnd'] as String
    ..state = _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown)
    ..user = json['user'] == null
        ? null
        : SimpleTaskMixin$User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SaveTask$Mutation$SaveTask$TaskToJson(
        SaveTask$Mutation$SaveTask$Task instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'periodEnd': instance.periodEnd,
      'state': _$TaskStateEnumMap[instance.state],
      'user': instance.user?.toJson(),
    };

SaveTask$Mutation$SaveTask _$SaveTask$Mutation$SaveTaskFromJson(
    Map<String, dynamic> json) {
  return SaveTask$Mutation$SaveTask()
    ..task = json['task'] == null
        ? null
        : SaveTask$Mutation$SaveTask$Task.fromJson(
            json['task'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SaveTask$Mutation$SaveTaskToJson(
        SaveTask$Mutation$SaveTask instance) =>
    <String, dynamic>{
      'task': instance.task?.toJson(),
    };

SaveTask$Mutation _$SaveTask$MutationFromJson(Map<String, dynamic> json) {
  return SaveTask$Mutation()
    ..saveTask = json['saveTask'] == null
        ? null
        : SaveTask$Mutation$SaveTask.fromJson(
            json['saveTask'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SaveTask$MutationToJson(SaveTask$Mutation instance) =>
    <String, dynamic>{
      'saveTask': instance.saveTask?.toJson(),
    };

AllTodoTasks$Query$AllTodoTasks _$AllTodoTasks$Query$AllTodoTasksFromJson(
    Map<String, dynamic> json) {
  return AllTodoTasks$Query$AllTodoTasks()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..periodEnd = json['periodEnd'] as String
    ..state = _$enumDecodeNullable(_$TaskStateEnumMap, json['state'],
        unknownValue: TaskState.artemisUnknown)
    ..user = json['user'] == null
        ? null
        : SimpleTaskMixin$User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AllTodoTasks$Query$AllTodoTasksToJson(
        AllTodoTasks$Query$AllTodoTasks instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'periodEnd': instance.periodEnd,
      'state': _$TaskStateEnumMap[instance.state],
      'user': instance.user?.toJson(),
    };

AllTodoTasks$Query _$AllTodoTasks$QueryFromJson(Map<String, dynamic> json) {
  return AllTodoTasks$Query()
    ..allTodoTasks = (json['allTodoTasks'] as List)
        ?.map((e) => e == null
            ? null
            : AllTodoTasks$Query$AllTodoTasks.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$AllTodoTasks$QueryToJson(AllTodoTasks$Query instance) =>
    <String, dynamic>{
      'allTodoTasks': instance.allTodoTasks?.map((e) => e?.toJson())?.toList(),
    };

Users$Query$Users _$Users$Query$UsersFromJson(Map<String, dynamic> json) {
  return Users$Query$Users()
    ..id = json['id'] as String
    ..publicName = json['publicName'] as String;
}

Map<String, dynamic> _$Users$Query$UsersToJson(Users$Query$Users instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publicName': instance.publicName,
    };

Users$Query _$Users$QueryFromJson(Map<String, dynamic> json) {
  return Users$Query()
    ..users = (json['users'] as List)
        ?.map((e) => e == null
            ? null
            : Users$Query$Users.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$Users$QueryToJson(Users$Query instance) =>
    <String, dynamic>{
      'users': instance.users?.map((e) => e?.toJson())?.toList(),
    };

UpdateApprovalArguments _$UpdateApprovalArgumentsFromJson(
    Map<String, dynamic> json) {
  return UpdateApprovalArguments(
    approval: json['approval'] == null
        ? null
        : ApprovalInput.fromJson(json['approval'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateApprovalArgumentsToJson(
        UpdateApprovalArguments instance) =>
    <String, dynamic>{
      'approval': instance.approval?.toJson(),
    };

UsersTodoTasksArguments _$UsersTodoTasksArgumentsFromJson(
    Map<String, dynamic> json) {
  return UsersTodoTasksArguments(
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$UsersTodoTasksArgumentsToJson(
        UsersTodoTasksArguments instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

ToApproveTasksOfUserArguments _$ToApproveTasksOfUserArgumentsFromJson(
    Map<String, dynamic> json) {
  return ToApproveTasksOfUserArguments(
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$ToApproveTasksOfUserArgumentsToJson(
        ToApproveTasksOfUserArguments instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

TokenAuthArguments _$TokenAuthArgumentsFromJson(Map<String, dynamic> json) {
  return TokenAuthArguments(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$TokenAuthArgumentsToJson(TokenAuthArguments instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

UpdateDetailTaskArguments _$UpdateDetailTaskArgumentsFromJson(
    Map<String, dynamic> json) {
  return UpdateDetailTaskArguments(
    createInput: json['createInput'] == null
        ? null
        : TaskInputCreate.fromJson(json['createInput'] as Map<String, dynamic>),
    updateInput: json['updateInput'] == null
        ? null
        : TaskInputUpdate.fromJson(json['updateInput'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateDetailTaskArgumentsToJson(
        UpdateDetailTaskArguments instance) =>
    <String, dynamic>{
      'createInput': instance.createInput?.toJson(),
      'updateInput': instance.updateInput?.toJson(),
    };

TaskDetailArguments _$TaskDetailArgumentsFromJson(Map<String, dynamic> json) {
  return TaskDetailArguments(
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$TaskDetailArgumentsToJson(
        TaskDetailArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

TaskChangesArguments _$TaskChangesArgumentsFromJson(Map<String, dynamic> json) {
  return TaskChangesArguments(
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$TaskChangesArgumentsToJson(
        TaskChangesArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

UsersDoneToApproveTasksArguments _$UsersDoneToApproveTasksArgumentsFromJson(
    Map<String, dynamic> json) {
  return UsersDoneToApproveTasksArguments(
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$UsersDoneToApproveTasksArgumentsToJson(
        UsersDoneToApproveTasksArguments instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

VerifyTokenArguments _$VerifyTokenArgumentsFromJson(Map<String, dynamic> json) {
  return VerifyTokenArguments(
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$VerifyTokenArgumentsToJson(
        VerifyTokenArguments instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

SaveTaskArguments _$SaveTaskArgumentsFromJson(Map<String, dynamic> json) {
  return SaveTaskArguments(
    createInput: json['createInput'] == null
        ? null
        : TaskInputCreate.fromJson(json['createInput'] as Map<String, dynamic>),
    updateInput: json['updateInput'] == null
        ? null
        : TaskInputUpdate.fromJson(json['updateInput'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SaveTaskArgumentsToJson(SaveTaskArguments instance) =>
    <String, dynamic>{
      'createInput': instance.createInput?.toJson(),
      'updateInput': instance.updateInput?.toJson(),
    };
