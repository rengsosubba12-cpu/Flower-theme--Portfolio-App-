import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';
import '../widgets/floral_background.dart';

/// The Contact screen with actionable list tiles for Email, LinkedIn, GitHub,
/// and an inline message form.
///
/// Navigation flows:
/// - Email / LinkedIn / GitHub list tiles → launch URL or show SnackBar log
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  // ── URL launching helper ────────────────────────────────────────────────
  Future<void> _launchUrl(String urlStr, String label) async {
    final uri = Uri.parse(urlStr);
    debugPrint('📬 Contact action triggered: $label → $urlStr');

    // Show elegant Snackbar feedback first
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.link_rounded,
                color: AppTheme.petalYellow,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Opening $label...',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ),
          backgroundColor: AppTheme.darkForest,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('🔗 URL launch failed (mock): $urlStr');
    }
  }

  // ── Asynchronous Web3Forms submit ──────────────────────────────────────
  Future<void> _sendMessage() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final message = _messageCtrl.text.trim();

    // Client-side validation: check if any fields are empty or invalid
    if (!_formKey.currentState!.validate() || name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please fill out all fields correctly.'),
        ),
      );
      return;
    }

    setState(() => _sending = true);
    try {
      final response = await http.post(
        Uri.parse('https://api.web3forms.com/submit'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'access_key': 'd222aa90-432a-442e-a8ca-2614c3e05348',
          'name': name,
          'email': email,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        _nameCtrl.clear();
        _emailCtrl.clear();
        _messageCtrl.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Message sent directly to Rengso!'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send message. Please try again.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FloralBackground(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            slivers: [
              // ── Header ─────────────────────────────────────────────────
              SliverToBoxAdapter(child: _ContactHeader(topPad: topPad)),

              // ── Quick contact list tiles ───────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reach Out Directly',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 14),
                      _ContactTile(
                        icon: Icons.email_rounded,
                        iconColor: AppTheme.blushPink,
                        title: 'Email',
                        subtitle: 'rengsosubba12@gmail.com',
                        onTap: () => _launchUrl(
                          'mailto:rengsosubba12@gmail.com',
                          'Email',
                        ),
                      ),
                      _ContactTile(
                        icon: Icons.link_rounded,
                        iconColor: AppTheme.sageGreen,
                        title: 'LinkedIn',
                        subtitle: 'linkedin.com/in/rengso-subba-581b23404',
                        onTap: () => _launchUrl(
                          'https://www.linkedin.com/in/rengso-subba-581b23404',
                          'LinkedIn',
                        ),
                      ),
                      _ContactTile(
                        icon: Icons.code_rounded,
                        iconColor: AppTheme.lavender,
                        title: 'GitHub',
                        subtitle: 'github.com/rengsosubba12-cpu',
                        onTap: () => _launchUrl(
                          'https://github.com/rengsosubba12-cpu',
                          'GitHub',
                        ),
                      ),
                      _ContactTile(
                        icon: Icons.location_on_rounded,
                        iconColor: AppTheme.terracotta,
                        title: 'Location',
                        subtitle: 'Bangalore, India 🇮🇳',
                        onTap: () => _launchUrl(
                          'https://maps.google.com/?q=Bangalore,India',
                          'Location',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Availability badge ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: _AvailabilityBanner(),
                ),
              ),

              // ── Message form ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 100),
                  child: _MessageForm(
                    formKey: _formKey,
                    nameCtrl: _nameCtrl,
                    emailCtrl: _emailCtrl,
                    messageCtrl: _messageCtrl,
                    sending: _sending,
                    onSend: _sendMessage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ContactHeader extends StatelessWidget {
  final double topPad;
  const _ContactHeader({required this.topPad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, topPad + 16, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.darkForest, AppTheme.deepSage],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppTheme.creamWhite,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              Text(
                'Contact',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.creamWhite,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Let's Grow\nSomething Together 🌱",
            style: GoogleFonts.playfairDisplay(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppTheme.creamWhite,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Whether it\'s a project, collaboration, or just a chat —\nI\'d love to hear from you.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppTheme.creamWhite.withValues(alpha: 0.75),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Contact Tile ──────────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppTheme.creamWhite,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: iconColor.withValues(alpha: 0.08),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: iconColor.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkForest,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12.5,
                          color: AppTheme.mutedGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: iconColor.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Availability Banner ───────────────────────────────────────────────────────

class _AvailabilityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sageGreen.withValues(alpha: 0.15),
            AppTheme.deepSage.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.sageGreen.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          // Pulsing availability dot
          _PulsingDot(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currently Available',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.deepSage,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Open to freelance projects and full-time opportunities.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.mutedGray,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: _anim.value),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3 * _anim.value),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Message Form ──────────────────────────────────────────────────────────────

class _MessageForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController messageCtrl;
  final bool sending;
  final VoidCallback onSend;

  const _MessageForm({
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.messageCtrl,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Send a Message',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.creamWhite,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                _FloralInput(
                  controller: nameCtrl,
                  label: 'Your Name',
                  icon: Icons.person_outline_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 16),

                // Email
                _FloralInput(
                  controller: emailCtrl,
                  label: 'Your Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!v.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Message
                _FloralInput(
                  controller: messageCtrl,
                  label: 'Your Message',
                  icon: Icons.chat_bubble_outline_rounded,
                  maxLines: 5,
                  validator: (v) => (v == null || v.trim().length < 10)
                      ? 'Please enter at least 10 characters'
                      : null,
                ),
                const SizedBox(height: 24),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: sending ? null : onSend,
                    icon: sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                    label: Text(sending ? 'Sending...' : 'Send Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.deepSage,
                      foregroundColor: AppTheme.creamWhite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FloralInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _FloralInput({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.darkForest),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          fontSize: 13,
          color: AppTheme.mutedGray,
        ),
        prefixIcon: Icon(icon, color: AppTheme.sageGreen, size: 20),
        filled: true,
        fillColor: AppTheme.warmCream.withValues(alpha: 0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppTheme.sageGreen.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppTheme.sageGreen.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.deepSage, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.dustyRose, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
