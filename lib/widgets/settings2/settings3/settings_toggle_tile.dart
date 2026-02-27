import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsToggleTile extends StatefulWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String storageKey;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.storageKey,
  });

  @override
  State<SettingsToggleTile> createState() => _SettingsToggleTileState();
}

class _SettingsToggleTileState extends State<SettingsToggleTile> {
  static const _storage = FlutterSecureStorage();
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final value = await _storage.read(key: widget.storageKey);
    if (mounted) setState(() => _isEnabled = value == 'true');
  }

  Future<void> _onToggle(bool value) async {
    setState(() => _isEnabled = value);
    await _storage.write(
        key: widget.storageKey, value: value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: widget.iconBgColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(widget.icon, size: 20, color: widget.iconBgColor),
          ),
          const SizedBox(width: 14),

          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

        
          Switch(
            value: _isEnabled,
            onChanged: _onToggle,
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}