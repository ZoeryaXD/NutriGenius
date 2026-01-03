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
  late int _activityId;
  late int _healthId;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final d = widget.currentData;
    _nameCtrl = TextEditingController(text: d.fullName);
    _emailCtrl = TextEditingController(text: d.email); // Read Only
    _weightCtrl = TextEditingController(text: d.weight.toString());
    _heightCtrl = TextEditingController(text: d.height.toString());

    _gender = d.gender;
    _birthDate = d.birthDate;
    _activityId = d.activityId;
    _healthId = d.healthId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil", style: TextStyle(color: Colors.green[800])),
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

                Text("Informasi Akun", style: TextStyle(color: Colors.grey)),
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

                _buildHealthDropdown(),

                SizedBox(height: 10),
                _buildActivityDropdown(),
              ],
            ),
          ),
        ),
      ),
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

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
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

  Widget _buildHealthDropdown() {
    final items = [
      {'id': 1, 'label': 'Normal / Sehat'},
      {'id': 2, 'label': 'Pasien Diabetes'},
      {'id': 3, 'label': 'Obesitas'},
    ];
    return DropdownButtonFormField<int>(
      value: _healthId,
      decoration: InputDecoration(
        labelText: "Kondisi Kesehatan",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e['id'] as int,
                  child: Text(e['label'] as String),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _healthId = v!),
    );
  }

  Widget _buildActivityDropdown() {
    final items = [
      {'id': 1, 'label': 'Sedentary (Duduk)'},
      {'id': 2, 'label': 'Light Active (1-3x)'},
      {'id': 3, 'label': 'Active (3-5x)'},
      {'id': 4, 'label': 'Very Active (6-7x)'},
    ];
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
                  value: e['id'] as int,
                  child: Text(e['label'] as String),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _activityId = v!),
    );
  }
}
