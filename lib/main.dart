import 'package:flutter/material.dart';

import 'models/pill_result.dart';

import 'screens/home_screen.dart';
import 'screens/safety_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/manual_search_screen.dart';
import 'screens/current_meds_screen.dart';
import 'screens/interaction_screen.dart';
import 'screens/results_screen.dart';
import 'screens/pill_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PillIdApp());
}

class PillIdApp extends StatefulWidget {
  const PillIdApp({super.key});

  @override
  State<PillIdApp> createState() => _PillIdAppState();
}

class _PillIdAppState extends State<PillIdApp> {
  final List<PillResult> _currentMeds = <PillResult>[];

  List<PillResult> _asPillResultList(dynamic raw) {
    if (raw is List<PillResult>) return raw;
    if (raw is List) return raw.whereType<PillResult>().toList();
    return <PillResult>[];
  }

  PillResult? _asPillResult(dynamic raw) {
    if (raw is PillResult) return raw;
    return null;
  }

  void _addToMeds(PillResult pill) {
    setState(() {
      if (!_currentMeds.contains(pill)) _currentMeds.add(pill);
    });
  }

  void _removeFromMeds(PillResult pill) {
    setState(() {
      _currentMeds.remove(pill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pill ID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final name = settings.name ?? '/';
        final args = settings.arguments;

        if (name == '/') {
          return MaterialPageRoute(
            builder: (_) => HomeScreen(currentMeds: _currentMeds),
            settings: settings,
          );
        }

        if (name == '/safety') {
          return MaterialPageRoute(builder: (_) => const SafetyScreen(), settings: settings);
        }
        if (name == '/scan') {
          return MaterialPageRoute(builder: (_) => const ScanScreen(), settings: settings);
        }
        if (name == '/manual') {
          return MaterialPageRoute(builder: (_) => const ManualSearchScreen(), settings: settings);
        }

        if (name == '/current-meds') {
          final raw = (args is Map ? (args['meds'] ?? args['currentMeds']) : args);
          final meds = raw == null ? _currentMeds : _asPillResultList(raw);
          return MaterialPageRoute(
            builder: (_) => CurrentMedsScreen(
              meds: meds,
              onRemove: _removeFromMeds,
            ),
            settings: settings,
          );
        }

        if (name == '/interactions') {
          final raw = (args is Map ? args['meds'] : args);
          final meds = raw == null ? _currentMeds : _asPillResultList(raw);
          return MaterialPageRoute(
            builder: (_) => InteractionScreen(meds: meds),
            settings: settings,
          );
        }

        if (name == '/results') {
          final raw = (args is Map ? args['results'] : args);
          final results = _asPillResultList(raw);
          return MaterialPageRoute(
            builder: (_) => ResultsScreen(results: results),
            settings: settings,
          );
        }

        if (name == '/pill-detail') {
          final raw = (args is Map ? (args['result'] ?? args['pill']) : args);
          final result = _asPillResult(raw);

          if (result == null) {
            return MaterialPageRoute(
              builder: (_) => const _MissingArgsScreen(
                routeName: '/pill-detail',
                needed: 'result (PillResult)',
              ),
              settings: settings,
            );
          }

          return MaterialPageRoute(
            builder: (_) => PillDetailScreen(
              result: result,
              onAddToMeds: _addToMeds,
            ),
            settings: settings,
          );
        }

        return MaterialPageRoute(
          builder: (_) => _UnknownRouteScreen(routeName: name),
          settings: settings,
        );
      },
    );
  }
}

class _MissingArgsScreen extends StatelessWidget {
  final String routeName;
  final String needed;
  const _MissingArgsScreen({required this.routeName, required this.needed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation error')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Tried to open $routeName but missing/invalid required argument: $needed\n\n'
          'Fix: pass it using Navigator.pushNamed(..., arguments: ...).',
        ),
      ),
    );
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  final String routeName;
  const _UnknownRouteScreen({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unknown route')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('No route defined for: $routeName'),
      ),
    );
  }
}
