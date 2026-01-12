import 'package:flutter/material.dart';
import '../models/pill_result.dart';

class InteractionScreen extends StatelessWidget {
  final List<PillResult> meds;

  const InteractionScreen({
    super.key,
    required this.meds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactions')),
      body: meds.isEmpty
          ? const Center(child: Text('No medications to check'))
          : ListView(
              children: meds
                  .map(
                    (m) => ListTile(
                      title: Text(m.name),
                      subtitle: Text(m.strength ?? ''),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}