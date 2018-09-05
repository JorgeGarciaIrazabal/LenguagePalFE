import 'package:flutter/material.dart';
import 'package:language_pal/api_clients/lp_client.dart';
import 'package:language_pal/models/model.dart';

enum UserMode { student, teacher }

class UserModel extends Model {
  String email;
  String firstName;
  String lastName;
  String photoPath;

  String get fullName {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return "$firstName $lastName";
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else {
      return '';
    }
  }

  NetworkImage get photoImage {
    return photoPath != null ? new NetworkImage(LPClient.domain + photoPath) : null;
  }

  UserModel({this.email, this.firstName, this.lastName})
      : super.fromMap(null);

  UserModel.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'photo_path': photoPath,
    }..addAll(super.toMap());
  }

  UserModel mergeMap(Map<String, dynamic> map) {
    if (map == null) {
      return this;
    }
    super.mergeMap(map);
    email = map['email'] ?? email;
    firstName = map['first_name'] ?? firstName;
    lastName = map['last_name'] ?? lastName;
    photoPath = map['photo_path'] ?? photoPath;
    return this;
  }
}
