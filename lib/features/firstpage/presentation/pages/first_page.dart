import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrigenius/features/firstpage/presentation/bloc/firstpage_event.dart';
import '../bloc/firstpage_bloc.dart';

class FirstPage extends StatefulWidget {
  final PageController pageController;
  const FirstPage({super.key, required this.pageController});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String? _gender;
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  DateTime? _birthDate;

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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            context,
            "Halo! Yuk Kenalan Dulu",
            "Data ini membantu kami menghitung kebutuhan tubuhmu.",
          ),
          const SizedBox(height: 30),
          _buildLabel(context, "Jenis Kelamin:"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _gender == null ? theme.colorScheme.surface : primaryColor,
              borderRadius: BorderRadius.circular(12),
              border:
                  _gender == null
                      ? Border.all(color: theme.dividerColor)
                      : null,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _gender,
                isExpanded: true,
                dropdownColor:
                    theme.brightness == Brightness.dark
                        ? const Color(0xFF161D16)
                        : Colors.white,
                hint: Text(
                  "Pilih Jenis Kelamin",
                  style: TextStyle(color: theme.hintColor),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: _gender == null ? primaryColor : Colors.white,
                ),
                style: TextStyle(
                  color:
                      _gender == null
                          ? theme.textTheme.bodyLarge?.color
                          : Colors.white,
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
                              value == 'Laki-Laki' ? Icons.male : Icons.female,
                              color:
                                  _gender == value
                                      ? primaryColor
                                      : theme.iconTheme.color,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              value,
                              style: TextStyle(
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                onChanged: (newValue) => setState(() => _gender = newValue!),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInputGroup(
                  context,
                  "Berat Badan:",
                  _weightCtrl,
                  "kg",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildInputGroup(
                  context,
                  "Tinggi Badan:",
                  _heightCtrl,
                  "cm",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildLabel(context, "Tanggal Lahir:"),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _birthDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _birthDate == null
                        ? "Pilih Tanggal Lahir"
                        : "${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel(context, "Usia:"),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _birthDate == null ? "- Tahun" : "$_age Tahun",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_weightCtrl.text.isEmpty ||
                    _heightCtrl.text.isEmpty ||
                    _birthDate == null ||
                    _gender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Harap lengkapi semua data dulu ya!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                context.read<FirstPageBloc>().add(
                  UpdateStep1Data(
                    _gender!,
                    double.parse(_weightCtrl.text),
                    double.parse(_heightCtrl.text),
                    _birthDate!,
                  ),
                );
                widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              child: const Text(
                "Lanjut",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInputGroup(
    BuildContext context,
    String label,
    TextEditingController ctrl,
    String suffix,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: ctrl,
            onChanged: (val) => setState(() {}),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "0",
              suffixText: suffix,
              suffixStyle: TextStyle(color: theme.hintColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String title, String subtitle) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
          child: Row(
            children: [
              Icon(Icons.arrow_back, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                "Langkah 1 dari 3",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
