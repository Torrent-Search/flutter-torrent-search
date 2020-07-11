import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:torrentsearch/utils/DownloadService.dart';

class DownloadInfo extends StatefulWidget {
  @override
  _DownloadInfoState createState() => _DownloadInfoState();
}

class _DownloadInfoState extends State<DownloadInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Downloads',
          style: TextStyle(
            letterSpacing: 3.0,
            fontFamily: "OpenSans",
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: StreamBuilder(
          stream: DownloadService.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return DownloadService.tasks.length > 0
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: DownloadService.tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final TaskInfo taskInfo = DownloadService.tasks[index];
                      final String statusString =
                          getDownloadStatus(taskInfo.status);
                      return ListTile(
                        onTap: () {
                          if (taskInfo.progress == 100 &&
                              DownloadService.isExist(taskInfo.name)) {
                            DownloadService.openDownloadedFile(taskInfo);
                          }
                        },
                        title: Text(
                          taskInfo.name,
                        ),
                        subtitle: taskInfo.progress == 100
                            ? Text("Downloade Complete")
                            : (statusString == "Running"
                                ? Text("Downloaded : ${taskInfo.progress}%")
                                : Text(
                                    statusString,
                                  )),
                        trailing:
                            taskInfo.progress == 100 && statusString != "Failed"
                                ? _buildDeletButton(taskInfo)
                                : statusString == "Paused"
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            onPressed: () {
                                              if (taskInfo.progress != 100)
                                                DownloadService.resumeDownload(
                                                    taskInfo);
                                            },
                                          ),
                                          _buildDeletButton(taskInfo),
                                        ],
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.pause),
                                            onPressed: () {
                                              if (taskInfo.progress != 100)
                                                DownloadService.pauseDownload(
                                                    taskInfo);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.cancel),
                                            onPressed: () {
                                              if (taskInfo.progress != 100)
                                                DownloadService.cancelDownload(
                                                    taskInfo);
                                            },
                                          ),
                                        ],
                                      ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.cancel,
                        size: 50.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "No Downloads",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ));
            ;
            ;
          },
        ),
      ),
    );
  }

  String getDownloadStatus(DownloadTaskStatus status) {
    switch (status.toString()) {
      case "DownloadTaskStatus(0)":
        return "Undefined";
      case "DownloadTaskStatus(1)":
        return "Enqueued";
      case "DownloadTaskStatus(2)":
        return "Running";
      case "DownloadTaskStatus(3)":
        return "Complete";
      case "DownloadTaskStatus(4)":
        return "Failed";
      case "DownloadTaskStatus(5)":
        return "Canceled";
      case "DownloadTaskStatus(6)":
        return "Paused";
    }
  }

  Widget _buildDeletButton(TaskInfo info) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Delete"),
            content: Text("Delete File too ?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  DownloadService.delete(info, shouldDeleteContent: true);
                  Navigator.pop(context);
                },
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: () {
                  DownloadService.delete(info);
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
            ],
          ),
        );
      },
    );
  }
}
