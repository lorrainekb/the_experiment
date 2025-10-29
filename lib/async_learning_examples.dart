// lib/async_learning_examples.dart
// Run these examples to understand async programming deeply

import 'dart:async';

/// EXAMPLE 1: Basic Future
/// A Future represents a value that will be available later
void example1_basicFuture() {
  print('--- Example 1: Basic Future ---');

  // This returns immediately with a Future, not the actual value
  Future<String> futureMessage = Future.delayed(
    Duration(seconds: 2),
        () => 'Hello from the future!',
  );

  print('Future created (but not completed yet)');

  // To get the value, we use .then()
  futureMessage.then((message) {
    print('Future completed: $message');
  });

  print('This prints BEFORE the future completes!');
  // Output order:
  // 1. Future created
  // 2. This prints BEFORE...
  // 3. (2 seconds later) Future completed: Hello from the future!
}

/// EXAMPLE 2: async/await - Cleaner syntax
/// async/await makes async code look synchronous
Future<void> example2_asyncAwait() async {
  print('\n--- Example 2: async/await ---');

  print('Starting...');

  // await pauses THIS function until Future completes
  final message = await Future.delayed(
    Duration(seconds: 2),
        () => 'Hello from async/await!',
  );

  // This line waits for the above to complete
  print('Completed: $message');
  print('Done!');
  // Output order:
  // 1. Starting...
  // 2. (2 seconds later) Completed: Hello from async/await!
  // 3. Done!
}

/// EXAMPLE 3: Multiple Futures in Sequence
/// Each await pauses until complete
Future<void> example3_sequentialFutures() async {
  print('\n--- Example 3: Sequential Futures ---');

  final stopwatch = Stopwatch()..start();

  print('Fetching user...');
  final user = await _fetchUser(); // Takes 1 second
  print('Got user: $user');

  print('Fetching videos...');
  final videos = await _fetchVideos(); // Takes 2 seconds
  print('Got ${videos.length} videos');

  stopwatch.stop();
  print('Total time: ${stopwatch.elapsed.inSeconds} seconds'); // ~3 seconds

  // Why? Each await waits for previous to complete
}

/// EXAMPLE 4: Parallel Futures (FASTER!)
/// Use Future.wait() to run multiple futures simultaneously
Future<void> example4_parallelFutures() async {
  print('\n--- Example 4: Parallel Futures ---');

  final stopwatch = Stopwatch()..start();

  print('Fetching user AND videos at the same time...');

  // Both start immediately! Don't wait for each other
  final results = await Future.wait([
    _fetchUser(),    // Runs in parallel
    _fetchVideos(),  // Runs in parallel
  ]);

  final user = results[0];
  final videos = results[1];

  stopwatch.stop();
  print('Got user: $user');
  print('Got ${videos.length} videos');
  print('Total time: ${stopwatch.elapsed.inSeconds} seconds'); // ~2 seconds!

  // Why faster? They run at the same time, so total = longest one (2s)
}

/// EXAMPLE 5: Error Handling with try/catch
Future<void> example5_errorHandling() async {
  print('\n--- Example 5: Error Handling ---');

  try {
    print('Attempting risky operation...');
    final result = await _riskyOperation();
    print('Success: $result');
  } catch (e) {
    print('Caught error: $e');
    // Handle error gracefully - app doesn't crash!
  } finally {
    print('This always runs, error or not');
  }
}

/// EXAMPLE 6: Streams - Multiple values over time
/// A Stream is like a Future, but provides MULTIPLE values
Future<void> example6_streams() async {
  print('\n--- Example 6: Streams ---');

  print('Listening to workout progress...');

  // Stream emits values over time
  final progressStream = _workoutProgressStream();

  // Listen to each value as it arrives
  await for (final progress in progressStream) {
    print('Workout progress: $progress%');
  }

  print('Workout complete!');
}

/// EXAMPLE 7: Real-World Pattern - Your App!
/// This is how your video repository works
Future<void> example7_repositoryPattern() async {
  print('\n--- Example 7: Repository Pattern (Your App!) ---');

  try {
    print('User taps "Generate Workout"...');

    // Show loading indicator
    print('[UI] Showing loading spinner');

    // Fetch data asynchronously
    print('[Repository] Fetching videos from API...');
    final videos = await _fetchVideos();

    // Process data
    print('[Service] Generating workout plan...');
    await Future.delayed(Duration(milliseconds: 500)); // Simulate processing

    // Hide loading, show results
    print('[UI] Hide loading, show workout plan');
    print('[UI] Found ${videos.length} exercises!');

  } catch (e) {
    print('[UI] Show error message: $e');
  }
}

// Mock functions to simulate async operations
Future<String> _fetchUser() async {
  await Future.delayed(Duration(seconds: 1));
  return 'User123';
}

Future<List<String>> _fetchVideos() async {
  await Future.delayed(Duration(seconds: 2));
  return ['Video1', 'Video2', 'Video3'];
}

Future<String> _riskyOperation() async {
  await Future.delayed(Duration(seconds: 1));
  // Simulate an error
  throw Exception('Something went wrong!');
}

Stream<int> _workoutProgressStream() async* {
  // async* creates a Stream
  for (int i = 0; i <= 100; i += 20) {
    await Future.delayed(Duration(milliseconds: 500));
    yield i; // yield sends a value to the stream
  }
}

// Main runner - uncomment to test!
void main() async {
  // Run examples one at a time to see the difference

  example1_basicFuture();
  await Future.delayed(Duration(seconds: 3)); // Wait for example 1

  await example2_asyncAwait();

  await example3_sequentialFutures();

  await example4_parallelFutures();

  await example5_errorHandling();

  await example6_streams();

  await example7_repositoryPattern();
}