import '../../data/models/dashboard_model.dart';import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_data_source.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;
  final DashboardRemoteDataSource remoteDataSource; 

  DashboardRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource, 
  });

  @override
  Future<DashboardModel> getDashboardData(String email) async {

    await remoteDataSource.getDashboardData(email);    

    try {
      // 1. Ambil data mentah (Map) dari Remote API
      final remoteData = await remoteDataSource.getDashboardData(email);
      
      // 2. DISINI KUNCINYA! 🔑
      // Kita pakai fromJson milik Model untuk menerjemahkan data secara otomatis.
      // (full_name -> displayName, convert angka, dll sudah diurus di sini)
      return DashboardModel.fromJson(remoteData);

    } catch (e) {
      // Error handling sederhana
      throw Exception("Gagal ambil data dashboard: $e");
    }
  }
}