import 'package:app_lecturador/data/local/token_storage.dart';
import 'package:app_lecturador/data/data_sources/auth_remote_data_sources.dart';
import 'package:app_lecturador/presentation/providers/auth_state.dart';
import 'package:app_lecturador/data/data_sources/repository/auth_repository_impl.dart';
import 'package:app_lecturador/presentation/providers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    AuthRepositoryImpl(
      AuthRemoteDataSource(),
      TokenStorage(),
    ),
  );
});
