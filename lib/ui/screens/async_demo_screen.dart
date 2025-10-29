// lib/ui/screens/async_demo_screen.dart
// Visual demonstration of async concepts

import 'package:flutter/material.dart';

class AsyncDemoScreen extends StatefulWidget {
  const AsyncDemoScreen({super.key});

  @override
  State<AsyncDemoScreen> createState() => _AsyncDemoScreenState();
}

class _AsyncDemoScreenState extends State<AsyncDemoScreen> {
  String _status = 'Ready';
  bool _isLoading = false;
  List<String> _log = [];

  void _addLog(String message) {
    setState(() {
      _log.add('${DateTime.now().toIso8601String().split('T')[1].substring(0, 8)}: $message');
    });
  }

  // Demo 1: Sequential async operations
  Future<void> _demoSequential() async {
    setState(() {
      _isLoading = true;
      _status = 'Running Sequential Demo...';
      _log.clear();
    });

    final stopwatch = Stopwatch()..start();
    _addLog('Starting sequential operations');

    _addLog('Fetching user data...');
    await Future.delayed(Duration(seconds: 1));
    _addLog('✓ Got user data (1s)');

    _addLog('Fetching videos...');
    await Future.delayed(Duration(seconds: 2));
    _addLog('✓ Got videos (2s)');

    _addLog('Fetching workout history...');
    await Future.delayed(Duration(seconds: 1));
    _addLog('✓ Got history (1s)');

    stopwatch.stop();
    _addLog('Total time: ${stopwatch.elapsed.inSeconds}s');

    setState(() {
      _isLoading = false;
      _status = 'Sequential: ${stopwatch.elapsed.inSeconds}s total';
    });
  }

  // Demo 2: Parallel async operations
  Future<void> _demoParallel() async {
    setState(() {
      _isLoading = true;
      _status = 'Running Parallel Demo...';
      _log.clear();
    });

    final stopwatch = Stopwatch()..start();
    _addLog('Starting parallel operations');
    _addLog('Fetching user, videos, and history simultaneously...');

    await Future.wait([
      Future.delayed(Duration(seconds: 1)).then((_) => _addLog('✓ Got user data (1s)')),
      Future.delayed(Duration(seconds: 2)).then((_) => _addLog('✓ Got videos (2s)')),
      Future.delayed(Duration(seconds: 1)).then((_) => _addLog('✓ Got history (1s)')),
    ]);

    stopwatch.stop();
    _addLog('Total time: ${stopwatch.elapsed.inSeconds}s (much faster!)');

    setState(() {
      _isLoading = false;
      _status = 'Parallel: ${stopwatch.elapsed.inSeconds}s total';
    });
  }

  // Demo 3: Error handling
  Future<void> _demoErrorHandling() async {
    setState(() {
      _isLoading = true;
      _status = 'Running Error Handling Demo...';
      _log.clear();
    });

    _addLog('Attempting risky operation...');

    try {
      await Future.delayed(Duration(seconds: 1));
      _addLog('Operation in progress...');

      await Future.delayed(Duration(seconds: 1));
      throw Exception('Network connection failed!');
    } catch (e) {
      _addLog('❌ Error caught: $e');
      _addLog('App keeps running - no crash!');
    } finally {
      _addLog('Cleanup completed');
    }

    setState(() {
      _isLoading = false;
      _status = 'Error handled gracefully';
    });
  }

  // Demo 4: Stream (real-time updates)
  Future<void> _demoStream() async {
    setState(() {
      _isLoading = true;
      _status = 'Running Stream Demo...';
      _log.clear();
    });

    _addLog('Starting workout timer...');

    Stream<int> countdownStream() async* {
      for (int i = 5; i > 0; i--) {
        await Future.delayed(Duration(seconds: 1));
        yield i;
      }
    }

    await for (final seconds in countdownStream()) {
      _addLog('⏱️ $seconds seconds remaining...');
    }

    _addLog('🎉 Workout complete!');

    setState(() {
      _isLoading = false;
      _status = 'Stream demo complete';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Programming Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    if (_isLoading) const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _status,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Demo buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _demoSequential,
                  icon: const Icon(Icons.looks_one),
                  label: const Text('Sequential'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _demoParallel,
                  icon: const Icon(Icons.looks_two),
                  label: const Text('Parallel'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _demoErrorHandling,
                  icon: const Icon(Icons.warning),
                  label: const Text('Error Handling'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _demoStream,
                  icon: const Icon(Icons.timer),
                  label: const Text('Stream'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Log display
            Expanded(
              child: Card(
                child: _log.isEmpty
                    ? const Center(
                  child: Text(
                    'Tap a button to see async in action!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _log.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        _log[index],
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}