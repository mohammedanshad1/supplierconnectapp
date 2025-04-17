// lib/domain/usecases/login_usecase.dart
import 'package:supplierconnectapp/data/repository/auth_repository.dart';

import '../../data/models/login_model.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<LoginModel> execute(String username, String password) async {
    return await repository.login(username, password);
  }
}