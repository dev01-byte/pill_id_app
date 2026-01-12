import 'package:flutter/material.dart';
import '../models/pill_result.dart';

class ResultsScreen extends StatelessWidget {
  final List<PillResult> results;

  const ResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: results.isEmpty
          ? const Center(child: Text('No results found. Try another search.'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final r = results[i];
                final d = r as dynamic; // <- avoids "getter not defined" compile errors

                // Title: try a bunch of likely fields, fall back to imprint
                final title = _firstNonEmpty([
                  _safe(() => d.name),
                  _safe(() => d.drugName),
                  _safe(() => d.productName),
                  _safe(() => d.displayName),
                  _safe(() => d.generic),
                  _safe(() => d.brand),
                  _safe(() => d.imprint),
                  'Pill result',
                ]);

                // Subtitle: useful pill identifiers
                final imprint = _safe(() => d.imprint);
                final color = _safe(() => d.color);
                final shape = _safe(() => d.shape);
                final strength = _safe(() => d.strength);

                final subtitleParts = <String>[
                  if (imprint.isNotEmpty) 'Imprint: $imprint',
                  if (color.isNotEmpty) 'Color: $color',
                  if (shape.isNotEmpty) 'Shape: $shape',
                  if (strength.isNotEmpty) 'Strength: $strength',
                ];

                final subtitle = subtitleParts.join(' • ');

                return Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: subtitle.isEmpty ? null : Text(subtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/pill-detail',
                        arguments: {'result': r},
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  // Accept ANY return type (String, String?, int, etc) without type errors.
  String _safe(Object? Function() getter) {
    try {
      final v = getter();
      if (v == null) return '';
      final s = v.toString().trim();
      return (s == 'null') ? '' : s;
    } catch (_) {
      return '';
    }
  }

  String _firstNonEmpty(List<String> values) {
    for (final v in values) {
      final s = v.trim();
      if (s.isNotEmpty) return s;
    }
    return '';
  }
}
