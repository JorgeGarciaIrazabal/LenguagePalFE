import 'dart:async';

import 'package:language_pal/api_clients/lp_client.dart';
import 'package:language_pal/models/user.dart';

class _AuthApi extends LPClient {
  Future<LPResponse> login({String email, String password}) async {
    return post('auth/login/', body: {'email': email, 'password': password});
  }

  Future<LPResponse> signUp({String email, String password}) async {
    return post('auth/signup/', body: {'email': email, 'password': password});
  }

  Future<UserModel> uploadPhoto(String path) async {
    assert(path != null);

    var response = await this.uploadFile(
      'auth/photo/',
      path: path,
    );
    return UserModel.fromMap(response.body['data']);
  }
}

_AuthApi _authApi;

_AuthApi getAuthApi() {
  if (_authApi == null) {
    _authApi = new _AuthApi();
  }
  return _authApi;
}
