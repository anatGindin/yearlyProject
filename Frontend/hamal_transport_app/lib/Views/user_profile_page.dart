import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';

class UserProfilePage extends StatelessWidget {
  final UserProfileViewModel userProfileVM;
  const UserProfilePage({required this.userProfileVM, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userProfileVM.name()), centerTitle: true),
    );
  }
}
