import 'package:language_pal/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class StatefulDrawerState extends Model {
  UserModel _user;

  UserModel get user => _user;

  set user(UserModel value) {
    _user = value;
    notifyListeners();
  }

  StatefulDrawerState(this._user);
}