import 'package:app_lecturador/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app_lecturador/features/auth/data/datasources/token_storage.dart';
import 'package:app_lecturador/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final TokenStorage storage;

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<void> login(String email, String password) async {
    final token = await remote.login(email, password);
    await storage.saveToken(token);
  }

  @override
  Future<void> logout() async {
    await storage.clear();
  }
}
