import 'package:flutter/material.dart';
import '../models/pill_result.dart';

class HomeScreen extends StatelessWidget {
  final List<PillResult> currentMeds;

  const HomeScreen({super.key, required this.currentMeds});

  @override
  Widget build(BuildContext context) {
    final medsCount = currentMeds.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pill ID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Current meds saved: $medsCount',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            // MAIN ACTIONS
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/scan'),
              child: const Text('Scan Pill (Camera)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/manual'),
              child: const Text('Manual Search'),
            ),
            const SizedBox(height: 24),

            // SAFETY / MEDS
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/safety'),
              child: const Text('Safety / Interactions'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/current-meds'),
              child: const Text('View Current Meds'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/interactions'),
              child: const Text('Check Interactions'),
            ),

            const Spacer(),

            Text(
              'Tip: Use Safety to review interactions before taking a new med.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
