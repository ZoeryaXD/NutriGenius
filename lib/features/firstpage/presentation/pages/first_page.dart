import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/firstpage_bloc.dart'; // Pastikan import ini benar

class FirstPage extends StatefulWidget {
  final PageController pageController;
  const FirstPage({required this.pageController});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // Default values
  String _gender = 'Laki-Laki';
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  DateTime? _birthDate;
  // Helper Hitung Umur
  int get _age {
    if (_birthDate == null) return 0;
    final now = DateTime.now();
    int age = now.year - _birthDate!.year;
    if (now.month < _birthDate!.month ||
        (now.month == _birthDate!.month && now.day < _birthDate!.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            "Halo! Yuk Kenalan Dulu",
            "Data ini membantu kami menghitung kebutuhan tubuhmu.",
          ),
          SizedBox(height: 30),

          // 1. INPUT GENDER (DROPDOWN HIJAU)
          _buildLabel("Jenis Kelamin:"),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green[700], // Background Hijau
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _gender,
                isExpanded: true,
                dropdownColor: Colors.green[700], // Menu dropdown juga hijau
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                items:
                    ['Laki-Laki', 'Perempuan'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(
                              value == 'Laki-Laki'
                                  ? Icons.directions_run
                                  : Icons.female,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (newValue) => setState(() => _gender = newValue!),
              ),
            ),
          ),

          SizedBox(height: 20),

          // 2. BERAT & TINGGI
          Row(
            children: [
              Expanded(
                child: _buildGreenInputGroup("Berat Badan:", _weightCtrl, "kg"),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildGreenInputGroup(
                  "Tinggi Badan:",
                  _heightCtrl,
                  "cm",
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // 3. TANGGAL LAHIR
          _buildLabel("Tanggal Lahir:"),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.light(primary: Colors.green),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) setState(() => _birthDate = picked);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Text(
                    _birthDate == null
                        ? "Pilih Tanggal Lahir"
                        : "${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // 4. USIA (READ ONLY)
          _buildLabel("Usia:"),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(color: Colors.green[700], borderRadius: BorderRadius.circular(20)),
            child: Text(
              _birthDate == null ? "- Tahun" : "$_age Tahun", 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
            ),
          ),

          SizedBox(height: 40),

          // TOMBOL LANJUT
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.green, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_weightCtrl.text.isEmpty || _heightCtrl.text.isEmpty || _birthDate == null) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text("Harap lengkapi semua data dulu ya!"), backgroundColor: Colors.red)
                   );
                   return;
                 }
                 
                context.read<FirstPageBloc>().add(
                  UpdateStep1Data(
                    _gender,
                    double.parse(_weightCtrl.text),
                    double.parse(_heightCtrl.text),
                    _birthDate!,
                  ),
                );
                widget.pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              child: Text(
                "Lanjut",
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPERS
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.green[800],
        ),
      ),
    );
  }

  Widget _buildGreenInputGroup(
    String label,
    TextEditingController ctrl,
    String suffix,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: ctrl,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "0",
              suffixText: suffix,
              suffixStyle: TextStyle(color: Colors.white38),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.green),
              SizedBox(width: 8),
              Text(
                "Langkah 1 dari 3",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(color: Colors.green[700], fontSize: 14),
        ),
      ],
    );
  }
}
