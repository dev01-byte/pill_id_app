import 'package:flutter/material.dart';
import '../services/pill_id_service.dart';
import '../models/pill_result.dart';
import 'results_screen.dart';

class ManualSearchScreen extends StatefulWidget {
  const ManualSearchScreen({super.key});

  @override
  State<ManualSearchScreen> createState() => _ManualSearchScreenState();
}

class _ManualSearchScreenState extends State<ManualSearchScreen> {
  final _controller = TextEditingController();
  final _service = PillIdService();

  bool _loading = false;
  String? _error;

  Future<void> _search() async {
    final imprint = _controller.text.trim();

    if (imprint.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // 🔑 THIS MATCHES YOUR ACTUAL SERVICE METHOD
      final List<PillResult> results =
          await _service.searchPills(imprint: imprint);

      if (!mounted) return;

      if (results.isEmpty) {
        setState(() {
          _error = 'No matches found';
          _loading = false;
        });
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(results: results),
        ),
      );
    } catch (e) {
      setState(() {
        _error = 'Search failed';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Pill imprint',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _search,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Search'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
