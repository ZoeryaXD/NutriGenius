import 'package:http/http.dart' as http;
import 'package:nutrigenius/core/network/api_client.dart';

abstract class HistoryRemoteDataSource {
  Future<void> deleteHistoryFromServer(int id);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final http.Client client;
  HistoryRemoteDataSourceImpl({required this.client});

  @override
  Future<void> deleteHistoryFromServer(int id) async {
    final url = Uri.parse('${ApiClient.baseUrl}/history/$id');
    final response = await client
        .delete(url, headers: ApiClient.headers)
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus data di server");
    }
  }
}
