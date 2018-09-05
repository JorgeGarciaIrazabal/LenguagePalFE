class LoginPageState {
  String _email = '';
  String _password = '';
  bool _loading = false;

  final notifyListeners;

  LoginPageState(this.notifyListeners);

  String get email => _email;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }
}