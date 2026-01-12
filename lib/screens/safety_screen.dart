import 'package:flutter/material.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Safety tools',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            const Text(
              '• Track your current meds\n'
              '• Check interactions\n'
              '• Review warnings before taking a medication',
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/current-meds'),
              child: const Text('Current Meds'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/interactions'),
              child: const Text('Check Interactions'),
            ),
            const SizedBox(height: 24),

            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
