import 'package:abdullah_api/models/user.dart';
import 'package:abdullah_api/providers/token_provider.dart';
import 'package:abdullah_api/services/auth.dart';
import 'package:abdullah_api/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfileView extends StatefulWidget {
  final UserModel model;

  UpdateProfileView({super.key, required this.model});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    nameController =
        TextEditingController(text: widget.model.user!.name.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
          ),
          SizedBox(
            height: 20,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Name cannot be empty.")));
                      return;
                    }
                    try {
                      isLoading = true;
                      setState(() {});
                      await AuthServices()
                          .updateProfile(
                              token: tokenProvider.getToken().toString(),
                              name: nameController.text)
                          .then((val) {
                        isLoading = false;
                        setState(() {});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileView()));
                      });
                    } catch (e) {
                      isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Update Profile"))
        ],
      ),
    );
  }
}
