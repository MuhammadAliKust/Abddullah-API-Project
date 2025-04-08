import 'dart:convert';

import 'package:abdullah_api/models/task.dart';
import 'package:abdullah_api/models/task_list.dart';
import 'package:http/http.dart' as http;

class TaskServices {
  String baseUrl = "https://todo-nu-plum-19.vercel.app/";

  ///Add Task
  Future<TaskModel> addTask(
      {required String description, required String token}) async {
    try {
      http.Response response = await http.post(Uri.parse("${baseUrl}todos/add"),
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: jsonEncode({"description": description}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Get All Task
  Future<TaskListingModel> getAllTask(String token) async {
    try {
      http.Response response = await http.get(Uri.parse("${baseUrl}todos/get"),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Get Completed Task
  Future<TaskListingModel> getCompletedTask(String token) async {
    try {
      http.Response response = await http.get(
          Uri.parse("${baseUrl}todos/completed"),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Get InCompleted Task
  Future<TaskListingModel> getInCompletedTask(String token) async {
    try {
      http.Response response = await http.get(
          Uri.parse("${baseUrl}todos/incomplete"),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Update Task
  ///Delete Task
  Future<bool> deleteTask(
      {required String taskID, required String token}) async {
    try {
      http.Response response = await http.delete(
          Uri.parse("${baseUrl}todos/delete/$taskID"),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Search Task
  Future<TaskListingModel> searchTask(
      {required String token, required String searchKey}) async {
    try {
      http.Response response = await http.get(
          Uri.parse("${baseUrl}todos/search?keywords=$searchKey"),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Filter Task
  Future<TaskListingModel> filterTask(
      {required String token,
      required String startDate,
      required String endDate}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              "${baseUrl}todos/filter?startDate=$startDate&endDate=$endDate"),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      rethrow;
    }
  }
}
