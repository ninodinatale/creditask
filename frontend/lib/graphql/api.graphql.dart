// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:meta/meta.dart';
import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
part 'api.graphql.g.dart';

mixin SimpleTaskMixin {
  String id;
  String name;
  String periodEnd;
  @JsonKey(unknownEnumValue: TaskState.artemisUnknown)
  TaskState state;
  SimpleTaskMixin$User user;
}
mixin SimpleTaskApprovalsMixin {
  List<SimpleTaskApprovalsMixin$Approvals> approvals;
}
mixin SimpleApprovalMixin {
  String id;
  SimpleApprovalMixin$User user;
  @JsonKey(unknownEnumValue: ApprovalState.artemisUnknown)
  ApprovalState state;
  String message;
}
mixin SimpleUserMixin {
  String id;
  String publicName;
}
mixin GroceryMixin {
  String id;
  String name;
  String info;
  bool inCart;
  @JsonKey(name: '__typename')
  String $$typename;
}
mixin ToApproveTasksOfUserMixin {}
mixin TaskWithApprovalsMixin {
  @JsonKey(name: '__typename')
  String $$typename;
  List<TaskWithApprovalsMixin$Approvals> approvals;
}
mixin CurrentUserMixin {
  String id;
  String publicName;
  String email;
}
mixin DetailTaskMixin {
  @JsonKey(name: '__typename')
  String $$typename;
  String id;
  @JsonKey(unknownEnumValue: CreditsCalc.artemisUnknown)
  CreditsCalc creditsCalc;
  int fixedCredits;
  double factor;
  String name;
  int neededTimeSeconds;
  String periodStart;
  String periodEnd;
  @JsonKey(unknownEnumValue: TaskState.artemisUnknown)
  TaskState state;
  DetailTaskMixin$User user;
  List<DetailTaskMixin$Approvals> approvals;
}
mixin CreditsUserMixin {
  int credits;
}
mixin TaskChangesMixin {
  @JsonKey(unknownEnumValue: TaskChangeChangedProperty.artemisUnknown)
  TaskChangeChangedProperty changedProperty;
  String currentValue;
  String previousValue;
  String timestamp;
  TaskChangesMixin$User user;
}

@JsonSerializable(explicitToJson: true)
class TaskSetDoneTask$Mutation$SaveTask$Task with EquatableMixin {
  TaskSetDoneTask$Mutation$SaveTask$Task();

  factory TaskSetDoneTask$Mutation$SaveTask$Task.fromJson(
          Map<String, dynamic> json) =>
      _$TaskSetDoneTask$Mutation$SaveTask$TaskFromJson(json);

  @JsonKey(name: '__typename')
  String $$typename;

  @override
  List<Object> get props => [$$typename];
  Map<String, dynamic> toJson() =>
      _$TaskSetDoneTask$Mutation$SaveTask$TaskToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskSetDoneTask$Mutation$SaveTask with EquatableMixin {
  TaskSetDoneTask$Mutation$SaveTask();

  factory TaskSetDoneTask$Mutation$SaveTask.fromJson(
          Map<String, dynamic> json) =>
      _$TaskSetDoneTask$Mutation$SaveTaskFromJson(json);

  @JsonKey(name: '__typename')
  String $$typename;

  TaskSetDoneTask$Mutation$SaveTask$Task task;

  @override
  List<Object> get props => [$$typename, task];
  Map<String, dynamic> toJson() =>
      _$TaskSetDoneTask$Mutation$SaveTaskToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskSetDoneTask$Mutation with EquatableMixin {
  TaskSetDoneTask$Mutation();

  factory TaskSetDoneTask$Mutation.fromJson(Map<String, dynamic> json) =>
      _$TaskSetDoneTask$MutationFromJson(json);

  TaskSetDoneTask$Mutation$SaveTask saveTask;

  @override
  List<Object> get props => [saveTask];
  Map<String, dynamic> toJson() => _$TaskSetDoneTask$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskInputUpdate with EquatableMixin {
  TaskInputUpdate(
      {@required this.id,
      this.state,
      this.name,
      this.creditsCalc,
      this.fixedCredits,
      this.factor,
      this.userId,
      this.neededTimeSeconds,
      this.periodStart,
      this.periodEnd});

  factory TaskInputUpdate.fromJson(Map<String, dynamic> json) =>
      _$TaskInputUpdateFromJson(json);

  String id;

  @JsonKey(unknownEnumValue: TaskState.artemisUnknown)
  TaskState state;

  String name;

  @JsonKey(unknownEnumValue: CreditsCalc.artemisUnknown)
  CreditsCalc creditsCalc;

  double fixedCredits;

  double factor;

  String userId;

  int neededTimeSeconds;

  String periodStart;

  String periodEnd;

  @override
  List<Object> get props => [
        id,
        state,
        name,
        creditsCalc,
        fixedCredits,
        factor,
        userId,
        neededTimeSeconds,
        periodStart,
        periodEnd
      ];
  Map<String, dynamic> toJson() => _$TaskInputUpdateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateApproval$Mutation$SaveApproval$Approval with EquatableMixin {
  UpdateApproval$Mutation$SaveApproval$Approval();

  factory UpdateApproval$Mutation$SaveApproval$Approval.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateApproval$Mutation$SaveApproval$ApprovalFromJson(json);

  String id;

  @JsonKey(unknownEnumValue: ApprovalState.artemisUnknown)
  ApprovalState state;

  String message;

  @override
  List<Object> get props => [id, state, message];
  Map<String, dynamic> toJson() =>
      _$UpdateApproval$Mutation$SaveApproval$ApprovalToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateApproval$Mutation$SaveApproval with EquatableMixin {
  UpdateApproval$Mutation$SaveApproval();

  factory UpdateApproval$Mutation$SaveApproval.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateApproval$Mutation$SaveApprovalFromJson(json);

  UpdateApproval$Mutation$SaveApproval$Approval approval;

  @override
  List<Object> get props => [approval];
  Map<String, dynamic> toJson() =>
      _$UpdateApproval$Mutation$SaveApprovalToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateApproval$Mutation with EquatableMixin {
  UpdateApproval$Mutation();

  factory UpdateApproval$Mutation.fromJson(Map<String, dynamic> json) =>
      _$UpdateApproval$MutationFromJson(json);

  UpdateApproval$Mutation$SaveApproval saveApproval;

  @override
  List<Object> get props => [saveApproval];
  Map<String, dynamic> toJson() => _$UpdateApproval$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApprovalInput with EquatableMixin {
  ApprovalInput({@required this.id, @required this.state, this.message});

  factory ApprovalInput.fromJson(Map<String, dynamic> json) =>
      _$ApprovalInputFromJson(json);

  String id;

  @JsonKey(unknownEnumValue: ApprovalState.artemisUnknown)
  ApprovalState state;

  String message;

  @override
  List<Object> get props => [id, state, message];
  Map<String, dynamic> toJson() => _$ApprovalInputToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UsersTodoTasks$Query$TodoTasksOfUser
    with EquatableMixin, SimpleTaskMixin, SimpleTaskApprovalsMixin {
  UsersTodoTasks$Query$TodoTasksOfUser();

  factory UsersTodoTasks$Query$TodoTasksOfUser.fromJson(
          Map<String, dynamic> json) =>
      _$UsersTodoTasks$Query$TodoTasksOfUserFromJson(json);

  @override
  List<Object> get props => [id, name, periodEnd, state, user, approvals];
  Map<String, dynamic> toJson() =>
      _$UsersTodoTasks$Query$TodoTasksOfUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UsersTodoTasks$Query with EquatableMixin {
  UsersTodoTasks$Query();

  factory UsersTodoTasks$Query.fromJson(Map<String, dynamic> json) =>
      _$UsersTodoTasks$QueryFromJson(json);

  List<UsersTodoTasks$Query$TodoTasksOfUser> todoTasksOfUser;

  @override
  List<Object> get props => [todoTasksOfUser];
  Map<String, dynamic> toJson() => _$UsersTodoTasks$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SimpleTaskMixin$User with EquatableMixin {
  SimpleTaskMixin$User();

  factory SimpleTaskMixin$User.fromJson(Map<String, dynamic> json) =>
      _$SimpleTaskMixin$UserFromJson(json);

  String publicName;

  @override
  List<Object> get props => [publicName];
  Map<String, dynamic> toJson() => _$SimpleTaskMixin$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SimpleTaskApprovalsMixin$Approvals
    with EquatableMixin, SimpleApprovalMixin {
  SimpleTaskApprovalsMixin$Approvals();

  factory SimpleTaskApprovalsMixin$Approvals.fromJson(
          Map<String, dynamic> json) =>
      _$SimpleTaskApprovalsMixin$ApprovalsFromJson(json);

  @override
  List<Object> get props => [id, user, state, message];
  Map<String, dynamic> toJson() =>
      _$SimpleTaskApprovalsMixin$ApprovalsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SimpleApprovalMixin$User with EquatableMixin, SimpleUserMixin {
  SimpleApprovalMixin$User();

  factory SimpleApprovalMixin$User.fromJson(Map<String, dynamic> json) =>
      _$SimpleApprovalMixin$UserFromJson(json);

  @override
  List<Object> get props => [id, publicName];
  Map<String, dynamic> toJson() => _$SimpleApprovalMixin$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AllGroceriesInCart$Query$AllInCart with EquatableMixin, GroceryMixin {
  AllGroceriesInCart$Query$AllInCart();

  factory AllGroceriesInCart$Query$AllInCart.fromJson(
          Map<String, dynamic> json) =>
      _$AllGroceriesInCart$Query$AllInCartFromJson(json);

  @override
  List<Object> get props => [id, name, info, inCart, $$typename];
  Map<String, dynamic> toJson() =>
      _$AllGroceriesInCart$Query$AllInCartToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AllGroceriesInCart$Query with EquatableMixin {
  AllGroceriesInCart$Query();

  factory AllGroceriesInCart$Query.fromJson(Map<String, dynamic> json) =>
      _$AllGroceriesInCart$QueryFromJson(json);

  List<AllGroceriesInCart$Query$AllInCart> allInCart;

  @override
  List<Object> get props => [allInCart];
  Map<String, dynamic> toJson() => _$AllGroceriesInCart$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ToApproveTasksOfUser$Query$ToApproveTasksOfUser
    with
        EquatableMixin,
        ToApproveTasksOfUserMixin,
        TaskWithApprovalsMixin,
        SimpleTaskMixin {
  ToApproveTasksOfUser$Query$ToApproveTasksOfUser();

  factory ToApproveTasksOfUser$Query$ToApproveTasksOfUser.fromJson(
          Map<String, dynamic> json) =>
      _$ToApproveTasksOfUser$Query$ToApproveTasksOfUserFromJson(json);

  @override
  List<Object> get props =>
      [$$typename, approvals, id, name, periodEnd, state, user];
  Map<String, dynamic> toJson() =>
      _$ToApproveTasksOfUser$Query$ToApproveTasksOfUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ToApproveTasksOfUser$Query with EquatableMixin {
  ToApproveTasksOfUser$Query();

  factory ToApproveTasksOfUser$Query.fromJson(Map<String, dynamic> json) =>
      _$ToApproveTasksOfUser$QueryFromJson(json);

  List<ToApproveTasksOfUser$Query$ToApproveTasksOfUser> toApproveTasksOfUser;

  @override
  List<Object> get props => [toApproveTasksOfUser];
  Map<String, dynamic> toJson() => _$ToApproveTasksOfUser$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskWithApprovalsMixin$Approvals
    with EquatableMixin, SimpleApprovalMixin {
  TaskWithApprovalsMixin$Approvals();

  factory TaskWithApprovalsMixin$Approvals.fromJson(
          Map<String, dynamic> json) =>
      _$TaskWithApprovalsMixin$ApprovalsFromJson(json);

  @override
  List<Object> get props => [id, user, state, message];
  Map<String, dynamic> toJson() =>
      _$TaskWithApprovalsMixin$ApprovalsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TokenAuth$Mutation$TokenAuth$User with EquatableMixin, CurrentUserMixin {
  TokenAuth$Mutation$TokenAuth$User();

  factory TokenAuth$Mutation$TokenAuth$User.fromJson(
          Map<String, dynamic> json) =>
      _$TokenAuth$Mutation$TokenAuth$UserFromJson(json);

  @override
  List<Object> get props => [id, publicName, email];
  Map<String, dynamic> toJson() =>
      _$TokenAuth$Mutation$TokenAuth$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TokenAuth$Mutation$TokenAuth with EquatableMixin {
  TokenAuth$Mutation$TokenAuth();

  factory TokenAuth$Mutation$TokenAuth.fromJson(Map<String, dynamic> json) =>
      _$TokenAuth$Mutation$TokenAuthFromJson(json);

  String token;

  TokenAuth$Mutation$TokenAuth$User user;

  @override
  List<Object> get props => [token, user];
  Map<String, dynamic> toJson() => _$TokenAuth$Mutation$TokenAuthToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TokenAuth$Mutation with EquatableMixin {
  TokenAuth$Mutation();

  factory TokenAuth$Mutation.fromJson(Map<String, dynamic> json) =>
      _$TokenAuth$MutationFromJson(json);

  TokenAuth$Mutation$TokenAuth tokenAuth;

  @override
  List<Object> get props => [tokenAuth];
  Map<String, dynamic> toJson() => _$TokenAuth$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateGrocery$Mutation$CreateGrocery$Grocery
    with EquatableMixin, GroceryMixin {
  CreateGrocery$Mutation$CreateGrocery$Grocery();

  factory CreateGrocery$Mutation$CreateGrocery$Grocery.fromJson(
          Map<String, dynamic> json) =>
      _$CreateGrocery$Mutation$CreateGrocery$GroceryFromJson(json);

  @override
  List<Object> get props => [id, name, info, inCart, $$typename];
  Map<String, dynamic> toJson() =>
      _$CreateGrocery$Mutation$CreateGrocery$GroceryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateGrocery$Mutation$CreateGrocery with EquatableMixin {
  CreateGrocery$Mutation$CreateGrocery();

  factory CreateGrocery$Mutation$CreateGrocery.fromJson(
          Map<String, dynamic> json) =>
      _$CreateGrocery$Mutation$CreateGroceryFromJson(json);

  CreateGrocery$Mutation$CreateGrocery$Grocery grocery;

  @override
  List<Object> get props => [grocery];
  Map<String, dynamic> toJson() =>
      _$CreateGrocery$Mutation$CreateGroceryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CreateGrocery$Mutation with EquatableMixin {
  CreateGrocery$Mutation();

  factory CreateGrocery$Mutation.fromJson(Map<String, dynamic> json) =>
      _$CreateGrocery$MutationFromJson(json);

  CreateGrocery$Mutation$CreateGrocery createGrocery;

  @override
  List<Object> get props => [createGrocery];
  Map<String, dynamic> toJson() => _$CreateGrocery$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GroceryCreateInput with EquatableMixin {
  GroceryCreateInput({@required this.name, @required this.info});

  factory GroceryCreateInput.fromJson(Map<String, dynamic> json) =>
      _$GroceryCreateInputFromJson(json);

  String name;

  String info;

  @override
  List<Object> get props => [name, info];
  Map<String, dynamic> toJson() => _$GroceryCreateInputToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateDetailTask$Mutation$SaveTask$Task
    with EquatableMixin, DetailTaskMixin {
  UpdateDetailTask$Mutation$SaveTask$Task();

  factory UpdateDetailTask$Mutation$SaveTask$Task.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateDetailTask$Mutation$SaveTask$TaskFromJson(json);

  @override
  List<Object> get props => [
        $$typename,
        id,
        creditsCalc,
        fixedCredits,
        factor,
        name,
        neededTimeSeconds,
        periodStart,
        periodEnd,
        state,
        user,
        approvals
      ];
  Map<String, dynamic> toJson() =>
      _$UpdateDetailTask$Mutation$SaveTask$TaskToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateDetailTask$Mutation$SaveTask with EquatableMixin {
  UpdateDetailTask$Mutation$SaveTask();

  factory UpdateDetailTask$Mutation$SaveTask.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateDetailTask$Mutation$SaveTaskFromJson(json);

  UpdateDetailTask$Mutation$SaveTask$Task task;

  @override
  List<Object> get props => [task];
  Map<String, dynamic> toJson() =>
      _$UpdateDetailTask$Mutation$SaveTaskToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateDetailTask$Mutation with EquatableMixin {
  UpdateDetailTask$Mutation();

  factory UpdateDetailTask$Mutation.fromJson(Map<String, dynamic> json) =>
      _$UpdateDetailTask$MutationFromJson(json);

  UpdateDetailTask$Mutation$SaveTask saveTask;

  @override
  List<Object> get props => [saveTask];
  Map<String, dynamic> toJson() => _$UpdateDetailTask$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DetailTaskMixin$User with EquatableMixin, SimpleUserMixin {
  DetailTaskMixin$User();

  factory DetailTaskMixin$User.fromJson(Map<String, dynamic> json) =>
      _$DetailTaskMixin$UserFromJson(json);

  @override
  List<Object> get props => [id, publicName];
  Map<String, dynamic> toJson() => _$DetailTaskMixin$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DetailTaskMixin$Approvals with EquatableMixin, SimpleApprovalMixin {
  DetailTaskMixin$Approvals();

  factory DetailTaskMixin$Approvals.fromJson(Map<String, dynamic> json) =>
      _$DetailTaskMixin$ApprovalsFromJson(json);

  @override
  List<Object> get props => [id, user, state, message];
  Map<String, dynamic> toJson() => _$DetailTaskMixin$ApprovalsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskInputCreate with EquatableMixin {
  TaskInputCreate(
      {@required this.name,
      @required this.creditsCalc,
      this.fixedCredits,
      this.factor,
      this.userId,
      this.periodStart,
      this.periodEnd});

  factory TaskInputCreate.fromJson(Map<String, dynamic> json) =>
      _$TaskInputCreateFromJson(json);

  String name;

  @JsonKey(unknownEnumValue: CreditsCalc.artemisUnknown)
  CreditsCalc creditsCalc;

  double fixedCredits;

  double factor;

  String userId;

  String periodStart;

  String periodEnd;

  @override
  List<Object> get props =>
      [name, creditsCalc, fixedCredits, factor, userId, periodStart, periodEnd];
  Map<String, dynamic> toJson() => _$TaskInputCreateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskDetail$Query$Task with EquatableMixin, DetailTaskMixin {
  TaskDetail$Query$Task();

  factory TaskDetail$Query$Task.fromJson(Map<String, dynamic> json) =>
      _$TaskDetail$Query$TaskFromJson(json);

  @override
  List<Object> get props => [
        $$typename,
        id,
        creditsCalc,
        fixedCredits,
        factor,
        name,
        neededTimeSeconds,
        periodStart,
        periodEnd,
        state,
        user,
        approvals
      ];
  Map<String, dynamic> toJson() => _$TaskDetail$Query$TaskToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskDetail$Query with EquatableMixin {
  TaskDetail$Query();

  factory TaskDetail$Query.fromJson(Map<String, dynamic> json) =>
      _$TaskDetail$QueryFromJson(json);

  TaskDetail$Query$Task task;

  @override
  List<Object> get props => [task];
  Map<String, dynamic> toJson() => _$TaskDetail$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Credits$Query$Users
    with EquatableMixin, CreditsUserMixin, SimpleUserMixin {
  Credits$Query$Users();

  factory Credits$Query$Users.fromJson(Map<String, dynamic> json) =>
      _$Credits$Query$UsersFromJson(json);

  @override
  List<Object> get props => [credits, id, publicName];
  Map<String, dynamic> toJson() => _$Credits$Query$UsersToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Credits$Query with EquatableMixin {
  Credits$Query();

  factory Credits$Query.fromJson(Map<String, dynamic> json) =>
      _$Credits$QueryFromJson(json);

  List<Credits$Query$Users> users;

  @override
  List<Object> get props => [users];
  Map<String, dynamic> toJson() => _$Credits$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskChanges$Query$TaskChanges with EquatableMixin, TaskChangesMixin {
  TaskChanges$Query$TaskChanges();

  factory TaskChanges$Query$TaskChanges.fromJson(Map<String, dynamic> json) =>
      _$TaskChanges$Query$TaskChangesFromJson(json);

  @JsonKey(name: '__typename')
  String $$typename;

  @override
  List<Object> get props => [
        changedProperty,
        currentValue,
        previousValue,
        timestamp,
        user,
        $$typename
      ];
  Map<String, dynamic> toJson() => _$TaskChanges$Query$TaskChangesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskChanges$Query with EquatableMixin {
  TaskChanges$Query();

  factory TaskChanges$Query.fromJson(Map<String, dynamic> json) =>
      _$TaskChanges$QueryFromJson(json);

  List<TaskChanges$Query$TaskChanges> taskChanges;

  @override
  List<Object> get props => [taskChanges];
  Map<String, dynamic> toJson() => _$TaskChanges$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TaskChangesMixin$User with EquatableMixin, SimpleUserMixin {
  TaskChangesMixin$User();

  factory TaskChangesMixin$User.fromJson(Map<String, dynamic> json) =>
      _$TaskChangesMixin$UserFromJson(json);

  @override
  List<Object> get props => [id, publicName];
  Map<String, dynamic> toJson() => _$TaskChangesMixin$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateGrocery$Mutation$UpdateGrocery$Grocery
    with EquatableMixin, GroceryMixin {
  UpdateGrocery$Mutation$UpdateGrocery$Grocery();

  factory UpdateGrocery$Mutation$UpdateGrocery$Grocery.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateGrocery$Mutation$UpdateGrocery$GroceryFromJson(json);

  @override
  List<Object> get props => [id, name, info, inCart, $$typename];
  Map<String, dynamic> toJson() =>
      _$UpdateGrocery$Mutation$UpdateGrocery$GroceryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateGrocery$Mutation$UpdateGrocery with EquatableMixin {
  UpdateGrocery$Mutation$UpdateGrocery();

  factory UpdateGrocery$Mutation$UpdateGrocery.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateGrocery$Mutation$UpdateGroceryFromJson(json);

  UpdateGrocery$Mutation$UpdateGrocery$Grocery grocery;

  @override
  List<Object> get props => [grocery];
  Map<String, dynamic> toJson() =>
      _$UpdateGrocery$Mutation$UpdateGroceryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateGrocery$Mutation with EquatableMixin {
  UpdateGrocery$Mutation();

  factory UpdateGrocery$Mutation.fromJson(Map<String, dynamic> json) =>
      _$UpdateGrocery$MutationFromJson(json);

  UpdateGrocery$Mutation$UpdateGrocery updateGrocery;

  @override
  List<Object> get props => [updateGrocery];
  Map<String, dynamic> toJson() => _$UpdateGrocery$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GroceryUpdateInput with EquatableMixin {
  GroceryUpdateInput({@required this.id, this.name, this.info, this.inCart});

  factory GroceryUpdateInput.fromJson(Map<String, dynamic> json) =>
      _$GroceryUpdateInputFromJson(json);

  String id;

  String name;

  String info;

  bool inCart;

  @override
  List<Object> get props => [id, name, info, inCart];
  Map<String, dynamic> toJson() => _$GroceryUpdateInputToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Error$Mutation$SaveError with EquatableMixin {
  Error$Mutation$SaveError();

  factory Error$Mutation$SaveError.fromJson(Map<String, dynamic> json) =>
      _$Error$Mutation$SaveErrorFromJson(json);

  @JsonKey(name: '__typename')
  String $$typename;

  @override
  List<Object> get props => [$$typename];
  Map<String, dynamic> toJson() => _$Error$Mutation$SaveErrorToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Error$Mutation with EquatableMixin {
  Error$Mutation();

  factory Error$Mutation.fromJson(Map<String, dynamic> json) =>
      _$Error$MutationFromJson(json);

  Error$Mutation$SaveError saveError;

  @override
  List<Object> get props => [saveError];
  Map<String, dynamic> toJson() => _$Error$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateGroceries$Mutation$UpdateGroceries$Groceries
    with EquatableMixin, GroceryMixin {
  UpdateGroceries$Mutation$UpdateGroceries$Groceries();

  factory UpdateGroceries$Mutation$UpdateGroceries$Groceries.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateGroceries$Mutation$UpdateGroceries$GroceriesFromJson(json);

  @override
  List<Object> get props => [id, name, info, inCart, $$typename];
  Map<String, dynamic> toJson() =>
      _$UpdateGroceries$Mutation$UpdateGroceries$GroceriesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateGroceries$Mutation$UpdateGroceries with EquatableMixin {
  UpdateGroceries$Mutation$UpdateGroceries();

  factory UpdateGroceries$Mutation$UpdateGroceries.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateGroceries$Mutation$UpdateGroceriesFromJson(json);

  List<UpdateGroceries$Mutation$UpdateGroceries$Groceries> groceries;

  @override
  List<Object> get props => [groceries];
  Map<String, dynamic> toJson() =>
      _$UpdateGroceries$Mutation$UpdateGroceriesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateGroceries$Mutation with EquatableMixin {
  UpdateGroceries$Mutation();

  factory UpdateGroceries$Mutation.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroceries$MutationFromJson(json);

  UpdateGroceries$Mutation$UpdateGroceries updateGroceries;

  @override
  List<Object> get props => [updateGroceries];
  Map<String, dynamic> toJson() => _$UpdateGroceries$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VerifyToken$Mutation$VerifyToken$User
    with EquatableMixin, CurrentUserMixin {
  VerifyToken$Mutation$VerifyToken$User();

  factory VerifyToken$Mutation$VerifyToken$User.fromJson(
          Map<String, dynamic> json) =>
      _$VerifyToken$Mutation$VerifyToken$UserFromJson(json);

  @override
  List<Object> get props => [id, publicName, email];
  Map<String, dynamic> toJson() =>
      _$VerifyToken$Mutation$VerifyToken$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VerifyToken$Mutation$VerifyToken with EquatableMixin {
  VerifyToken$Mutation$VerifyToken();

  factory VerifyToken$Mutation$VerifyToken.fromJson(
          Map<String, dynamic> json) =>
      _$VerifyToken$Mutation$VerifyTokenFromJson(json);

  VerifyToken$Mutation$VerifyToken$User user;

  @override
  List<Object> get props => [user];
  Map<String, dynamic> toJson() =>
      _$VerifyToken$Mutation$VerifyTokenToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VerifyToken$Mutation with EquatableMixin {
  VerifyToken$Mutation();

  factory VerifyToken$Mutation.fromJson(Map<String, dynamic> json) =>
      _$VerifyToken$MutationFromJson(json);

  VerifyToken$Mutation$VerifyToken verifyToken;

  @override
  List<Object> get props => [verifyToken];
  Map<String, dynamic> toJson() => _$VerifyToken$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Grocery$Query$AllNotInCart with EquatableMixin, GroceryMixin {
  Grocery$Query$AllNotInCart();

  factory Grocery$Query$AllNotInCart.fromJson(Map<String, dynamic> json) =>
      _$Grocery$Query$AllNotInCartFromJson(json);

  @override
  List<Object> get props => [id, name, info, inCart, $$typename];
  Map<String, dynamic> toJson() => _$Grocery$Query$AllNotInCartToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Grocery$Query with EquatableMixin {
  Grocery$Query();

  factory Grocery$Query.fromJson(Map<String, dynamic> json) =>
      _$Grocery$QueryFromJson(json);

  List<Grocery$Query$AllNotInCart> allNotInCart;

  @override
  List<Object> get props => [allNotInCart];
  Map<String, dynamic> toJson() => _$Grocery$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UnassignedTasks$Query$UnassignedTasks
    with EquatableMixin, SimpleTaskMixin {
  UnassignedTasks$Query$UnassignedTasks();

  factory UnassignedTasks$Query$UnassignedTasks.fromJson(
          Map<String, dynamic> json) =>
      _$UnassignedTasks$Query$UnassignedTasksFromJson(json);

  @override
  List<Object> get props => [id, name, periodEnd, state, user];
  Map<String, dynamic> toJson() =>
      _$UnassignedTasks$Query$UnassignedTasksToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UnassignedTasks$Query with EquatableMixin {
  UnassignedTasks$Query();

  factory UnassignedTasks$Query.fromJson(Map<String, dynamic> json) =>
      _$UnassignedTasks$QueryFromJson(json);

  List<UnassignedTasks$Query$UnassignedTasks> unassignedTasks;

  @override
  List<Object> get props => [unassignedTasks];
  Map<String, dynamic> toJson() => _$UnassignedTasks$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SaveTask$Mutation$SaveTask$Task with EquatableMixin, SimpleTaskMixin {
  SaveTask$Mutation$SaveTask$Task();

  factory SaveTask$Mutation$SaveTask$Task.fromJson(Map<String, dynamic> json) =>
      _$SaveTask$Mutation$SaveTask$TaskFromJson(json);

  @override
  List<Object> get props => [id, name, periodEnd, state, user];
  Map<String, dynamic> toJson() =>
      _$SaveTask$Mutation$SaveTask$TaskToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SaveTask$Mutation$SaveTask with EquatableMixin {
  SaveTask$Mutation$SaveTask();

  factory SaveTask$Mutation$SaveTask.fromJson(Map<String, dynamic> json) =>
      _$SaveTask$Mutation$SaveTaskFromJson(json);

  SaveTask$Mutation$SaveTask$Task task;

  @override
  List<Object> get props => [task];
  Map<String, dynamic> toJson() => _$SaveTask$Mutation$SaveTaskToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SaveTask$Mutation with EquatableMixin {
  SaveTask$Mutation();

  factory SaveTask$Mutation.fromJson(Map<String, dynamic> json) =>
      _$SaveTask$MutationFromJson(json);

  SaveTask$Mutation$SaveTask saveTask;

  @override
  List<Object> get props => [saveTask];
  Map<String, dynamic> toJson() => _$SaveTask$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AllTodoTasks$Query$AllTodoTasks with EquatableMixin, SimpleTaskMixin {
  AllTodoTasks$Query$AllTodoTasks();

  factory AllTodoTasks$Query$AllTodoTasks.fromJson(Map<String, dynamic> json) =>
      _$AllTodoTasks$Query$AllTodoTasksFromJson(json);

  @override
  List<Object> get props => [id, name, periodEnd, state, user];
  Map<String, dynamic> toJson() =>
      _$AllTodoTasks$Query$AllTodoTasksToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AllTodoTasks$Query with EquatableMixin {
  AllTodoTasks$Query();

  factory AllTodoTasks$Query.fromJson(Map<String, dynamic> json) =>
      _$AllTodoTasks$QueryFromJson(json);

  List<AllTodoTasks$Query$AllTodoTasks> allTodoTasks;

  @override
  List<Object> get props => [allTodoTasks];
  Map<String, dynamic> toJson() => _$AllTodoTasks$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Users$Query$Users with EquatableMixin, SimpleUserMixin {
  Users$Query$Users();

  factory Users$Query$Users.fromJson(Map<String, dynamic> json) =>
      _$Users$Query$UsersFromJson(json);

  @override
  List<Object> get props => [id, publicName];
  Map<String, dynamic> toJson() => _$Users$Query$UsersToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Users$Query with EquatableMixin {
  Users$Query();

  factory Users$Query.fromJson(Map<String, dynamic> json) =>
      _$Users$QueryFromJson(json);

  List<Users$Query$Users> users;

  @override
  List<Object> get props => [users];
  Map<String, dynamic> toJson() => _$Users$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DoneTasks$Query$Done with EquatableMixin, SimpleTaskMixin {
  DoneTasks$Query$Done();

  factory DoneTasks$Query$Done.fromJson(Map<String, dynamic> json) =>
      _$DoneTasks$Query$DoneFromJson(json);

  @override
  List<Object> get props => [id, name, periodEnd, state, user];
  Map<String, dynamic> toJson() => _$DoneTasks$Query$DoneToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DoneTasks$Query with EquatableMixin {
  DoneTasks$Query();

  factory DoneTasks$Query.fromJson(Map<String, dynamic> json) =>
      _$DoneTasks$QueryFromJson(json);

  List<DoneTasks$Query$Done> done;

  @override
  List<Object> get props => [done];
  Map<String, dynamic> toJson() => _$DoneTasks$QueryToJson(this);
}

enum CreditsCalc {
  @JsonValue('BY_FACTOR')
  byFactor,
  @JsonValue('FIXED')
  fixed,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum TaskState {
  @JsonValue('TO_DO')
  toDo,
  @JsonValue('TO_APPROVE')
  toApprove,
  @JsonValue('DECLINED')
  declined,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('DONE')
  done,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum ApprovalState {
  @JsonValue('NONE')
  none,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('DECLINED')
  declined,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum TaskChangeChangedProperty {
  @JsonValue('NAME')
  name,
  @JsonValue('NEEDED_TIME_SECONDS')
  neededTimeSeconds,
  @JsonValue('STATE')
  state,
  @JsonValue('CREDITS_CALC')
  creditsCalc,
  @JsonValue('FIXED_CREDITS')
  fixedCredits,
  @JsonValue('FACTOR')
  factor,
  @JsonValue('USER_ID')
  userId,
  @JsonValue('PERIOD_START')
  periodStart,
  @JsonValue('PERIOD_END')
  periodEnd,
  @JsonValue('APPROVAL')
  approval,
  @JsonValue('CREATED_BY_ID')
  createdById,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}

@JsonSerializable(explicitToJson: true)
class TaskSetDoneTaskArguments extends JsonSerializable with EquatableMixin {
  TaskSetDoneTaskArguments({this.updateInput});

  @override
  factory TaskSetDoneTaskArguments.fromJson(Map<String, dynamic> json) =>
      _$TaskSetDoneTaskArgumentsFromJson(json);

  final TaskInputUpdate updateInput;

  @override
  List<Object> get props => [updateInput];
  @override
  Map<String, dynamic> toJson() => _$TaskSetDoneTaskArgumentsToJson(this);
}

class TaskSetDoneTaskMutation
    extends GraphQLQuery<TaskSetDoneTask$Mutation, TaskSetDoneTaskArguments> {
  TaskSetDoneTaskMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'taskSetDoneTask'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'updateInput')),
              type: NamedTypeNode(
                  name: NameNode(value: 'TaskInputUpdate'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'saveTask'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'updateInput'),
                    value: VariableNode(name: NameNode(value: 'updateInput')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'task'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: '__typename'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ]))
              ]))
        ]))
  ]);

  @override
  final String operationName = 'taskSetDoneTask';

  @override
  final TaskSetDoneTaskArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  TaskSetDoneTask$Mutation parse(Map<String, dynamic> json) =>
      TaskSetDoneTask$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class UpdateApprovalArguments extends JsonSerializable with EquatableMixin {
  UpdateApprovalArguments({@required this.approval});

  @override
  factory UpdateApprovalArguments.fromJson(Map<String, dynamic> json) =>
      _$UpdateApprovalArgumentsFromJson(json);

  final ApprovalInput approval;

  @override
  List<Object> get props => [approval];
  @override
  Map<String, dynamic> toJson() => _$UpdateApprovalArgumentsToJson(this);
}

class UpdateApprovalMutation
    extends GraphQLQuery<UpdateApproval$Mutation, UpdateApprovalArguments> {
  UpdateApprovalMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'updateApproval'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'approval')),
              type: NamedTypeNode(
                  name: NameNode(value: 'ApprovalInput'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'saveApproval'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'approvalInput'),
                    value: VariableNode(name: NameNode(value: 'approval')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'approval'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FieldNode(
                          name: NameNode(value: 'id'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'state'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null),
                      FieldNode(
                          name: NameNode(value: 'message'),
                          alias: null,
                          arguments: [],
                          directives: [],
                          selectionSet: null)
                    ]))
              ]))
        ]))
  ]);

  @override
  final String operationName = 'updateApproval';

  @override
  final UpdateApprovalArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  UpdateApproval$Mutation parse(Map<String, dynamic> json) =>
      UpdateApproval$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class UsersTodoTasksArguments extends JsonSerializable with EquatableMixin {
  UsersTodoTasksArguments({@required this.email});

  @override
  factory UsersTodoTasksArguments.fromJson(Map<String, dynamic> json) =>
      _$UsersTodoTasksArgumentsFromJson(json);

  final String email;

  @override
  List<Object> get props => [email];
  @override
  Map<String, dynamic> toJson() => _$UsersTodoTasksArgumentsToJson(this);
}

class UsersTodoTasksQuery
    extends GraphQLQuery<UsersTodoTasks$Query, UsersTodoTasksArguments> {
  UsersTodoTasksQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'usersTodoTasks'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'email')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'todoTasksOfUser'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'userEmail'),
                    value: VariableNode(name: NameNode(value: 'email')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleTask'), directives: []),
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleTaskApprovals'),
                    directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleTask'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodEnd'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'publicName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleTaskApprovals'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'approvals'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleApproval'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleApproval'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'ApprovalType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleUser'), directives: [])
              ])),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'message'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'UserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'usersTodoTasks';

  @override
  final UsersTodoTasksArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  UsersTodoTasks$Query parse(Map<String, dynamic> json) =>
      UsersTodoTasks$Query.fromJson(json);
}

class AllGroceriesInCartQuery
    extends GraphQLQuery<AllGroceriesInCart$Query, JsonSerializable> {
  AllGroceriesInCartQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'allGroceriesInCart'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'allInCart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'grocery'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'grocery'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'GroceryType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'info'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'inCart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'allGroceriesInCart';

  @override
  List<Object> get props => [document, operationName];
  @override
  AllGroceriesInCart$Query parse(Map<String, dynamic> json) =>
      AllGroceriesInCart$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ToApproveTasksOfUserArguments extends JsonSerializable
    with EquatableMixin {
  ToApproveTasksOfUserArguments({@required this.email});

  @override
  factory ToApproveTasksOfUserArguments.fromJson(Map<String, dynamic> json) =>
      _$ToApproveTasksOfUserArgumentsFromJson(json);

  final String email;

  @override
  List<Object> get props => [email];
  @override
  Map<String, dynamic> toJson() => _$ToApproveTasksOfUserArgumentsToJson(this);
}

class ToApproveTasksOfUserQuery extends GraphQLQuery<ToApproveTasksOfUser$Query,
    ToApproveTasksOfUserArguments> {
  ToApproveTasksOfUserQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'toApproveTasksOfUser'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'email')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'toApproveTasksOfUser'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'userEmail'),
                    value: VariableNode(name: NameNode(value: 'email')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'toApproveTasksOfUser'),
                    directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'toApproveTasksOfUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FragmentSpreadNode(
              name: NameNode(value: 'taskWithApprovals'), directives: [])
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'taskWithApprovals'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FragmentSpreadNode(
              name: NameNode(value: 'simpleTask'), directives: []),
          FieldNode(
              name: NameNode(value: 'approvals'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleApproval'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleApproval'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'ApprovalType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleUser'), directives: [])
              ])),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'message'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'UserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleTask'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodEnd'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'publicName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'toApproveTasksOfUser';

  @override
  final ToApproveTasksOfUserArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  ToApproveTasksOfUser$Query parse(Map<String, dynamic> json) =>
      ToApproveTasksOfUser$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class TokenAuthArguments extends JsonSerializable with EquatableMixin {
  TokenAuthArguments({@required this.email, @required this.password});

  @override
  factory TokenAuthArguments.fromJson(Map<String, dynamic> json) =>
      _$TokenAuthArgumentsFromJson(json);

  final String email;

  final String password;

  @override
  List<Object> get props => [email, password];
  @override
  Map<String, dynamic> toJson() => _$TokenAuthArgumentsToJson(this);
}

class TokenAuthMutation
    extends GraphQLQuery<TokenAuth$Mutation, TokenAuthArguments> {
  TokenAuthMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'tokenAuth'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'email')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'password')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'tokenAuth'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'email'),
                    value: VariableNode(name: NameNode(value: 'email'))),
                ArgumentNode(
                    name: NameNode(value: 'password'),
                    value: VariableNode(name: NameNode(value: 'password')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'token'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FieldNode(
                    name: NameNode(value: 'user'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'currentUser'), directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'currentUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'CurrentUserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'email'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'tokenAuth';

  @override
  final TokenAuthArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  TokenAuth$Mutation parse(Map<String, dynamic> json) =>
      TokenAuth$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class CreateGroceryArguments extends JsonSerializable with EquatableMixin {
  CreateGroceryArguments({@required this.input});

  @override
  factory CreateGroceryArguments.fromJson(Map<String, dynamic> json) =>
      _$CreateGroceryArgumentsFromJson(json);

  final GroceryCreateInput input;

  @override
  List<Object> get props => [input];
  @override
  Map<String, dynamic> toJson() => _$CreateGroceryArgumentsToJson(this);
}

class CreateGroceryMutation
    extends GraphQLQuery<CreateGrocery$Mutation, CreateGroceryArguments> {
  CreateGroceryMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'createGrocery'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'input')),
              type: NamedTypeNode(
                  name: NameNode(value: 'GroceryCreateInput'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'createGrocery'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'input'),
                    value: VariableNode(name: NameNode(value: 'input')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'grocery'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'grocery'), directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'grocery'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'GroceryType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'info'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'inCart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'createGrocery';

  @override
  final CreateGroceryArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  CreateGrocery$Mutation parse(Map<String, dynamic> json) =>
      CreateGrocery$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class UpdateDetailTaskArguments extends JsonSerializable with EquatableMixin {
  UpdateDetailTaskArguments({this.createInput, this.updateInput});

  @override
  factory UpdateDetailTaskArguments.fromJson(Map<String, dynamic> json) =>
      _$UpdateDetailTaskArgumentsFromJson(json);

  final TaskInputCreate createInput;

  final TaskInputUpdate updateInput;

  @override
  List<Object> get props => [createInput, updateInput];
  @override
  Map<String, dynamic> toJson() => _$UpdateDetailTaskArgumentsToJson(this);
}

class UpdateDetailTaskMutation
    extends GraphQLQuery<UpdateDetailTask$Mutation, UpdateDetailTaskArguments> {
  UpdateDetailTaskMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'updateDetailTask'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'createInput')),
              type: NamedTypeNode(
                  name: NameNode(value: 'TaskInputCreate'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'updateInput')),
              type: NamedTypeNode(
                  name: NameNode(value: 'TaskInputUpdate'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'saveTask'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'createInput'),
                    value: VariableNode(name: NameNode(value: 'createInput'))),
                ArgumentNode(
                    name: NameNode(value: 'updateInput'),
                    value: VariableNode(name: NameNode(value: 'updateInput')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'task'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'detailTask'), directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'detailTask'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'creditsCalc'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'fixedCredits'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'factor'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'neededTimeSeconds'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodStart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodEnd'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleUser'), directives: [])
              ])),
          FieldNode(
              name: NameNode(value: 'approvals'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleApproval'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'UserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleApproval'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'ApprovalType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleUser'), directives: [])
              ])),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'message'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'updateDetailTask';

  @override
  final UpdateDetailTaskArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  UpdateDetailTask$Mutation parse(Map<String, dynamic> json) =>
      UpdateDetailTask$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class TaskDetailArguments extends JsonSerializable with EquatableMixin {
  TaskDetailArguments({@required this.id});

  @override
  factory TaskDetailArguments.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailArgumentsFromJson(json);

  final String id;

  @override
  List<Object> get props => [id];
  @override
  Map<String, dynamic> toJson() => _$TaskDetailArgumentsToJson(this);
}

class TaskDetailQuery
    extends GraphQLQuery<TaskDetail$Query, TaskDetailArguments> {
  TaskDetailQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'taskDetail'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'id')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'task'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'id'),
                    value: VariableNode(name: NameNode(value: 'id')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'detailTask'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'detailTask'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'creditsCalc'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'fixedCredits'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'factor'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'neededTimeSeconds'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodStart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodEnd'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleUser'), directives: [])
              ])),
          FieldNode(
              name: NameNode(value: 'approvals'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleApproval'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'UserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleApproval'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'ApprovalType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleUser'), directives: [])
              ])),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'message'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'taskDetail';

  @override
  final TaskDetailArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  TaskDetail$Query parse(Map<String, dynamic> json) =>
      TaskDetail$Query.fromJson(json);
}

class CreditsQuery extends GraphQLQuery<Credits$Query, JsonSerializable> {
  CreditsQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'credits'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'users'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'creditsUser'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'creditsUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'UserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FragmentSpreadNode(
              name: NameNode(value: 'simpleUser'), directives: []),
          FieldNode(
              name: NameNode(value: 'credits'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'UserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'credits';

  @override
  List<Object> get props => [document, operationName];
  @override
  Credits$Query parse(Map<String, dynamic> json) =>
      Credits$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class TaskChangesArguments extends JsonSerializable with EquatableMixin {
  TaskChangesArguments({@required this.taskId});

  @override
  factory TaskChangesArguments.fromJson(Map<String, dynamic> json) =>
      _$TaskChangesArgumentsFromJson(json);

  final String taskId;

  @override
  List<Object> get props => [taskId];
  @override
  Map<String, dynamic> toJson() => _$TaskChangesArgumentsToJson(this);
}

class TaskChangesQuery
    extends GraphQLQuery<TaskChanges$Query, TaskChangesArguments> {
  TaskChangesQuery({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'taskChanges'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'taskId')),
              type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'taskChanges'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'taskId'),
                    value: VariableNode(name: NameNode(value: 'taskId')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null),
                FragmentSpreadNode(
                    name: NameNode(value: 'taskChanges'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'taskChanges'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskChangeType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'changedProperty'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'currentValue'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'previousValue'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'timestamp'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleUser'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'UserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'taskChanges';

  @override
  final TaskChangesArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  TaskChanges$Query parse(Map<String, dynamic> json) =>
      TaskChanges$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class UpdateGroceryArguments extends JsonSerializable with EquatableMixin {
  UpdateGroceryArguments({@required this.input});

  @override
  factory UpdateGroceryArguments.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroceryArgumentsFromJson(json);

  final GroceryUpdateInput input;

  @override
  List<Object> get props => [input];
  @override
  Map<String, dynamic> toJson() => _$UpdateGroceryArgumentsToJson(this);
}

class UpdateGroceryMutation
    extends GraphQLQuery<UpdateGrocery$Mutation, UpdateGroceryArguments> {
  UpdateGroceryMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'updateGrocery'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'input')),
              type: NamedTypeNode(
                  name: NameNode(value: 'GroceryUpdateInput'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'updateGrocery'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'input'),
                    value: VariableNode(name: NameNode(value: 'input')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'grocery'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'grocery'), directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'grocery'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'GroceryType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'info'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'inCart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'updateGrocery';

  @override
  final UpdateGroceryArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  UpdateGrocery$Mutation parse(Map<String, dynamic> json) =>
      UpdateGrocery$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ErrorArguments extends JsonSerializable with EquatableMixin {
  ErrorArguments({@required this.stackTrace});

  @override
  factory ErrorArguments.fromJson(Map<String, dynamic> json) =>
      _$ErrorArgumentsFromJson(json);

  final String stackTrace;

  @override
  List<Object> get props => [stackTrace];
  @override
  Map<String, dynamic> toJson() => _$ErrorArgumentsToJson(this);
}

class ErrorMutation extends GraphQLQuery<Error$Mutation, ErrorArguments> {
  ErrorMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'error'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'stackTrace')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'saveError'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'stackTrace'),
                    value: VariableNode(name: NameNode(value: 'stackTrace')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: '__typename'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'error';

  @override
  final ErrorArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  Error$Mutation parse(Map<String, dynamic> json) =>
      Error$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class UpdateGroceriesArguments extends JsonSerializable with EquatableMixin {
  UpdateGroceriesArguments({@required this.input});

  @override
  factory UpdateGroceriesArguments.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroceriesArgumentsFromJson(json);

  final List<GroceryUpdateInput> input;

  @override
  List<Object> get props => [input];
  @override
  Map<String, dynamic> toJson() => _$UpdateGroceriesArgumentsToJson(this);
}

class UpdateGroceriesMutation
    extends GraphQLQuery<UpdateGroceries$Mutation, UpdateGroceriesArguments> {
  UpdateGroceriesMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'updateGroceries'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'input')),
              type: ListTypeNode(
                  type: NamedTypeNode(
                      name: NameNode(value: 'GroceryUpdateInput'),
                      isNonNull: true),
                  isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'updateGroceries'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'input'),
                    value: VariableNode(name: NameNode(value: 'input')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'groceries'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'grocery'), directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'grocery'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'GroceryType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'info'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'inCart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'updateGroceries';

  @override
  final UpdateGroceriesArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  UpdateGroceries$Mutation parse(Map<String, dynamic> json) =>
      UpdateGroceries$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class VerifyTokenArguments extends JsonSerializable with EquatableMixin {
  VerifyTokenArguments({@required this.token});

  @override
  factory VerifyTokenArguments.fromJson(Map<String, dynamic> json) =>
      _$VerifyTokenArgumentsFromJson(json);

  final String token;

  @override
  List<Object> get props => [token];
  @override
  Map<String, dynamic> toJson() => _$VerifyTokenArgumentsToJson(this);
}

class VerifyTokenMutation
    extends GraphQLQuery<VerifyToken$Mutation, VerifyTokenArguments> {
  VerifyTokenMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'verifyToken'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'token')),
              type: NamedTypeNode(
                  name: NameNode(value: 'String'), isNonNull: true),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'verifyToken'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'token'),
                    value: VariableNode(name: NameNode(value: 'token')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'user'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'currentUser'), directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'currentUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'CurrentUserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'email'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'verifyToken';

  @override
  final VerifyTokenArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  VerifyToken$Mutation parse(Map<String, dynamic> json) =>
      VerifyToken$Mutation.fromJson(json);
}

class GroceryQuery extends GraphQLQuery<Grocery$Query, JsonSerializable> {
  GroceryQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'grocery'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'allNotInCart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'grocery'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'grocery'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'GroceryType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'info'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'inCart'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'grocery';

  @override
  List<Object> get props => [document, operationName];
  @override
  Grocery$Query parse(Map<String, dynamic> json) =>
      Grocery$Query.fromJson(json);
}

class UnassignedTasksQuery
    extends GraphQLQuery<UnassignedTasks$Query, JsonSerializable> {
  UnassignedTasksQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'unassignedTasks'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'unassignedTasks'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleTask'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleTask'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodEnd'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'publicName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'unassignedTasks';

  @override
  List<Object> get props => [document, operationName];
  @override
  UnassignedTasks$Query parse(Map<String, dynamic> json) =>
      UnassignedTasks$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SaveTaskArguments extends JsonSerializable with EquatableMixin {
  SaveTaskArguments({this.createInput, this.updateInput});

  @override
  factory SaveTaskArguments.fromJson(Map<String, dynamic> json) =>
      _$SaveTaskArgumentsFromJson(json);

  final TaskInputCreate createInput;

  final TaskInputUpdate updateInput;

  @override
  List<Object> get props => [createInput, updateInput];
  @override
  Map<String, dynamic> toJson() => _$SaveTaskArgumentsToJson(this);
}

class SaveTaskMutation
    extends GraphQLQuery<SaveTask$Mutation, SaveTaskArguments> {
  SaveTaskMutation({this.variables});

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.mutation,
        name: NameNode(value: 'saveTask'),
        variableDefinitions: [
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'createInput')),
              type: NamedTypeNode(
                  name: NameNode(value: 'TaskInputCreate'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: []),
          VariableDefinitionNode(
              variable: VariableNode(name: NameNode(value: 'updateInput')),
              type: NamedTypeNode(
                  name: NameNode(value: 'TaskInputUpdate'), isNonNull: false),
              defaultValue: DefaultValueNode(value: null),
              directives: [])
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'saveTask'),
              alias: null,
              arguments: [
                ArgumentNode(
                    name: NameNode(value: 'createInput'),
                    value: VariableNode(name: NameNode(value: 'createInput'))),
                ArgumentNode(
                    name: NameNode(value: 'updateInput'),
                    value: VariableNode(name: NameNode(value: 'updateInput')))
              ],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'task'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: SelectionSetNode(selections: [
                      FragmentSpreadNode(
                          name: NameNode(value: 'simpleTask'), directives: [])
                    ]))
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleTask'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodEnd'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'publicName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'saveTask';

  @override
  final SaveTaskArguments variables;

  @override
  List<Object> get props => [document, operationName, variables];
  @override
  SaveTask$Mutation parse(Map<String, dynamic> json) =>
      SaveTask$Mutation.fromJson(json);
}

class AllTodoTasksQuery
    extends GraphQLQuery<AllTodoTasks$Query, JsonSerializable> {
  AllTodoTasksQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'allTodoTasks'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'allTodoTasks'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleTask'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleTask'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodEnd'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'publicName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'allTodoTasks';

  @override
  List<Object> get props => [document, operationName];
  @override
  AllTodoTasks$Query parse(Map<String, dynamic> json) =>
      AllTodoTasks$Query.fromJson(json);
}

class UsersQuery extends GraphQLQuery<Users$Query, JsonSerializable> {
  UsersQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'users'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'users'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleUser'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleUser'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'UserType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'publicName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null)
        ]))
  ]);

  @override
  final String operationName = 'users';

  @override
  List<Object> get props => [document, operationName];
  @override
  Users$Query parse(Map<String, dynamic> json) => Users$Query.fromJson(json);
}

class DoneTasksQuery extends GraphQLQuery<DoneTasks$Query, JsonSerializable> {
  DoneTasksQuery();

  @override
  final DocumentNode document = DocumentNode(definitions: [
    OperationDefinitionNode(
        type: OperationType.query,
        name: NameNode(value: 'doneTasks'),
        variableDefinitions: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'done'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FragmentSpreadNode(
                    name: NameNode(value: 'simpleTask'), directives: [])
              ]))
        ])),
    FragmentDefinitionNode(
        name: NameNode(value: 'simpleTask'),
        typeCondition: TypeConditionNode(
            on: NamedTypeNode(
                name: NameNode(value: 'TaskType'), isNonNull: false)),
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'periodEnd'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'state'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null),
          FieldNode(
              name: NameNode(value: 'user'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: SelectionSetNode(selections: [
                FieldNode(
                    name: NameNode(value: 'publicName'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null)
              ]))
        ]))
  ]);

  @override
  final String operationName = 'doneTasks';

  @override
  List<Object> get props => [document, operationName];
  @override
  DoneTasks$Query parse(Map<String, dynamic> json) =>
      DoneTasks$Query.fromJson(json);
}
