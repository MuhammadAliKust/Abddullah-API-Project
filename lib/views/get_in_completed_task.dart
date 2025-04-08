import 'package:abdullah_api/models/task_list.dart';
import 'package:abdullah_api/providers/token_provider.dart';
import 'package:abdullah_api/services/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetInCompletedTaskView extends StatelessWidget {
  const GetInCompletedTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Get In Completed Task"),
        ),
        body: FutureProvider.value(
          value: TaskServices().getInCompletedTask(tokenProvider.getToken()),
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
                    title: Text(model.tasks![i].description.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                      ],
                    ),
                  );
                });
          },
        ));
  }
}
