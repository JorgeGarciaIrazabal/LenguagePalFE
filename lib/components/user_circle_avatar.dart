import 'package:flutter/material.dart';
import 'package:language_pal/models/user.dart';
import 'package:meta/meta.dart';

class UserCircleAvatar extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTab;
  final double radius;

  UserCircleAvatar({@required this.user, this.onTab, this.radius = 30.0});

  Text getAvatarText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String initials = '';
    if (this.user.firstName.isNotEmpty && this.user.lastName.isNotEmpty) {
      initials = this.user.firstName.substring(0, 1) + this.user.lastName.substring(0, 1);
    } else if (this.user.lastName.isNotEmpty) {
      initials = this.user.firstName.substring(0, 2);
    } else if (this.user.email != null) {
      initials = this.user.email.substring(0, 2);
    }
    return new Text(
      initials.toUpperCase(),
      style: textTheme.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new CircleAvatar(
        radius: radius,
        backgroundImage: user.photoImage,
        child: user.photoPath != null ? null : this.getAvatarText(context),
      ),
      onTap: onTab,
    );
  }
}
