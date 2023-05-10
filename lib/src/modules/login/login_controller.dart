import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../core/exceptions/unauthorized_exception.dart';
import '../../services/login_service.dart';
part 'login_controller.g.dart';

enum LoginStateStatus {
  inital,
  loading,
  success,
  error;
}

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final LoginService _loginService;

  LoginControllerBase(
    this._loginService,
  );

  @readonly
  var _loginStatus = LoginStateStatus.inital;

  @readonly
  String? _errorMessage;

  @action
  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      _loginStatus = LoginStateStatus.loading;
      await _loginService.execute(
        email,
        password,
      );
      _loginStatus = LoginStateStatus.success;
    } on UnauthorizedException {
      _errorMessage = 'Login ou senha inválidos';
      _loginStatus = LoginStateStatus.error;
    } catch (e, s) {
      log(
        'Erro ao realizar o login',
        error: e,
        stackTrace: s,
      );
      _errorMessage = 'Tente novamente mais tarde';
      _loginStatus = LoginStateStatus.error;
    }
  }
}
