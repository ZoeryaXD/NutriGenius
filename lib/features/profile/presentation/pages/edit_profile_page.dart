import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../data/models/profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileEntity currentData;
  const EditProfilePage({super.key, required this.currentData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;

  late String _gender;
  late DateTime _birthDate;
  late int _activityId;
  late int _healthId;

  File? _pickedImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final d = widget.currentData;
    _nameCtrl = TextEditingController(text: d.fullName);
    _emailCtrl = TextEditingController(text: d.email);
    _weightCtrl = TextEditingController(text: d.weight.toString());
    _heightCtrl = TextEditingController(text: d.height.toString());

    _gender = d.gender;
    _birthDate = d.birthDate;
    _activityId = d.activityId;
    _healthId = d.healthId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      if (_pickedImageFile != null) {
        context.read<ProfileBloc>().add(UploadProfilePhoto(_pickedImageFile!));
      }

      final updatedProfile = ProfileEntity(
        fullName: _nameCtrl.text,
        email: widget.currentData.email,
        gender: _gender,
        birthDate: _birthDate,
        weight: double.parse(_weightCtrl.text),
        height: double.parse(_heightCtrl.text),
        healthId: _healthId,
        activityId: _activityId,
        age: 0,
        profilePicture: widget.currentData.profilePicture,
      );
      context.read<ProfileBloc>().add(UpdateProfileData(updatedProfile));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit Profil",
          style: TextStyle(
            color: isDark ? Colors.white : theme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(color: isDark ? Colors.white : theme.primaryColor),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              return TextButton(
                onPressed: _saveProfile,
                child: Text(
                  "SIMPAN",
                  style: TextStyle(
                    color: isDark ? Colors.greenAccent : theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileActionSuccess) {
            if (state.message.toLowerCase().contains("berhasil") ||
                state.message.toLowerCase().contains("profil")) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              if (Navigator.canPop(context)) Navigator.pop(context);
            }
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhotoSection(theme),
                    const SizedBox(height: 32),
                    if (isLandscape)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildAccountInfoSection(theme, isDark),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: _buildPhysicalDataSection(theme, isDark),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildAccountInfoSection(theme, isDark),
                          const SizedBox(height: 32),
                          _buildPhysicalDataSection(theme, isDark),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountInfoSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Informasi Akun", isDark),
        const SizedBox(height: 16),
        _buildTextField(
          "Nama Lengkap",
          _nameCtrl,
          theme,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          "Email (Read Only)",
          _emailCtrl,
          theme,
          icon: Icons.email_outlined,
          readOnly: true,
        ),
      ],
    );
  }

  Widget _buildPhysicalDataSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Data Fisik", isDark),
        const SizedBox(height: 16),
        _buildDropdown(
          "Jenis Kelamin",
          _gender,
          ["Laki-laki", "Perempuan"],
          (val) => setState(() => _gender = val!),
          theme,
          Icons.wc,
        ),
        const SizedBox(height: 16),
        _buildDatePicker(theme),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                "Berat (kg)",
                _weightCtrl,
                theme,
                isNumber: true,
                icon: Icons.monitor_weight_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                "Tinggi (cm)",
                _heightCtrl,
                theme,
                isNumber: true,
                icon: Icons.height,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildHealthDropdown(theme),
        const SizedBox(height: 16),
        _buildActivityDropdown(theme),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white70 : Colors.green[800],
      ),
    );
  }

  Widget _buildPhotoSection(ThemeData theme) {
    String? imageUrl;
    if (widget.currentData is ProfileModel) {
      imageUrl = (widget.currentData as ProfileModel).fullImageUrl;
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.primaryColor.withOpacity(0.2),
              width: 4,
            ),
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor:
                theme.brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.green[50],
            backgroundImage:
                _pickedImageFile != null
                    ? FileImage(_pickedImageFile!) as ImageProvider
                    : (imageUrl != null && imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null),
            child:
                (_pickedImageFile == null &&
                        (imageUrl == null || imageUrl.isEmpty))
                    ? Icon(Icons.person, size: 60, color: theme.primaryColor)
                    : null,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: GestureDetector(
            onTap: _showPhotoOptions,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: theme.primaryColor,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl,
    ThemeData theme, {
    bool readOnly = false,
    bool isNumber = false,
    IconData? icon,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return TextFormField(
      controller: ctrl,
      readOnly: readOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
    );
  }

  Widget _buildDatePicker(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              DateFormat('dd/MM/yyyy').format(_birthDate),
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
    ThemeData theme,
    IconData icon,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      dropdownColor: theme.cardColor,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor:
            theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 15)),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildHealthDropdown(ThemeData theme) {
    final items = [
      {'id': 1, 'label': 'Normal / Sehat'},
      {'id': 2, 'label': 'Pasien Diabetes'},
      {'id': 3, 'label': 'Obesitas'},
    ];
    return DropdownButtonFormField<int>(
      value: _healthId,
      isExpanded: true,
      dropdownColor: theme.cardColor,
      decoration: InputDecoration(
        labelText: "Kondisi Kesehatan",
        prefixIcon: const Icon(Icons.health_and_safety_outlined, size: 20),
        filled: true,
        fillColor:
            theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e['id'] as int,
                  child: Text(
                    e['label'] as String,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _healthId = v!),
    );
  }

  Widget _buildActivityDropdown(ThemeData theme) {
    final items = [
      {'id': 1, 'label': 'Sedentary'},
      {'id': 2, 'label': 'Light Active'},
      {'id': 3, 'label': 'Active'},
      {'id': 4, 'label': 'Very Active'},
    ];
    return DropdownButtonFormField<int>(
      value: _activityId,
      isExpanded: true,
      dropdownColor: theme.cardColor,
      decoration: InputDecoration(
        labelText: "Aktivitas Harian",
        prefixIcon: const Icon(Icons.directions_run, size: 20),
        filled: true,
        fillColor:
            theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e['id'] as int,
                  child: Text(
                    e['label'] as String,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _activityId = v!),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) setState(() => _pickedImageFile = File(picked.path));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Galeri"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Kamera"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
