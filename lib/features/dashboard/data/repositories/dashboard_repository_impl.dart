import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_local_data_source.dart';
import '../datasources/dashboard_remote_data_source.dart'; // Import Remote

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;
  final DashboardRemoteDataSource remoteDataSource; // Tambahan

  DashboardRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource, // Tambahan
  });

  @override
  Future<DashboardEntity> loadDashboardData() async {
    // 1. Coba ambil dari SQLite (Lokal)
    Map<String, dynamic> data = await localDataSource.getData();
    
    // 2. Jika data lokal tidak ditemukan (found == false), coba ambil dari Server (Remote)
    if (data['found'] == false) {
      try {
        final email = FirebaseAuth.instance.currentUser?.email;
        if (email != null) {
          // Ambil dari API
          final remoteData = await remoteDataSource.getDashboardData(email);
          
          // Simpan ke SQLite untuk penggunaan berikutnya
          await localDataSource.cacheData(remoteData);
          
          // Update variabel data dengan hasil dari remote
          data = {
            'name': remoteData['displayName'],
            'tdee': remoteData['tdee'],
          };
        }
      } catch (e) {
        // Jika internet mati & lokal kosong, biarkan pakai default (2000 kkal)
        print("Gagal ambil remote: $e");
      }
    }

    // 3. Kembalikan Entity ke UI
    return DashboardEntity(
      displayName: data['name'],
      tdee: (data['tdee'] as num).toDouble(), // Cast ke double agar aman
      caloriesConsumed: 0,
    );
  }
}