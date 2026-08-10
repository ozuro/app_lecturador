import 'package:app_lecturador/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:app_lecturador/features/auth/data/datasources/token_storage.dart';
import 'package:app_lecturador/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app_lecturador/features/auth/presentation/providers/auth_notifier.dart';
import 'package:app_lecturador/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    AuthRepositoryImpl(
      AuthRemoteDataSource(),
      TokenStorage(),
    ),
  );
});
