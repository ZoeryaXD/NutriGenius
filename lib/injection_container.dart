import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutrigenius/core/usecases/database_helper.dart';

import 'package:nutrigenius/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:nutrigenius/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nutrigenius/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:nutrigenius/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import 'package:nutrigenius/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nutrigenius/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:nutrigenius/features/profile/domain/repositories/profile_repository.dart';
import 'package:nutrigenius/features/profile/presentation/bloc/profile_bloc.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/firstpage/data/datasources/firstpage_remote_data_source.dart';
import 'features/firstpage/data/repositories/firstpage_repository_impl.dart';
import 'features/firstpage/domain/repositories/firstpage_repository.dart';
import 'features/firstpage/presentation/bloc/firstpage_bloc.dart';
import 'features/firstpage/domain/usecase/calculate_tdee.dart';
import 'features/history/data/datasources/history_local_data_source.dart';
import 'features/history/data/datasources/history_remote_data_source.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/domain/usecases/add_food_usecase.dart';
import 'features/history/domain/usecases/delete_history_usecase.dart';
import 'features/history/domain/usecases/get_history_usecase.dart';
import 'features/history/presentation/bloc/history_bloc.dart';

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
    () => FirstPageRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<FirstpageRemoteDataSource>(
    () => FirstpageRemoteDataSourceImpl(client: sl()),
  );

  // ==========================
  // ! 3. FITUR DASHBOARD
  // ==========================
  // BLoC
  sl.registerFactory(() => DashboardBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(client: sl()),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(client: sl()),
  );

  // ==========================
  // ! 4. FITUR PROFILE
  // ==========================
  // Datasource
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Bloc
  sl.registerFactory(() => ProfileBloc(repository: sl()));

    // ==========================
  // ! 4. FITUR HISTORY
  // ==========================

  // 1. Data Sources
  sl.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<HistoryRemoteDataSource>(
    () => HistoryRemoteDataSourceImpl(client: sl()),
  );

  // 2. Repository
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // 3. Use Cases
  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));
  sl.registerLazySingleton(() => AddFoodUseCase(sl()));
  sl.registerLazySingleton(() => DeleteHistoryUseCase(sl()));

  // 4. Bloc
  sl.registerFactory(
    () => HistoryBloc(getHistory: sl(), addFood: sl(), deleteHistory: sl()),
  );

  // ! External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
