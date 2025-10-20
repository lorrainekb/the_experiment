// lib/logic/services/workout_generator_service.dart

import 'package:uuid/uuid.dart';
import '../../data/models/workout_video.dart';
import '../../data/models/workout_plan.dart';
import '../../data/models/muscle_group.dart';

/// Service for generating workout plans based on user preferences
class WorkoutGeneratorService {
  static const _uuid = Uuid();

  /// Generate a workout plan based on time and muscle group
  WorkoutPlan generatePlan({
    required int targetMinutes,
    required MuscleGroup muscleGroup,
    required List<WorkoutVideo> availableVideos,
  }) {
    // Determine sets and cardio based on time
    final int sets;
    final bool includeCardio;

    if (targetMinutes <= 15) {
      sets = 2;
      includeCardio = false;
    } else if (targetMinutes <= 25) {
      sets = 3;
      includeCardio = false;
    } else {
      sets = 4;
      includeCardio = true;
    }

    // Filter videos for the selected muscle group
    final groupVideos = availableVideos
        .where((video) => video.muscleGroup == muscleGroup)
        .toList();

    // Select 3 exercises (or fewer if not enough available)
    final selectedExercises = _selectExercises(groupVideos, count: 3);

    return WorkoutPlan(
      id: _uuid.v4(),
      focusArea: muscleGroup,
      targetMinutes: targetMinutes,
      exercises: selectedExercises,
      setsPerExercise: sets,
      includeCardio: includeCardio,
      createdAt: DateTime.now(),
    );
  }

  /// Select a number of exercises from available videos
  /// Tries to vary durations for better workout balance
  List<WorkoutVideo> _selectExercises(List<WorkoutVideo> videos, {required int count}) {
    if (videos.isEmpty) return [];
    if (videos.length <= count) return videos;

    // Sort by duration to get variety (short, medium, long)
    final sorted = List<WorkoutVideo>.from(videos)
      ..sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));

    final selected = <WorkoutVideo>[];

    // Try to pick from different duration ranges
    if (sorted.length >= 3) {
      selected.add(sorted[0]); // Shortest
      selected.add(sorted[sorted.length ~/ 2]); // Medium
      selected.add(sorted[sorted.length - 1]); // Longest
    } else {
      selected.addAll(sorted.take(count));
    }

    return selected.take(count).toList();
  }
}