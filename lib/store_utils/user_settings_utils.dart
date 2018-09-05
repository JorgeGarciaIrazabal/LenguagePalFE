import 'dart:async';
import 'dart:convert';

import 'package:language_pal/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USER_KEY = 'user__';
const TOKEN_KEY = 'token__';

class UserSettingUtils {
  static UserSettingUtils _instance;
  UserModel self;
  String token;
  SharedPreferences _prefs;

  static Future<UserSettingUtils> getAsyncInstance() async {
    if (_instance == null) {
      _instance = new UserSettingUtils();
      _instance._prefs = await SharedPreferences.getInstance();
      _instance.self = _instance.getUserFromLocal();
      _instance.token = instance.getTokenFromLocal();
    }
    return _instance;
  }

  static UserSettingUtils get instance {
    if (_instance == null) {
      throw new AssertionError('UserSettingUtils has not been initialized');
    }
    return _instance;
  }

  UserModel getUserFromLocal() {
    String encodedSettings = this._prefs.getString(USER_KEY) ?? null;
    if (encodedSettings == null) {
      return null;
    }
    return new UserModel.fromMap(json.decode(encodedSettings));
  }

  UserModel persistUser(UserModel user) {
    user.updatedAt = new DateTime.now();
    self = user;

    String encodedSettings = json.encode(user.toMap());
    _prefs.setString(USER_KEY, encodedSettings);
    return user;
  }

  UserModel mergeUserWithLocal(Map toUpdate) {
    UserModel user = this.getUserFromLocal();
    user.mergeMap(toUpdate);
    this.persistUser(user);
    return user;
  }

  String getTokenFromLocal() {
    return this._prefs.getString(TOKEN_KEY) ?? null;
  }

  void persistToken(String token) {
    this._prefs.setString(TOKEN_KEY, token);
    this.token = token;
  }

  clear() {
    this.token = null;
    this.self = null;
    this._prefs.remove(USER_KEY);
    this._prefs.remove(TOKEN_KEY);
  }
}

UserSettingUtils getSettings() {
  return UserSettingUtils.instance;
}
