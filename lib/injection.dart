import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart'; // Akan dibuat nanti

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    remoteDataSource: sl(),
  ));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(FirebaseAuth.instance),
  );

  //! Core
  // (Tidak perlu client http untuk auth)

  //! External
  // Firebase sudah diinisialisasi di main.dart
}