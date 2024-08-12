import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_bap/helpers/api_helper.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc() : super(TaskListInitial()) {
    on<GetTasksEvent>((event, emit) async {
      emit(TaskListLoading());
      // Call the API to get the tasks
      final response =
          await Api.callApi(ApiEndpoints.getTasks, {'token': 'usuario123'});
      if (response.success) {
        emit(GetTasksSuccess(tasks: response.data));
      } else {
        emit(TaskListError(message: response.message));
      }
    });

    on<GetTaskEvent>((event, emit) async {
      emit(TaskListLoading());
      // Call the API to get the task
      final response = await Api.callApi(ApiEndpoints.getTask,
          {'token': 'usuario123', 'task_id': event.taskId});
      if (response.success) {
        emit(GetTaskSuccess(tasks: response.data));
      } else {
        emit(TaskListError(message: response.message));
      }
    });

    on<CreateTaskEvent>((event, emit) async {
      emit(TaskListLoading());
      // Call the API to create the task
      final response = await Api.callApi(ApiEndpoints.createTask, {
        'token': 'usuario123',
        'title': event.title,
        'is_completed': "0",
        'description': event.description,
        'comment': event.comment,
        'tags': event.tags,
        'selectedDate': event.selectedDate,
      });
      if (response.success) {
        emit(CreateTaskSuccess());
      } else {
        emit(TaskListError(message: response.message));
      }
    });

    on<UpdateTaskEvent>((event, emit) async {
      emit(TaskListLoading());
      // Call the API to update the task
      final response = await Api.callApi(ApiEndpoints.updateTask, {
        'token': 'usuario123',
        'task_id': event.taskId,
        'description': event.description,
        'comment': event.comment,
        'tags': event.tags,
        'selectedDate': event.selectedDate,
      });
      if (response.success) {
        emit(UpdateTaskSuccess());
      } else {
        emit(TaskListError(message: response.message));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      emit(TaskListLoading());
      // Call the API to delete the task
      final response = await Api.callApi(ApiEndpoints.deleteTask,
          {'token': 'usuario123', 'task_id': event.taskId});
      if (response.success) {
        emit(DeleteTaskSuccess());
      } else {
        emit(TaskListError(message: response.message));
      }
    });
  }
}
