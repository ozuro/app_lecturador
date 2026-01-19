import 'package:app_lecturador/data/local/token_storage.dart';
import 'package:app_lecturador/data/data_sources/services/auth_remote_data_sources.dart';
import 'package:app_lecturador/domain/reporsitories/auth_repository.dart';

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
