import 'package:flutter/material.dart';
import '../models/pill_result.dart';

class CurrentMedsScreen extends StatelessWidget {
  final List<PillResult> meds;
  final void Function(PillResult) onRemove;

  const CurrentMedsScreen({
    super.key,
    required this.meds,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Meds')),
      body: meds.isEmpty
          ? const Center(child: Text('No meds saved yet. Add one from Pill Detail.'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: meds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final pill = meds[i];
                final d = pill as dynamic;

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
                  'Saved medication',
                ]);

                final imprint = safe(() => d.imprint);
                final subtitle = imprint.isEmpty ? '' : 'Imprint: $imprint';

                return Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: subtitle.isEmpty ? null : Text(subtitle),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        onRemove(pill);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed from Current Meds')),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/pill-detail',
                        arguments: {'result': pill},
                      );
                    },
                  ),
                );
              },
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
