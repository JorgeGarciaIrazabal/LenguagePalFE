import 'package:scoped_model/scoped_model.dart';

class StatefulDialogState extends Model {
  bool _loading = false;
  String _errorMessage = '';

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }
}