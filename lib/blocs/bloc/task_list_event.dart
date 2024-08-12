part of 'task_list_bloc.dart';

@immutable
class TaskListEvent {}

class GetTasksEvent extends TaskListEvent {}

class GetTaskEvent extends TaskListEvent {
  final String taskId;

  GetTaskEvent({required this.taskId});
}

class CreateTaskEvent extends TaskListEvent {
  final String title;
  final String? description;
  final String? comment;
  final String? tags;
  final String? selectedDate;

  CreateTaskEvent({
    required this.title,
    this.description,
    this.comment,
    this.tags,
    this.selectedDate,
  });
}

class UpdateTaskEvent extends TaskListEvent {
  final String taskId;
  final String description;
  final String comment;
  final List<String> tags;
  final DateTime? selectedDate;

  UpdateTaskEvent({
    required this.taskId,
    required this.description,
    required this.comment,
    required this.tags,
    required this.selectedDate,
  });
}

class DeleteTaskEvent extends TaskListEvent {
  final String taskId;

  DeleteTaskEvent({required this.taskId});
}
