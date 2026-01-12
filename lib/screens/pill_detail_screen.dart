import 'package:flutter/material.dart';
import '../models/pill_result.dart';

class PillDetailScreen extends StatelessWidget {
  final PillResult result;
  final void Function(PillResult) onAddToMeds;

  const PillDetailScreen({
    super.key,
    required this.result,
    required this.onAddToMeds,
  });

  @override
  Widget build(BuildContext context) {
    final d = result as dynamic;

    String safe(Object? Function() getter) {
      try {
        final v = getter();
        if (v == null) return '';
        final s = v.toString().trim();
        return (s == 'null') ? '' : s;
      } catch (_) {
        return '';
      }
    }

    final title = _firstNonEmpty([
      safe(() => d.name),
      safe(() => d.drugName),
      safe(() => d.productName),
      safe(() => d.displayName),
      safe(() => d.imprint),
      'Pill Detail',
    ]);

    final details = <MapEntry<String, String>>[
      MapEntry('Imprint', safe(() => d.imprint)),
      MapEntry('Color', safe(() => d.color)),
      MapEntry('Shape', safe(() => d.shape)),
      MapEntry('Strength', safe(() => d.strength)),
      MapEntry('Manufacturer', safe(() => d.manufacturer)),
      MapEntry('NDC', safe(() => d.ndc)),
    ].where((e) => e.value.trim().isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    for (final row in details) ...[
                      Text('${row.key}: ${row.value}'),
                      const SizedBox(height: 6),
                    ],
                    if (details.isEmpty)
                      const Text('No extra details available for this result.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                onAddToMeds(result);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to Current Meds')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add to Current Meds'),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/current-meds'),
              child: const Text('Go to Current Meds'),
            ),
          ],
        ),
      ),
    );
  }

  String _firstNonEmpty(List<String> values) {
    for (final v in values) {
      final s = v.trim();
      if (s.isNotEmpty) return s;
    }
    return '';
  }
}
