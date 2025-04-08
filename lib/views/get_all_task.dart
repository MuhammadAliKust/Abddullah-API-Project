import 'package:abdullah_api/models/task_list.dart';
import 'package:abdullah_api/providers/token_provider.dart';
import 'package:abdullah_api/services/task.dart';
import 'package:abdullah_api/views/get_completed_task.dart';
import 'package:abdullah_api/views/get_in_completed_task.dart';
import 'package:abdullah_api/views/task.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class GetAllTaskView extends StatefulWidget {
  const GetAllTaskView({super.key});

  @override
  State<GetAllTaskView> createState() => _GetAllTaskViewState();
}

class _GetAllTaskViewState extends State<GetAllTaskView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Get All Task"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GetInCompletedTaskView()));
                },
                icon: Icon(Icons.incomplete_circle)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GetCompletedTaskView()));
                },
                icon: Icon(Icons.circle)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateTaskView()));
          },
          child: Icon(Icons.add),
        ),
        body: LoadingOverlay(
          isLoading: isLoading,
          progressIndicator: CircularProgressIndicator(),
          child: FutureProvider.value(
            value: TaskServices().getAllTask(tokenProvider.getToken()),
            initialData: TaskListingModel(),
            builder: (context, child) {
              TaskListingModel model = context.watch<TaskListingModel>();
              return model.tasks == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : model.tasks!.isEmpty
                      ? Center(
                          child: Text("No Task Found"),
                        )
                      : ListView.builder(
                          itemCount: model.tasks!.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: Icon(Icons.task),
                              title:
                                  Text(model.tasks![i].description.toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        try {
                                          isLoading = true;
                                          setState(() {});
                                          await TaskServices()
                                              .deleteTask(
                                                  taskID: model.tasks![i].id
                                                      .toString(),
                                                  token:
                                                      tokenProvider.getToken())
                                              .then((val) {

                                            isLoading = false;
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text('Task has been deleted successfully')));
                                          });
                                        } catch (e) {
                                          isLoading = false;
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(e.toString())));
                                        }
                                      },
                                      icon: Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () {}, icon: Icon(Icons.edit)),
                                ],
                              ),
                            );
                          });
            },
          ),
        ));
  }
}
