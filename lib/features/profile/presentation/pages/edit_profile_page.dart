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
  const EditProfilePage({required this.currentData});

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

  int? _activityId;
  int? _healthId;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadMasterData());

    final d = widget.currentData;
    _nameCtrl = TextEditingController(text: d.fullName);
    _emailCtrl = TextEditingController(text: d.email);
    _weightCtrl = TextEditingController(text: d.weight.toString());
    _heightCtrl = TextEditingController(text: d.height.toString());

    _gender = d.gender;
    _birthDate = d.birthDate;

    _activityId = d.activityId > 0 ? d.activityId : 1;
    _healthId = d.healthId > 0 ? d.healthId : 1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        List<ActivityLevel> activityList = [];
        List<HealthCondition> healthList = [];

        if (state is ProfileLoaded) {
          activityList = state.activityLevels;
          healthList = state.healthConditions;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Edit Profil",
              style: TextStyle(color: Colors.green[800]),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: BackButton(color: Colors.green[800]),
            actions: [
              TextButton(
                onPressed: _saveProfile,
                child: Text(
                  "SIMPAN",
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _buildPhotoSection()),
                    SizedBox(height: 30),

                    Text(
                      "Informasi Akun",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    _buildTextField("Nama Lengkap", _nameCtrl),
                    SizedBox(height: 10),
                    _buildTextField(
                      "Email (Tidak dapat diubah)",
                      _emailCtrl,
                      readOnly: true,
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Data Fisik (Untuk Hitungan Kalori)",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10),

                    _buildDropdown(
                      "Jenis Kelamin",
                      _gender,
                      ["Laki-laki", "Perempuan"],
                      (val) {
                        setState(() => _gender = val!);
                      },
                    ),

                    SizedBox(height: 10),
                    InkWell(
                      onTap: _pickDate,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey),
                            SizedBox(width: 10),
                            Text(
                              DateFormat('dd/MM/yyyy').format(_birthDate),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            "Berat (kg)",
                            _weightCtrl,
                            isNumber: true,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            "Tinggi (cm)",
                            _heightCtrl,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    _buildDynamicHealthDropdown(healthList),

                    SizedBox(height: 10),
                    _buildDynamicActivityDropdown(activityList),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoSection() {
    String? imageUrl;

    if (widget.currentData is ProfileModel) {
      imageUrl = (widget.currentData as ProfileModel).fullImageUrl;
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.green[100],
          backgroundImage:
              (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl)
                  : null,
          child:
              (imageUrl == null || imageUrl.isEmpty)
                  ? Icon(Icons.person, size: 60, color: Colors.green)
                  : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _showPhotoOptions,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green,
              child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (widget.currentData.profilePicture != null)
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    "Hapus Foto",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ProfileBloc>().add(DeleteProfilePhoto());
                  },
                ),
            ],
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      context.read<ProfileBloc>().add(UploadProfilePhoto(File(picked.path)));
    }
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

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool readOnly = false,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: ctrl,
      readOnly: readOnly,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDynamicHealthDropdown(List<HealthCondition> items) {
    if (items.isEmpty) return LinearProgressIndicator();

    return DropdownButtonFormField<int>(
      value: _healthId,
      decoration: InputDecoration(
        labelText: "Kondisi Kesehatan",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          items
              .map(
                (e) =>
                    DropdownMenuItem(value: e.id, child: Text(e.conditionName)),
              )
              .toList(),
      onChanged: (v) => setState(() => _healthId = v!),
      validator: (v) => v == null ? "Pilih kondisi" : null,
    );
  }

  Widget _buildDynamicActivityDropdown(List<ActivityLevel> items) {
    if (items.isEmpty) return LinearProgressIndicator();

    return DropdownButtonFormField<int>(
      value: _activityId,
      decoration: InputDecoration(
        labelText: "Aktivitas Harian",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(
                    e.levelName.length > 30
                        ? e.levelName.substring(0, 30) + "..."
                        : e.levelName,
                  ),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _activityId = v!),
      validator: (v) => v == null ? "Pilih aktivitas" : null,
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Parse angka dengan aman (ganti koma jadi titik)
      double weight =
          double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 0.0;
      double height =
          double.tryParse(_heightCtrl.text.replaceAll(',', '.')) ?? 0.0;

      final updatedProfile = ProfileEntity(
        fullName: _nameCtrl.text,
        email: widget.currentData.email,
        gender: _gender,
        birthDate: _birthDate,
        weight: weight,
        height: height,
        healthId: _healthId ?? 1,
        activityId: _activityId ?? 1,
        age: 0,
        profilePicture: widget.currentData.profilePicture,
      );

      context.read<ProfileBloc>().add(UpdateProfileData(updatedProfile));
    }
  }
}