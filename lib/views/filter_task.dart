import 'package:abdullah_api/models/task.dart';
import 'package:abdullah_api/models/task_list.dart';
import 'package:abdullah_api/providers/token_provider.dart';
import 'package:abdullah_api/services/task.dart';
import 'package:abdullah_api/views/get_completed_task.dart';
import 'package:abdullah_api/views/get_in_completed_task.dart';
import 'package:abdullah_api/views/task.dart';
import 'package:abdullah_api/views/update_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class FilterTaskView extends StatefulWidget {
  const FilterTaskView({super.key});

  @override
  State<FilterTaskView> createState() => _FilterTaskViewState();
}

class _FilterTaskViewState extends State<FilterTaskView> {
  bool isLoading = false;

  DateTime? firstDate;
  DateTime? secondDate;
  TaskListingModel? taskListingModel;

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Filter Task"),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime.now())
                              .then((val) {
                            firstDate = val;
                            setState(() {});
                          });
                        },
                        child: Text("Pick First Date")),
                    if (firstDate != null)
                      Text(DateFormat.yMMMMEEEEd().format(firstDate!)),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime.now())
                              .then((val) {
                            secondDate = val;
                            setState(() {});
                          });
                        },
                        child: Text("Pick Second Date")),
                    if (secondDate != null)
                      Text(DateFormat.yMMMd().format(secondDate!)),
                  ],
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    isLoading = true;
                    setState(() {});
                    await TaskServices()
                        .filterTask(
                            token: tokenProvider.getToken(),
                            startDate: firstDate.toString(),
                            endDate: secondDate.toString())
                        .then((val) {
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
                child: Text("Apply Filter")),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (taskListingModel == null)
              Center(
                child: Text("Apply Filters"),
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
