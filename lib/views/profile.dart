import 'package:abdullah_api/models/user.dart';
import 'package:abdullah_api/providers/token_provider.dart';
import 'package:abdullah_api/services/auth.dart';
import 'package:abdullah_api/views/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureProvider.value(
          value: AuthServices().getProfile(tokenProvider.getToken().toString()),
          initialData: UserModel(),
          builder: (context, child) {
            UserModel userModel = context.watch<UserModel>();
            return userModel.user == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Text(
                        "Name: ${userModel.user!.name.toString()}",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProfileView(model: userModel)));
                          },
                          child: Text("Update Profile"))
                    ],
                  );
          }),
    );
  }
}
