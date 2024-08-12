part of 'task_list_bloc.dart';

@immutable
class TaskListState {}

class TaskListInitial extends TaskListState {}

class TaskListLoading extends TaskListState {}

class GetTasksSuccess extends TaskListState {
  final List<dynamic> tasks;

  GetTasksSuccess({required this.tasks});
}

class GetTaskSuccess extends TaskListState {
  final List<dynamic> tasks;

  GetTaskSuccess({required this.tasks});
}

class CreateTaskSuccess extends TaskListState {}

class UpdateTaskSuccess extends TaskListState {}

class DeleteTaskSuccess extends TaskListState {}

class TaskListError extends TaskListState {
  final String message;

  TaskListError({required this.message});
}
