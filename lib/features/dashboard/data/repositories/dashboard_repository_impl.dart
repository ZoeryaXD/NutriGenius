import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  DashboardRepositoryImpl({required this.localDataSource});

  @override
  Future<DashboardEntity> loadDashboardData() async {
    final data = await localDataSource.getData();
    
    return DashboardEntity(
      displayName: data['name'],
      tdee: data['tdee'],
      caloriesConsumed: 0, // Sementara 0, nanti diambil dari tabel food_log
    );
  }
}