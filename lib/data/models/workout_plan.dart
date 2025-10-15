// lib/data/models/workout_plan.dart

import 'workout_video.dart';
import 'muscle_group.dart';

/// Represents a generated workout plan based on user preferences
class WorkoutPlan {
  final String id;
  final MuscleGroup focusArea;
  final int targetMinutes;
  final List<WorkoutVideo> exercises;
  final int setsPerExercise;
  final bool includeCardio;
  final DateTime createdAt;

  const WorkoutPlan({
    required this.id,
    required this.focusArea,
    required this.targetMinutes,
    required this.exercises,
    required this.setsPerExercise,
    required this.includeCardio,
    required this.createdAt,
  });

  /// Calculate estimated total duration
  int get estimatedDurationMinutes {
    int exerciseTime = exercises.fold(0, (sum, video) => sum + video.durationMinutes);
    int totalTime = exerciseTime * setsPerExercise;

    // Add cardio time if included (assume 5 min cardio)
    if (includeCardio) {
      totalTime += 5;
    }

    return totalTime;
  }

  /// Get total number of exercises
  int get totalExercises => exercises.length;

  /// Get total sets across all exercises
  int get totalSets => exercises.length * setsPerExercise;

  /// Create from JSON
  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'] as String,
      focusArea: MuscleGroup.fromString(json['focusArea'] as String),
      targetMinutes: json['targetMinutes'] as int,
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutVideo.fromJson(e as Map<String, dynamic>))
          .toList(),
      setsPerExercise: json['setsPerExercise'] as int,
      includeCardio: json['includeCardio'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'focusArea': focusArea.name,
      'targetMinutes': targetMinutes,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'setsPerExercise': setsPerExercise,
      'includeCardio': includeCardio,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields
  WorkoutPlan copyWith({
    String? id,
    MuscleGroup? focusArea,
    int? targetMinutes,
    List<WorkoutVideo>? exercises,
    int? setsPerExercise,
    bool? includeCardio,
    DateTime? createdAt,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      focusArea: focusArea ?? this.focusArea,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      exercises: exercises ?? this.exercises,
      setsPerExercise: setsPerExercise ?? this.setsPerExercise,
      includeCardio: includeCardio ?? this.includeCardio,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'WorkoutPlan(focusArea: ${focusArea.displayName}, '
        'exercises: ${exercises.length}, '
        'sets: $setsPerExercise, '
        'estimated: ${estimatedDurationMinutes}min)';
  }
}