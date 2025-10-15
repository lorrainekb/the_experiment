// lib/data/models/workout_video.dart

import 'muscle_group.dart';

/// Represents a single workout video
/// This model is data-source agnostic - it can come from local storage,
/// Instagram API, Firebase, etc.
class WorkoutVideo {
  final String id;
  final String title;
  final String videoUrl; // Can be local path, API URL, or Firebase URL
  final MuscleGroup muscleGroup;
  final int durationSeconds; // Store in seconds for flexibility
  final String? thumbnailUrl; // Optional thumbnail
  final DateTime createdAt; // For sorting and filtering

  const WorkoutVideo({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.muscleGroup,
    required this.durationSeconds,
    this.thumbnailUrl,
    required this.createdAt,
  });

  /// Convenience getter for duration in minutes (rounded)
  int get durationMinutes => (durationSeconds / 60).round();

  /// Create from JSON (useful when loading from local JSON or API)
  factory WorkoutVideo.fromJson(Map<String, dynamic> json) {
    return WorkoutVideo(
      id: json['id'] as String,
      title: json['title'] as String,
      videoUrl: json['videoUrl'] as String,
      muscleGroup: MuscleGroup.fromString(json['muscleGroup'] as String),
      durationSeconds: json['durationSeconds'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON (useful for caching or Firebase storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'videoUrl': videoUrl,
      'muscleGroup': muscleGroup.name,
      'durationSeconds': durationSeconds,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with modified fields (useful for updates)
  WorkoutVideo copyWith({
    String? id,
    String? title,
    String? videoUrl,
    MuscleGroup? muscleGroup,
    int? durationSeconds,
    String? thumbnailUrl,
    DateTime? createdAt,
  }) {
    return WorkoutVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      videoUrl: videoUrl ?? this.videoUrl,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'WorkoutVideo(id: $id, title: $title, muscleGroup: ${muscleGroup.displayName}, duration: ${durationMinutes}min)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutVideo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}