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
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;
  late String _gender;
  late DateTime _birthDate;
  int? _activityId;
  int? _healthId;
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
    _activityId = d.activityId > 0 ? d.activityId : 1;
    _healthId = d.healthId > 0 ? d.healthId : 1;
    context.read<ProfileBloc>().add(LoadMasterData());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
        if (state is PhotoUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text(
            "Edit Profil",
            style: TextStyle(
              color: isDark ? Colors.white : colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                "SIMPAN",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            ProfileEntity? latestProfile;
            List<ActivityLevel> activityList = [];
            List<HealthCondition> healthList = [];

            if (state is ProfileLoaded) {
              latestProfile = state.profile;
              activityList = state.activityLevels;
              healthList = state.healthConditions;
            }

            final currentProfile = latestProfile ?? widget.currentData;

            return Form(
              key: _formKey,
              child:
                  isLandscape
                      ? _buildLandscapeLayout(
                        currentProfile,
                        activityList,
                        healthList,
                        isDark,
                        colorScheme,
                      )
                      : _buildPortraitLayout(
                        currentProfile,
                        activityList,
                        healthList,
                        isDark,
                        colorScheme,
                      ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    ProfileEntity profile,
    List<ActivityLevel> activities,
    List<HealthCondition> healths,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _buildPhotoSection(profile, colorScheme, isDark)),
          const SizedBox(height: 40),
          _buildPersonalInfoSection(isDark, colorScheme),
          const SizedBox(height: 32),
          _buildPhysicalDataSection(activities, healths, isDark, colorScheme),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
    ProfileEntity profile,
    List<ActivityLevel> activities,
    List<HealthCondition> healths,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildPhotoSection(profile, colorScheme, isDark),
                const SizedBox(height: 32),
                _buildPersonalInfoSection(isDark, colorScheme),
              ],
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          color: isDark ? Colors.white10 : Colors.black12,
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildPhysicalDataSection(
                  activities,
                  healths,
                  isDark,
                  colorScheme,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(bool isDark, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Informasi Pribadi", isDark),
        const SizedBox(height: 16),
        _buildTextField("Nama Lengkap", _nameCtrl, isDark, colorScheme),
        const SizedBox(height: 16),
        _buildTextField(
          "Email",
          _emailCtrl,
          isDark,
          colorScheme,
          readOnly: true,
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          "Jenis Kelamin",
          _gender,
          ["Laki-laki", "Perempuan"],
          (v) => setState(() => _gender = v!),
          isDark,
          colorScheme,
        ),
        const SizedBox(height: 16),
        _buildDatePicker(isDark, colorScheme),
      ],
    );
  }

  Widget _buildPhysicalDataSection(
    List<ActivityLevel> activities,
    List<HealthCondition> healths,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Data Fisik & Tujuan", isDark),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                "Berat (kg)",
                _weightCtrl,
                isDark,
                colorScheme,
                isNumber: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                "Tinggi (cm)",
                _heightCtrl,
                isDark,
                colorScheme,
                isNumber: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildHealthDropdown(healths, isDark, colorScheme),
        const SizedBox(height: 16),
        _buildActivityDropdown(activities, isDark, colorScheme),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white54 : Colors.black54,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildPhotoSection(
    ProfileEntity data,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    String? imageUrl;
    if (data is ProfileModel) imageUrl = data.fullImageUrl;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.2),
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: colorScheme.primary.withOpacity(0.1),
            backgroundImage:
                (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : null,
            child:
                (imageUrl == null || imageUrl.isEmpty)
                    ? Icon(Icons.person, size: 60, color: colorScheme.primary)
                    : null,
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: InkWell(
            onTap: _showPhotoOptions,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colorScheme.primary,
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

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Pilih dari Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Ambil Foto Baru"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null)
      context.read<ProfileBloc>().add(UploadProfilePhoto(File(picked.path)));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Widget _buildDatePicker(bool isDark, ColorScheme colorScheme) {
    return InkWell(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : Colors.white,
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: 20, color: colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              DateFormat('dd MMMM yyyy').format(_birthDate),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl,
    bool isDark,
    ColorScheme colorScheme, {
    bool readOnly = false,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: ctrl,
      readOnly: readOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDark ? colorScheme.surface : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDark ? colorScheme.surface : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 1),
          ),
        ),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildHealthDropdown(
    List<HealthCondition> items,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return DropdownButtonFormField<int>(
      value: _healthId,
      decoration: InputDecoration(
        labelText: "Kondisi Kesehatan",
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDark ? colorScheme.surface : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 1),
          ),
        ),
      ),
      items:
          items
              .map(
                (e) =>
                    DropdownMenuItem(value: e.id, child: Text(e.conditionName)),
              )
              .toList(),
      onChanged: (v) => setState(() => _healthId = v!),
    );
  }

  Widget _buildActivityDropdown(
    List<ActivityLevel> items,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return DropdownButtonFormField<int>(
      value: _activityId,
      decoration: InputDecoration(
        labelText: "Aktivitas Harian",
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: isDark ? colorScheme.surface : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 1),
          ),
        ),
      ),
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(
                    e.levelName.length > 30
                        ? "${e.levelName.substring(0, 30)}..."
                        : e.levelName,
                  ),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _activityId = v!),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = ProfileEntity(
        fullName: _nameCtrl.text,
        email: widget.currentData.email,
        gender: _gender,
        birthDate: _birthDate,
        weight: double.tryParse(_weightCtrl.text) ?? 0.0,
        height: double.tryParse(_heightCtrl.text) ?? 0.0,
        healthId: _healthId ?? 1,
        activityId: _activityId ?? 1,
        age: 0,
        profilePicture: widget.currentData.profilePicture,
      );
      context.read<ProfileBloc>().add(UpdateProfileData(updatedProfile));
    }
  }
}
