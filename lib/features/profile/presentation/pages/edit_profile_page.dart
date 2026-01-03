import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileEntity? profile;
  const EditProfilePage({super.key, this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late DateTime _selectedDate;
  String? _selectedGender;
  String? _selectedGoal = "Pasien Diabetes";

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.name ?? "");
    _emailController = TextEditingController(text: widget.profile?.email ?? "");
    _weightController = TextEditingController(
      text: widget.profile?.weight.toString() ?? "",
    );
    _heightController = TextEditingController(
      text: widget.profile?.height.toString() ?? "",
    );

    String dbGender = widget.profile?.gender ?? "Laki-Laki";
    if (dbGender.toLowerCase() == "laki-laki") {
      _selectedGender = "Laki-Laki";
    } else if (dbGender.toLowerCase() == "perempuan") {
      _selectedGender = "Perempuan";
    } else {
      _selectedGender = "Laki-Laki";
    }

    String rawDate = widget.profile?.birthDate ?? "2000-01-01";
    DateTime? parsedDate = DateTime.tryParse(rawDate);
    if (parsedDate != null && parsedDate.year > 2100) {
      _selectedDate = DateTime(2000, 1, 1);
    } else {
      _selectedDate = parsedDate ?? DateTime(2000, 1, 1);
    }
  }

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
        title: const Text(
          "Edit Profil",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ProfileBloc>().add(
                UpdateProfileEvent(
                  name: _nameController.text,
                  email: _emailController.text,
                  gender: _selectedGender,
                  weight: double.tryParse(_weightController.text) ?? 0.0,
                  height: double.tryParse(_heightController.text) ?? 0.0,
                  birthDate: _selectedDate,
                ),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Menyimpan perubahan..."),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              "SIMPAN",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF81C784),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFF1B5E20),
                    ),
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
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
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
            const Text(
              "Data Fisik (Untuk Hitungan Kalori)",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),

            _buildDropdownContainer(
              icon: Icons.people_outline,
              value: _selectedGender!,
              items: ["Laki-Laki", "Perempuan"],
              onChanged: (val) => setState(() => _selectedGender = val),
            ),
            const SizedBox(height: 12),

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    Icons.monitor_weight_outlined,
                    _weightController,
                    suffix: "(kg)",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    Icons.height,
                    _heightController,
                    suffix: "(cm)",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildDropdownContainer(
              icon: Icons.directions_run,
              value: _selectedGoal!,
              items: [
                "Pasien Diabetes",
                "Diet Sehat",
                "Bulking",
                "Cutting (Menurunkan Lemak)",
              ],
              onChanged: (val) => setState(() => _selectedGoal = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    TextEditingController controller, {
    String? suffix,
  }) {
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownContainer({
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
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
                items:
                    items
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
