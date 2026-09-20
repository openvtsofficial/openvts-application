import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Always-visible credit for the standard OpenStreetMap layer.
///
/// Other providers require their own approved branding, data attributions and
/// access agreements. A generic label must not be treated as satisfying those
/// requirements. Position this above any controls that could obscure the map.
class OpenVtsMapAttribution extends StatelessWidget {
  const OpenVtsMapAttribution({
    required this.layerId,
    this.alignment = Alignment.bottomRight,
    this.padding = const EdgeInsets.all(4),
    super.key,
  });

  final String layerId;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    if (layerId != 'osm') return const SizedBox.shrink();

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          child: Semantics(
            link: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(3),
              onTap: () => _openCopyright(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  '© OpenStreetMap contributors',
                  style: TextStyle(
                    color: Color(0xFF1A365D),
                    fontSize: 12,
                    height: 1.25,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openCopyright(BuildContext context) async {
    try {
      final opened = await launchUrl(
        Uri.parse('https://www.openstreetmap.org/copyright'),
        mode: LaunchMode.externalApplication,
      );
      if (opened) return;
    } catch (_) {
      // Keep the map usable if this device cannot launch an external browser.
    }

    if (context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Unable to open map licence information.')),
      );
    }
  }
}
