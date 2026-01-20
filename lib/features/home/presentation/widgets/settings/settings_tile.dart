import 'package:flutter/material.dart';

/// Widget para elementos individuales de configuración
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.textColor,
    this.enabled = true,
  });

  /// Constructor para elementos con navegación
  factory SettingsTile.navigation({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? textColor,
    bool enabled = true,
  }) {
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      textColor: textColor,
      enabled: enabled,
    );
  }

  /// Constructor para elementos con switch
  factory SettingsTile.switchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
      enabled: enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled
              ? (textColor?.withOpacity(0.1) ?? Theme.of(context).primaryColor.withOpacity(0.1))
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: enabled ? (textColor ?? Theme.of(context).primaryColor) : Colors.grey,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: enabled ? textColor : Colors.grey,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: enabled ? Colors.grey[600] : Colors.grey[400],
              ),
            )
          : null,
      trailing: trailing,
      onTap: enabled ? onTap : null,
    );
  }
}
