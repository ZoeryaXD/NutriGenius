import 'package:get_it/get_it.dart';
import 'core/usecases/db_helper.dart';
import 'features/history/presentation/bloc/history_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  sl.registerFactory(() => HistoryBloc(sl()));
}
