import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pastikan package intl sudah ada di pubspec.yaml untuk format tanggal
import 'second_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // --- Variables & Controllers ---
  String? _selectedGender; // 'Laki-Laki' atau 'Perempuan'
  
  // Controller untuk input text
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  
  DateTime? _selectedDate;
  int? _age;

  // Warna Konsisten
  final Color primaryGreen = const Color(0xFF2E7D32);
  final Color inactiveGrey = const Color(0xFFE0E0E0);
  final Color textGrey = const Color(0xFF757575);

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // --- Logic: Date Picker & Age Calculation ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen, 
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _calculateAge(picked);
      });
    }
  }

  void _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    setState(() {
      _age = age;
    });
  }

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
          "Langkah 1 dari 3",
          style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Halo! Yuk Kenalan Dulu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 8),
            Text(
              "Data ini membantu kami menghitung kebutuhan tubuhmu.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),

            // --- 1. Jenis Kelamin (Selection Buttons) ---
            _buildLabel("Jenis Kelamin:"),
            Row(
              children: [
                Expanded(
                  child: _buildGenderButton("Laki-Laki", Icons.male),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGenderButton("Perempuan", Icons.female),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- 2. Berat & Tinggi Badan (Input Text) ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Berat Badan:"),
                      _buildNumberInput(_weightController, "Kg"),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Tinggi Badan:"),
                      _buildNumberInput(_heightController, "Cm"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- 3. Tanggal Lahir (Date Picker) ---
            _buildLabel("Tanggal Lahir:"),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // Logic: Jika belum dipilih -> Abu-abu, Jika sudah -> Hijau
                  color: _selectedDate == null ? inactiveGrey : primaryGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today, 
                      color: _selectedDate == null ? textGrey : Colors.white
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDate == null 
                          ? "Pilih Tanggal" 
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: TextStyle(
                        color: _selectedDate == null ? textGrey : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- 4. Usia (Auto Calculated) ---
            _buildLabel("Usia:"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: _age == null ? inactiveGrey : primaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _age == null ? "-" : "$_age Tahun",
                style: TextStyle(
                  color: _age == null ? textGrey : Colors.white, 
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Tombol Lanjut
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Validasi sederhana sebelum lanjut
                  if (_selectedGender != null && _age != null && _weightController.text.isNotEmpty) {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondPage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mohon lengkapi data diri dulu ya!")),
                    );
                  }
                },
                child: const Text("Lanjut", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Label Text
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.green[800], fontWeight: FontWeight.w500),
      ),
    );
  }

  // Widget Helper: Tombol Gender (Hijau vs Abu)
  Widget _buildGenderButton(String value, IconData icon) {
    bool isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : inactiveGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : textGrey),
            const SizedBox(width: 8),
            Text(
              value, 
              style: TextStyle(
                color: isSelected ? Colors.white : textGrey,
                fontSize: 14, 
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Input Angka (Berat/Tinggi)
  Widget _buildNumberInput(TextEditingController controller, String suffix) {
    // Kita gunakan listener untuk mengubah warna jika teks diisi? 
    // Untuk simplifikasi UX, biasanya input text backgroundnya netral (putih/abu muda)
    // Tapi jika ingin style "kotak hijau" seperti desain awal, kita bungkus TextFieldnya.
    // Di sini saya buat style input form standard tapi bersih.
    
    return Container(
      decoration: BoxDecoration(
        color: primaryGreen, // Background Hijau sesuai request desain awal
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: "0 $suffix",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}