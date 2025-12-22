import 'package:flutter/material.dart';
import 'components/weekly_report_card.dart'; // Import widget grafik di atas

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  final List<Map<String, dynamic>> dummyHistory = const [
    {
      'name': 'Nasi Goreng Ayam',
      'cal': 450.5,
      'time': '12:30',
      'img': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Salad Buah',
      'cal': 120.0,
      'time': '08:15',
      'img': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Sate Kambing',
      'cal': 354.0,
      'time': '19:45',
      'img': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        title: const Text(
          "Riwayat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeeklyReportCard(),

            const SizedBox(height: 25),
            const Text(
              "Riwayat Hari Ini",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyHistory.length,
              itemBuilder: (context, index) {
                final item = dummyHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['img'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${item['cal']} kkal"),
                    trailing: Text(
                      item['time'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
