import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

// Core
import 'package:nutrigenius/core/usecases/db_helper.dart';

// Fitur Auth
import 'package:nutrigenius/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nutrigenius/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nutrigenius/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutrigenius/features/auth/presentation/bloc/auth_bloc.dart';

// Fitur FirstPage (Onboarding)
import 'package:nutrigenius/features/firstpage/data/datasources/firstpage_local_remote_data_source.dart';
import 'package:nutrigenius/features/firstpage/data/datasources/firstpage_remote_data_source.dart';
import 'package:nutrigenius/features/firstpage/data/repositories/firstpage_repository_impl.dart';
import 'package:nutrigenius/features/firstpage/domain/repositories/firstpage_repository.dart';
import 'package:nutrigenius/features/firstpage/presentation/bloc/firstpage_bloc.dart';
import 'package:nutrigenius/features/firstpage/domain/usecase/calculate_tdee.dart';

// Fitur Dashboard
import 'package:nutrigenius/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:nutrigenius/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:nutrigenius/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nutrigenius/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:nutrigenius/features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Fitur History
import 'package:nutrigenius/features/history/presentation/bloc/history_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ==========================
  // ! 1. FITUR AUTH
  // ==========================
  sl.registerFactory(() => AuthBloc(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), client: sl()),
  );

  // ==========================
  // ! 2. FITUR FIRSTPAGE (ONBOARDING)
  // ==========================
  sl.registerFactory(
    () => FirstPageBloc(calculateTDEE: sl(), repository: sl()),
  );

  sl.registerLazySingleton(() => CalculateTDEE());

  sl.registerLazySingleton<FirstPageRepository>(
    () =>
        FirstPageRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<FirstpageRemoteDataSource>(
    () => FirstpageRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<FirstPageLocalDataSource>(
    () => FirstPageLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ==========================
  // ! 3. FITUR DASHBOARD
  // ==========================
  sl.registerFactory(() => DashboardBloc(repository: sl(), firebaseAuth: sl()));

  sl.registerLazySingleton<DashboardRepository>(
    () =>
        DashboardRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<DashboardLocalDataSource>(
    () =>
        DashboardLocalDataSourceImpl(databaseHelper: sl(), firebaseAuth: sl()),
  );

  // ==========================
  // ! 4. FITUR HISTORY (Tambahan Royhan)
  // ==========================
  sl.registerFactory(() => HistoryBloc(sl())); // Inject DatabaseHelper otomatis

  // ==========================
  // ! EXTERNAL
  // ==========================
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
