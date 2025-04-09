import 'package:abdullah_api/models/task.dart';
import 'package:abdullah_api/models/task_list.dart';
import 'package:abdullah_api/providers/token_provider.dart';
import 'package:abdullah_api/services/task.dart';
import 'package:abdullah_api/views/get_completed_task.dart';
import 'package:abdullah_api/views/get_in_completed_task.dart';
import 'package:abdullah_api/views/task.dart';
import 'package:abdullah_api/views/update_task.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class SearchTaskView extends StatefulWidget {
  const SearchTaskView({super.key});

  @override
  State<SearchTaskView> createState() => _SearchTaskViewState();
}

class _SearchTaskViewState extends State<SearchTaskView> {
  bool isLoading = false;

  TextEditingController searchController = TextEditingController();

  TaskListingModel? taskListingModel;

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Task"),
        ),
        body: Column(
          children: [
            TextFormField(
              controller: searchController,
              onChanged: (val) async {
                try {
                  isLoading = true;
                  setState(() {});
                  await TaskServices()
                      .searchTask(
                          token: tokenProvider.getToken(), searchKey: val)
                      .then((val) {
                    isLoading = false;
                    setState(() {});
                    taskListingModel = val;
                    setState(() {});
                  });
                } catch (e) {
                  isLoading = false;
                  setState(() {});
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (taskListingModel == null)
              Center(
                child: Text("Type something to search"),
              )
            else if (taskListingModel!.tasks!.isEmpty)
              Center(
                child: Text(
                    "Sorry! We cannot find any data relevant to your search"),
              )
            else
              Expanded(
                child: ListView.builder(
                    itemCount: taskListingModel!.tasks!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Icon(Icons.task),
                        title: Text(
                            taskListingModel!.tasks![i].description.toString()),
                      );
                    }),
              ),
          ],
        ));
  }
}
