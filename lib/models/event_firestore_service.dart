import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:plane_me/models/auth.dart';
import 'package:plane_me/models/event.dart';
import 'package:plane_me/models/statistics_model.dart';
import 'package:plane_me/todoScreens/todo_event.dart';

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>(
    'users/$userId/calendarEvents',
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());

DatabaseService<EventModel> eventDelete = DatabaseService<EventModel>(
    'users/$userId/calendarEvents',
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());

DatabaseService<StatisticsModel> statisticsDBS =
    DatabaseService<StatisticsModel>('users/$userId/statistics',
        fromDS: (id, data) => StatisticsModel.fromDS(id, data),
        toMap: (event) => event.toMap());

DatabaseService<StatisticsModel> statisticsDelete =
    DatabaseService<StatisticsModel>('users/$userId/statistics',
        fromDS: (id, data) => StatisticsModel.fromDS(id, data),
        toMap: (event) => event.toMap());

DatabaseService<TodoModel> eventTodo = DatabaseService<TodoModel>(
    'users/$userId/ToDo',
    fromDS: (id, data) => TodoModel.fromDS(id, data),
    toMap: (event) => event.toMap());

DatabaseService<TodoModel> todoModelDelete = DatabaseService<TodoModel>(
    'users/$userId/ToDo',
    fromDS: (id, data) => TodoModel.fromDS(id, data),
    toMap: (event) => event.toMap());