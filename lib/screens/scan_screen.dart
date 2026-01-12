import "package:flutter/material.dart";

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan (Camera + OCR)")),
      body: const Center(
        child: Text("Next phase: camera + OCR wiring."),
      ),
    );
  }
}
