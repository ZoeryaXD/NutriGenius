import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrigenius/core/usecases/database_helper.dart';
import 'package:nutrigenius/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:nutrigenius/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:nutrigenius/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nutrigenius/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:nutrigenius/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:nutrigenius/features/firstpage/data/datasources/firstpage_local_remote_data_source.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/firstpage/data/datasources/firstpage_remote_data_source.dart';
import 'features/firstpage/data/repositories/firstpage_repository_impl.dart';
import 'features/firstpage/domain/repositories/firstpage_repository.dart';
import 'features/firstpage/presentation/bloc/firstpage_bloc.dart';
import 'features/firstpage/domain/usecase/calculate_tdee.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================
  // ! 1. FITUR AUTH
  // ==========================
  sl.registerFactory(() => AuthBloc(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), client: sl()),
  );

  // ==========================
  // ! 2. FITUR FIRSTPAGE (ONBOARDING)
  // ==========================
  sl.registerFactory(
    () => FirstPageBloc(calculateTDEE: sl(), repository: sl()),
  );

  // Use Case
  sl.registerLazySingleton(() => CalculateTDEE());

  // Repository
  sl.registerLazySingleton<FirstPageRepository>(
    () =>
        FirstPageRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<FirstpageRemoteDataSource>(
    () => FirstpageRemoteDataSourceImpl(client: sl()),
  );

  // Local Data Source
  sl.registerLazySingleton<FirstPageLocalDataSource>(
    () => FirstPageLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ==========================
  // ! 3. FITUR DASHBOARD
  // ==========================
  // BLoC
  sl.registerFactory(() => DashboardBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () =>
        DashboardRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );

  // Data Source Lokal
  sl.registerLazySingleton<DashboardLocalDataSource>(
    () =>
        DashboardLocalDataSourceImpl(databaseHelper: sl(), firebaseAuth: sl()),
  );

  // ! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
