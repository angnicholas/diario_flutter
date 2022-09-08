import 'package:http/http.dart' as http;
import '../services/login.dart';
import '../models/user.dart';

sendRequestWithAuth(method, url, body_constructor, next) async {
  LoginService().getUser().then((value) {
    method(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${value!.accessToken}',
      },
      body: body_constructor(value),
    ).then(next);
  });
}

sendRequestWithAuthNoBody(method, url, next) async {
  LoginService().getUser().then((value) {
    method(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${value!.accessToken}',
      },
    ).then(next);
  });
}
