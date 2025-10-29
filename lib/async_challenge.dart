// lib/async_challenge.dart
// WEEK 2 LAB CHALLENGE: Implement these async patterns

import 'dart:async';
import 'data/models/workout_video.dart';
import 'data/models/muscle_group.dart';

/// CHALLENGE 1: Fetch videos with timeout
/// If fetching takes longer than 5 seconds, show error
///
/// WHY: Instagram API might be slow - don't make users wait forever
Future<List<WorkoutVideo>> fetchVideosWithTimeout(
    Future<List<WorkoutVideo>> Function() fetchFunction,
    ) async {
  // TODO: Implement timeout logic
  // Hint: Use Future.timeout()

  try {
    return await fetchFunction().timeout(
      Duration(seconds: 5),
      onTimeout: () {
        throw TimeoutException('Fetching videos took too long');
      },
    );
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

/// CHALLENGE 2: Retry failed requests
/// If fetching fails, retry up to 3 times before giving up
///
/// WHY: Network requests can fail temporarily - retrying improves UX
Future<T> retryOperation<T>({
  required Future<T> Function() operation,
  int maxAttempts = 3,
  Duration delayBetweenAttempts = const Duration(seconds: 1),
}) async {
  int attempts = 0;

  while (attempts < maxAttempts) {
    try {
      attempts++;
      print('Attempt $attempts of $maxAttempts...');
      return await operation();
    } catch (e) {
      print('Attempt $attempts failed: $e');

      if (attempts >= maxAttempts) {
        print('Max attempts reached. Giving up.');
        rethrow;
      }

      // Wait before retrying
      await Future.delayed(delayBetweenAttempts);
    }
  }

  throw Exception('Should never reach here');
}

/// CHALLENGE 3: Cache results
/// Store fetched videos in memory to avoid re-fetching
///
/// WHY: Don't waste bandwidth re-fetching the same data
class VideoCache {
  final Map<MuscleGroup, List<WorkoutVideo>> _cache = {};
  final Map<MuscleGroup, DateTime> _cacheTimestamps = {};
  final Duration cacheExpiry = Duration(minutes: 5);

  Future<List<WorkoutVideo>> getVideos(
      MuscleGroup group,
      Future<List<WorkoutVideo>> Function() fetchFunction,
      ) async {
    // Check if we have cached data
    if (_cache.containsKey(group)) {
      final timestamp = _cacheTimestamps[group]!;
      final age = DateTime.now().difference(timestamp);

      // Cache still valid?
      if (age < cacheExpiry) {
        print('Cache hit! Returning cached videos for ${group.displayName}');
        return _cache[group]!;
      } else {
        print('Cache expired for ${group.displayName}');
      }
    }

    // Cache miss or expired - fetch fresh data
    print('Cache miss! Fetching videos for ${group.displayName}...');
    final videos = await fetchFunction();

    // Store in cache
    _cache[group] = videos;
    _cacheTimestamps[group] = DateTime.now();

    return videos;
  }

  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
    print('Cache cleared');
  }
}

/// CHALLENGE 4: Debounce search
/// When user types in search, wait for them to stop typing before searching
///
/// WHY: Don't make API calls for every keystroke - wait for user to finish
class SearchDebouncer {
  Timer? _timer;

  void debounce(
      Duration delay,
      void Function() action,
      ) {
    // Cancel previous timer
    _timer?.cancel();

    // Start new timer
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

// Example usage:
// final debouncer = SearchDebouncer();
//
// onSearchTextChanged(String query) {
//   debouncer.debounce(Duration(milliseconds: 500), () {
//     // Only runs if user stops typing for 500ms
//     performSearch(query);
//   });
// }

/// CHALLENGE 5: Stream for real-time workout tracking
/// Create a stream that emits workout progress every second
///
/// WHY: For live workout timer - shows current set, time remaining, etc.
class WorkoutProgressStream {
  Stream<WorkoutProgress> trackWorkout({
    required int totalSets,
    required int secondsPerSet,
  }) async* {
    for (int set = 1; set <= totalSets; set++) {
      for (int second = 0; second < secondsPerSet; second++) {
        await Future.delayed(Duration(seconds: 1));

        final progress = WorkoutProgress(
          currentSet: set,
          totalSets: totalSets,
          secondsIntoSet: second,
          totalSecondsPerSet: secondsPerSet,
        );

        yield progress; // Emit progress update
      }
    }
  }
}

class WorkoutProgress {
  final int currentSet;
  final int totalSets;
  final int secondsIntoSet;
  final int totalSecondsPerSet;

  WorkoutProgress({
    required this.currentSet,
    required this.totalSets,
    required this.secondsIntoSet,
    required this.totalSecondsPerSet,
  });

  double get overallProgress =>
      ((currentSet - 1) * totalSecondsPerSet + secondsIntoSet) /
          (totalSets * totalSecondsPerSet);

  @override
  String toString() =>
      'Set $currentSet/$totalSets - ${secondsIntoSet}s/${totalSecondsPerSet}s '
          '(${(overallProgress * 100).toStringAsFixed(1)}% complete)';
}

// Example test
void main() async {
  print('=== ASYNC CHALLENGES ===\n');

  // Test Challenge 5: Stream
  print('Challenge 5: Workout Progress Stream');
  final progressStream = WorkoutProgressStream();

  print('Starting 2 sets of 5 seconds each...\n');
  await for (final progress in progressStream.trackWorkout(
    totalSets: 2,
    secondsPerSet: 5,
  )) {
    print(progress);
  }

  print('\nWorkout complete! 💪');
}