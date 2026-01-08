import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // ========== DEVELOPER CONTACT INFO ==========
  static const String appName = "Lensify";
  static const String appVersion = "1.0.0";
  static const String developerName = "Swapnil Masku Burungale";
  static const String email = "burungaleswapnil5472@gmail.com";
  static const String phone = "+91 9890135615";
  static const String whatsApp = "919890135615";
  static const String linkedIn = "https://www.linkedin.com/in/swapnil-burungale-ab6413270";
  static const String address = "Maharashtra, India";
  // =============================================

  Future<void> _launchUrl(String url) async {
    // Ensure URL has https:// prefix
    String finalUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      finalUrl = 'https://$url';
    }
    final uri = Uri.parse(finalUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $finalUrl: $e');
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Query from $appName App',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Copy email to clipboard if mail app not available
      await Clipboard.setData(ClipboardData(text: email));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email copied to clipboard')),
        );
      }
    }
  }

  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/$whatsApp?text=Hi, I have a query about $appName app.');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7ED),
        title: const Text("About Us"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Logo & Name
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/LensifyLogo.jpg',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    appName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version $appVersion',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your one-stop shop for premium eyeglasses and sunglasses. '
                    'We bring you the best collection of frames for Men, Women, and Kids.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Contact Us Section
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE3F2FD),
                      child: Icon(Icons.email_outlined, color: Colors.blue),
                    ),
                    title: const Text('Email'),
                    subtitle: const Text(email),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _launchEmail(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(Icons.phone_outlined, color: Colors.green),
                    ),
                    title: const Text('Phone'),
                    subtitle: const Text(phone),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _launchPhone,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child: const Icon(Icons.chat, color: Colors.green),
                    ),
                    title: const Text('WhatsApp'),
                    subtitle: const Text('Chat with us'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _launchWhatsApp,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Connect Section
            const Text(
              'Connect With Developer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE8F4FC),
                      child: Icon(Icons.business_center, color: Colors.blue.shade700),
                    ),
                    title: const Text('LinkedIn'),
                    subtitle: const Text('Swapnil Burungale'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _launchUrl(linkedIn),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Address Section
            const Text(
              'Our Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFFFF3E0),
                    child: Icon(Icons.location_on_outlined, color: Colors.orange),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          address,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Developer Credit
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A8A1F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.code, color: Color(0xFF0A8A1F)),
                  const SizedBox(height: 8),
                  const Text(
                    'Developed with ❤️ by',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    developerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Copyright
            Text(
              '© ${DateTime.now().year} $appName. All rights reserved.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
