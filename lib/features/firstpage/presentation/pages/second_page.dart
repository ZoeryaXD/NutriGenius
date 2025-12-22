import 'package:flutter/material.dart';
import 'third_page.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // --- Data & State Variables ---
  
  // Pilihan Aktivitas
  final List<String> _activities = [
    "Light Active (Olahraga 1-3x/minggu)",
    "Sedentary (Duduk seharian/Office)",
    "Active (Olahraga 3-5x/minggu)",
    "Very Active (Fisik berat/Atlet)",
  ];

  // Variable untuk menyimpan aktivitas yang dipilih (Awalnya null)
  String? _selectedActivity;

  // Pilihan Tujuan
  final List<String> _goals = [
    "Pasien Diabetes",
    "Diet Sehat",
    "Bulking (Menaikkan Massa Otot)",
    "Cutting (Menurunkan Lemak)"
  ];

  // Variable untuk menyimpan tujuan yang dipilih (Awalnya null)
  String? _selectedGoal;

  // Warna
  final Color primaryGreen = const Color(0xFF2E7D32);
  final Color inactiveGrey = const Color(0xFFE0E0E0);
  final Color textGrey = const Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Langkah 2 dari 3",
          style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Seberapa aktif keseharianmu?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 30),

            // --- List Pilihan Aktivitas ---
            // Kita generate tombol berdasarkan list _activities
            ..._activities.map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildActivityButton(activity),
              );
            }).toList(),

            const SizedBox(height: 30),
            
            // --- Dropdown Tujuan ---
            Text(
              "Tujuan Kamu:", 
              style: TextStyle(fontSize: 16, color: Colors.green[800], fontWeight: FontWeight.w500)
            ),
            const SizedBox(height: 10),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                // Logic: Jika belum ada yang dipilih (_selectedGoal null) -> Abu-abu.
                // Jika sudah ada -> Hijau.
                color: _selectedGoal == null ? inactiveGrey : primaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGoal,
                  hint: Text(
                    "Pilih Tujuan...",
                    style: TextStyle(color: textGrey, fontSize: 16),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down, 
                    // Icon putih jika background hijau, abu tua jika background abu
                    color: _selectedGoal == null ? textGrey : Colors.white
                  ),
                  dropdownColor: primaryGreen, // Warna menu saat dibuka tetap hijau agar konsisten
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGoal = newValue;
                    });
                  },
                  // Mapping list tujuan menjadi DropdownMenuItem
                  items: _goals.map((goal) {
                    return DropdownMenuItem(
                      value: goal,
                      child: Row(
                        children: [
                          // Kita ubah warna icon & text di dalam list menu
                          // Note: Saat menu terbuka, itemnya akan menggunakan style bawaan dropdown
                          // atau kita force warna putih karena dropdownColor kita set hijau.
                          const Icon(Icons.flag, color: Colors.white), 
                          const SizedBox(width: 10),
                          Text(goal, style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const Spacer(),
            
             // Tombol Lanjut (Hitung Nutrisi)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Validasi sederhana: Pastikan keduanya sudah dipilih
                  if (_selectedActivity != null && _selectedGoal != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ThirdPage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mohon pilih aktivitas dan tujuan kamu dulu.")),
                    );
                  }
                },
                child: const Text("Hitung Nutrisi", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Tombol Aktivitas
  Widget _buildActivityButton(String text) {
    bool isSelected = _selectedActivity == text;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActivity = text;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Efek animasi halus saat berubah warna
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          // Logic warna: Selected -> Hijau, Unselected -> Abu
          color: isSelected ? primaryGreen : inactiveGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : textGrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}