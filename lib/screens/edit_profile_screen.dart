import 'package:flutter/material.dart';
import '../core/utils/validators.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/primary_button.dart';
import '../data/repositories/auth_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthRepository();

  late final TextEditingController _name;
  late final TextEditingController _email;
  final _photoUrl = TextEditingController();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  late final String _initialName;
  late final String? _initialPhoto;

  String? _selectedPhoto;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    _initialName = user?.displayName ?? '';
    _initialPhoto = user?.photoURL;

    _name = TextEditingController(text: _initialName);
    _email = TextEditingController(text: user?.email ?? '');
    _selectedPhoto = _initialPhoto;

    _name.addListener(_onFieldChanged);
    _currentPassword.addListener(_onFieldChanged);
    _newPassword.addListener(_onFieldChanged);
    _confirmPassword.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _name.removeListener(_onFieldChanged);
    _currentPassword.removeListener(_onFieldChanged);
    _newPassword.removeListener(_onFieldChanged);
    _confirmPassword.removeListener(_onFieldChanged);

    _name.dispose();
    _email.dispose();
    _photoUrl.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  bool get _nameChanged => _name.text.trim() != _initialName;

  bool get _photoChanged =>
      _selectedPhoto != null && _selectedPhoto != _initialPhoto;

  bool get _passwordChanged => _newPassword.text.isNotEmpty;

  bool get _hasChanges => _nameChanged || _photoChanged || _passwordChanged;

  void _applyCustomUrl() {
    final url = _photoUrl.text.trim();
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      _showMessage('Enter a valid HTTPS link');
      return;
    }
    setState(() => _selectedPhoto = url);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _save() async {
    if (!_hasChanges) return;
    if (!_formKey.currentState!.validate()) return;
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      if (_nameChanged) {
        await _auth.updateDisplayName(_name.text.trim());
      }
      if (_photoChanged) {
        await _auth.updatePhotoUrl(_selectedPhoto!);
      }
      if (_passwordChanged) {
        await _auth.changePassword(
          currentPassword: _currentPassword.text,
          newPassword: _newPassword.text,
        );
      }
      if (!mounted) return;
      _showMessage('Profile updated');
      Navigator.pop(context);
    } on AuthFailure catch (e) {
      if (!mounted) return;
      _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------- UI ----------

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E1E1E),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit profile',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Фото
                _sectionTitle('Profile photo'),
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFFEFE7F8),
                    backgroundImage:
                    (_selectedPhoto != null && _selectedPhoto!.isNotEmpty)
                        ? NetworkImage(_selectedPhoto!) as ImageProvider
                        : const AssetImage('assets/images/5.png'),
                    onBackgroundImageError: (_, __) {},
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _photoUrl,
                  labelText: 'Paste your HTTPS link to a photo',
                  hintText: 'https://example.com/photo.png',
                  keyboardType: TextInputType.url,
                  enabled: !_isLoading,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check, color: Color(0xFF6B4FA0)),
                    tooltip: 'Preview',
                    onPressed: _applyCustomUrl,
                  ),
                ),
                const SizedBox(height: 28),

                // Дані акаунта
                _sectionTitle('Account details'),
                CustomTextField(
                  controller: _name,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  enabled: !_isLoading,
                  validator: (v) => Validators.required(v, 'Name'),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel_outlined,
                        color: Colors.black54),
                    onPressed: () => _name.clear(),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _email,
                  labelText: 'Email',
                  hintText: 'you@example.com',
                  readOnly: true,
                ),
                const SizedBox(height: 28),

                // Пароль
                _sectionTitle('Change password'),
                const Text(
                  'Leave these fields empty to keep your current password.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF7A7A7A)),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _currentPassword,
                  labelText: 'Current password',
                  hintText: 'Enter current password',
                  obscureText: true,
                  enabled: !_isLoading,
                  validator: (v) => _newPassword.text.isNotEmpty
                      ? Validators.required(v, 'Current password')
                      : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _newPassword,
                  labelText: 'New password',
                  hintText: 'At least 6 characters',
                  obscureText: true,
                  enabled: !_isLoading,
                  validator: (v) =>
                  (v == null || v.isEmpty) ? null : Validators.password(v),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPassword,
                  labelText: 'Repeat new password',
                  hintText: 'Repeat new password',
                  obscureText: true,
                  enabled: !_isLoading,
                  validator: Validators.confirm(() => _newPassword.text),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE4F4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Password changes will sign you out on your other devices.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF7A7A7A)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: PrimaryButton(
            text: 'Save',
            isLoading: _isLoading,
            onPressed: (_isLoading || !_hasChanges) ? null : _save,
          ),
        ),
      ),
    );
  }
}