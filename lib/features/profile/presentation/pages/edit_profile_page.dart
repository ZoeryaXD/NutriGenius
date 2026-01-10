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
import '../widgets/profile_dropdown_field.dart';
import '../widgets/profile_text_field.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileEntity currentData;
  const EditProfilePage({super.key, required this.currentData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _weightCtrl, _heightCtrl;
  late String _gender;
  late DateTime _birthDate;
  late int _activityId, _healthId;
  File? _pickedImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final d = widget.currentData;
    _nameCtrl = TextEditingController(text: d.fullName);
    _weightCtrl = TextEditingController(text: d.weight.toString());
    _heightCtrl = TextEditingController(text: d.height.toString());
    _gender = d.gender;
    _birthDate = d.birthDate;
    _activityId = d.activityId;
    _healthId = d.healthId;
    context.read<ProfileBloc>().add(LoadProfileMasterData());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
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
        healthId: _healthId,
        activityId: _activityId,
        age: 0,
        profilePicture: widget.currentData.profilePicture,
      );

      context.read<ProfileBloc>().add(
        UpdateProfileData(updatedProfile, imageFile: _pickedImageFile),
      );
    }
  }

  Future<void> _pickImage() async {
    final p = await _picker.pickImage(source: ImageSource.gallery);
    if (p != null) setState(() => _pickedImageFile = File(p.path));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              print("JUMLAH DATA KESEHATAN: ${state.healthConditions.length}");
              print("JUMLAH DATA AKTIVITAS: ${state.activityLevels.length}");
              if (state.status == ProfileStatus.loading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
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
                child: const Text(
                  "SIMPAN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? "Sukses"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhotoSection(theme),
                    const SizedBox(height: 32),
                    ProfileTextField(
                      label: "Nama Lengkap",
                      controller: _nameCtrl,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildDatePicker(theme),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ProfileTextField(
                            label: "Berat (kg)",
                            controller: _weightCtrl,
                            isNumber: true,
                            icon: Icons.monitor_weight_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ProfileTextField(
                            label: "Tinggi (cm)",
                            controller: _heightCtrl,
                            isNumber: true,
                            icon: Icons.height,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildHealthDropdown(state),
                    const SizedBox(height: 16),
                    _buildActivityDropdown(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhotoSection(ThemeData theme) {
    String? imageUrl;
    if (widget.currentData is ProfileModel)
      imageUrl = (widget.currentData as ProfileModel).fullImageUrl;
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage:
                _pickedImageFile != null
                    ? FileImage(_pickedImageFile!) as ImageProvider
                    : (imageUrl != null && imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : null),
            child:
                (_pickedImageFile == null &&
                        (imageUrl == null || imageUrl.isEmpty))
                    ? const Icon(Icons.person, size: 60)
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
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
      ),
    );
  }

  Widget _buildHealthDropdown(ProfileState state) {
    return ProfileDropdownField<int>(
      label: "Kondisi Kesehatan",
      icon: Icons.health_and_safety_outlined,
      value:
          state.healthConditions.any((e) => e.id == _healthId)
              ? _healthId
              : null,
      items:
          state.healthConditions
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e.id as int,
                  child: Text(e.conditionName),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _healthId = v!),
    );
  }

  Widget _buildActivityDropdown(ProfileState state) {
    return ProfileDropdownField<int>(
      label: "Aktivitas Harian",
      icon: Icons.directions_run,
      value:
          state.activityLevels.any((e) => e.id == _activityId)
              ? _activityId
              : null,
      items:
          state.activityLevels
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e.id as int,
                  child: Text(e.levelName),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _activityId = v!),
    );
  }

  Widget _buildDatePicker(ThemeData theme) {
    return InkWell(
      onTap: () async {
        final p = await showDatePicker(
          context: context,
          initialDate: _birthDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (p != null) setState(() => _birthDate = p);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: "Tanggal Lahir",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        child: Text(DateFormat('dd/MM/yyyy').format(_birthDate)),
      ),
    );
  }
}
