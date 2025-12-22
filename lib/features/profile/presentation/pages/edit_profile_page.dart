import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controller
  final TextEditingController _nameController = TextEditingController(text: "Royhan Firdaus");
  final TextEditingController _emailController = TextEditingController(text: "royhan@gmail.com");
  final TextEditingController _weightController = TextEditingController(text: "65");
  final TextEditingController _heightController = TextEditingController(text: "175"); // Typo di desain 175cm? saya ikut desain

  String? _selectedGender = "Laki-Laki";
  String? _selectedGoal = "Pasien Diabetes";
  DateTime _selectedDate = DateTime(2001, 10, 19);

  final Color primaryGreen = const Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profil", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Simpan & Kembali (Dummy logic)
            },
            child: const Text("SIMPAN", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Profil dengan Icon Kamera
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF81C784),
                    child: const Icon(Icons.person, size: 60, color: Color(0xFF1B5E20)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text("Informasi Akun", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            
            _buildTextField(Icons.person_outline, _nameController),
            const SizedBox(height: 12),
            _buildTextField(Icons.email_outlined, _emailController),

            const SizedBox(height: 30),
            const Text("Data Fisik (Untuk Hitungan Kalori)", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),

            // Gender Dropdown
            _buildDropdownContainer(
              icon: Icons.people_outline, 
              value: _selectedGender!, 
              items: ["Laki-Laki", "Perempuan"],
              onChanged: (val) => setState(() => _selectedGender = val)
            ),
            const SizedBox(height: 12),

            // Tanggal Lahir
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Berat & Tinggi (Row)
            Row(
              children: [
                Expanded(child: _buildTextField(Icons.monitor_weight_outlined, _weightController, suffix: "(kg)")),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(Icons.height, _heightController, suffix: "(cm)")),
              ],
            ),
            const SizedBox(height: 12),

            // Goal Dropdown
            _buildDropdownContainer(
              icon: Icons.directions_run, 
              value: _selectedGoal!, 
              items: ["Pasien Diabetes", "Diet Sehat", "Bulking", "Cutting (Menurunkan Lemak)"],
              onChanged: (val) => setState(() => _selectedGoal = val)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, TextEditingController controller, {String? suffix}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixText: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownContainer({
    required IconData icon, 
    required String value, 
    required List<String> items, 
    required Function(String?) onChanged
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}