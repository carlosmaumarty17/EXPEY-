import 'package:flutter/material.dart';
import 'package:sentir/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _emailNotifications = false;
  bool _pushNotifications = true;
  bool _darkMode = false;
  String _language = 'Español';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.mediumGray,
                    AppColors.mediumGray.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.pureWhite),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Configuración',
                          style: TextStyle(
                            color: AppColors.pureWhite,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Personaliza tu experiencia',
                    style: TextStyle(
                      color: AppColors.pureWhite.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notificaciones Section
                      _buildSectionTitle('Notificaciones'),
                      const SizedBox(height: 12),
                      _buildSettingCard(
                        icon: Icons.notifications,
                        title: 'Notificaciones',
                        subtitle: 'Activar todas las notificaciones',
                        trailing: Switch(
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() => _notificationsEnabled = value);
                          },
                          activeColor: AppColors.jadeGreen,
                        ),
                      ),
                      _buildSettingCard(
                        icon: Icons.email,
                        title: 'Email',
                        subtitle: 'Recibir notificaciones por correo',
                        trailing: Switch(
                          value: _emailNotifications,
                          onChanged: (value) {
                            setState(() => _emailNotifications = value);
                          },
                          activeColor: AppColors.jadeGreen,
                        ),
                      ),
                      _buildSettingCard(
                        icon: Icons.phone_android,
                        title: 'Push',
                        subtitle: 'Notificaciones en el dispositivo',
                        trailing: Switch(
                          value: _pushNotifications,
                          onChanged: (value) {
                            setState(() => _pushNotifications = value);
                          },
                          activeColor: AppColors.jadeGreen,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Apariencia Section
                      _buildSectionTitle('Apariencia'),
                      const SizedBox(height: 12),
                      _buildSettingCard(
                        icon: Icons.dark_mode,
                        title: 'Modo oscuro',
                        subtitle: 'Cambiar tema de la aplicación',
                        trailing: Switch(
                          value: _darkMode,
                          onChanged: (value) {
                            setState(() => _darkMode = value);
                          },
                          activeColor: AppColors.jadeGreen,
                        ),
                      ),
                      _buildSettingCard(
                        icon: Icons.language,
                        title: 'Idioma',
                        subtitle: _language,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showLanguageDialog(),
                      ),

                      const SizedBox(height: 24),

                      // Cuenta Section
                      _buildSectionTitle('Cuenta'),
                      const SizedBox(height: 12),
                      _buildSettingCard(
                        icon: Icons.lock,
                        title: 'Cambiar contraseña',
                        subtitle: 'Actualizar tu contraseña',
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Función en desarrollo')),
                          );
                        },
                      ),
                      _buildSettingCard(
                        icon: Icons.privacy_tip,
                        title: 'Privacidad',
                        subtitle: 'Configuración de privacidad',
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Función en desarrollo')),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Soporte Section
                      _buildSectionTitle('Soporte'),
                      const SizedBox(height: 12),
                      _buildSettingCard(
                        icon: Icons.help,
                        title: 'Ayuda',
                        subtitle: 'Centro de ayuda y FAQs',
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Función en desarrollo')),
                          );
                        },
                      ),
                      _buildSettingCard(
                        icon: Icons.info,
                        title: 'Acerca de',
                        subtitle: 'Versión 1.0.0',
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showAboutDialog(),
                      ),

                      const SizedBox(height: 24),

                      // Logout Button
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.coral.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.coral.withValues(alpha: 0.3),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showLogoutDialog();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout, color: AppColors.coral),
                              const SizedBox(width: 12),
                              const Text(
                                'Cerrar sesión',
                                style: TextStyle(
                                  color: AppColors.coral,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkGray,
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGray.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.jadeGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.jadeGreen, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.mediumGray.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Español'),
            _buildLanguageOption('English'),
            _buildLanguageOption('Português'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String lang) {
    return ListTile(
      title: Text(lang),
      trailing: _language == lang
          ? const Icon(Icons.check, color: AppColors.jadeGreen)
          : null,
      onTap: () {
        setState(() => _language = lang);
        Navigator.pop(context);
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Acerca de EXPEYÁ'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 60, color: AppColors.coral),
            SizedBox(height: 16),
            Text(
              'EXPEYÁ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Versión 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Vive emociones, no viajes',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sesión cerrada')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.coral),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
