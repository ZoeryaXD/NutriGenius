import 'package:nutrigenius/features/dashboard/data/models/dashboard_model.dart';

abstract class DashboardRepository {
  Future<DashboardModel> getDashboardData(String email);
}