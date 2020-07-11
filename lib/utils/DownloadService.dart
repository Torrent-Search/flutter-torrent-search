import 'dart:async';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static List<TaskInfo> _tasks = [];
  static String _localPath = "";
  static StreamController _streamController =
      StreamController<TaskInfo>.broadcast();

  static void addTask(TaskInfo task) {
    _tasks.add(task);
  }

  static List<TaskInfo> get tasks => _tasks;

  static Stream get stream => _streamController.stream;

  static Stream<TaskInfo> updateData(
      String id, DownloadTaskStatus status, int progress) {
    var task = _tasks?.firstWhere((task) => task.taskId == id);
    if (task != null) {
      task.status = status;
      task.progress = progress;
    }
    if (task.status == DownloadTaskStatus.failed) {
      delete(task, shouldDeleteContent: true);
    }
    _streamController.add(task);
  }

  static set localPath(String path) {
    _localPath = path;
  }

  static String get localPath => _localPath;

  static Future<String> requestDownload(TaskInfo task) async {
    if (!await Permission.storage.isGranted) {
      return "Give Storage permission to Download Song";
    }
    if (checkIfDownloading(task.name)) {
      return "Already Downloading/Paused";
    }
    if (isExist(task.name)) {
      return "Already Downloaded to Internal/Download";
    }

    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        headers: {"auth": "test"},
        savedDir: _localPath,
        showNotification: true,
        fileName: task.name,
        openFileFromNotification: true);
    _tasks.add(task);
    return "Downloading to Internal/Download";
  }

  static void cancelDownload(TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
    _tasks.remove(task);
    _streamController.add(task);
  }

  static void pauseDownload(TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
    _streamController.add(task);
  }

  static void resumeDownload(TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
    _tasks.remove(task);
    _tasks.add(task);
  }

  static void retryDownload(TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
    _tasks.remove(task);
    _tasks.add(task);
  }

  static Future<bool> openDownloadedFile(TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  static void delete(TaskInfo task, {shouldDeleteContent = false}) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: shouldDeleteContent);
    _tasks.remove(task);
    _streamController.add(task);
  }

  static bool isExist(String filename) {
    return File(_localPath + "/" + filename).existsSync();
  }

  static bool checkIfDownloading(String name) {
    TaskInfo task =
        _tasks?.firstWhere((task) => task.name == name, orElse: () => null);
    if (task == null) {
      return false;
    }

    if (task.status == DownloadTaskStatus.running ||
        task.status == DownloadTaskStatus.enqueued ||
        task.status == DownloadTaskStatus.paused) {
      return true;
    }
    return false;
  }

  static void dispose() {
    _streamController.close();
  }
}

class TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  TaskInfo({this.name, this.link});
}
