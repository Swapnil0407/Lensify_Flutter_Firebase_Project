import 'package:flutter/material.dart';

import '../db/buyer_profile_repo.dart';
import 'shared/screen_entrance.dart';

class BuyerAddressScreen extends StatefulWidget {
  const BuyerAddressScreen({super.key});

  @override
  State<BuyerAddressScreen> createState() => _BuyerAddressScreenState();
}

class _BuyerAddressScreenState extends State<BuyerAddressScreen> {
  final _repo = BuyerProfileRepo();
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final profile = await _repo.getProfile();
    if (!mounted) return;

    _name.text = profile?.name ?? '';
    _phone.text = profile?.phone ?? '';
    _address.text = profile?.address ?? '';

    setState(() => _loading = false);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  String? _required(String? v) {
    if (v == null) return 'Required';
    if (v.trim().isEmpty) return 'Required';
    return null;
  }

  String? _phoneValidator(String? v) {
    final basic = _required(v);
    if (basic != null) return basic;

    final digits = v!.replaceAll(RegExp(r'\\D'), '');
    if (digits.length < 10) return 'Enter valid phone number';
    return null;
  }

  Future<void> _save() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _saving = true);
    try {
      await _repo.upsertProfile(
        BuyerProfile(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          address: _address.text.trim(),
        ),
      );
      if (!mounted) return;
      _toast('Address saved');
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenEntrance(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF7ED),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF7ED),
          title: const Text('My Address'),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : AbsorbPointer(
                absorbing: _saving,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        const Text(
                          'Saved Delivery Address',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          validator: _phoneValidator,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _address,
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Full Address',
                            border: OutlineInputBorder(),
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A8A1F),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _saving ? null : _save,
                          child: Text(
                            _saving ? 'Saving...' : 'Save Address',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
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
}
