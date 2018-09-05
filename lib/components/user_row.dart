import 'package:flutter/material.dart';
import 'package:language_pal/components/user_circle_avatar.dart';
import 'package:language_pal/models/user.dart';
import 'package:meta/meta.dart';

class UserRow extends StatelessWidget {
  final UserModel user;
  final GestureTapCallback onTab;

  UserRow({@required this.user, this.onTab});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: this.onTab,
      key: new Key(user.email),
      leading: new UserCircleAvatar(
        user: user,
      ),
      title: new Text(user.fullName),
      subtitle: new Text(user.email),
    );
  }
}
