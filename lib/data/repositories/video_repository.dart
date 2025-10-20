// lib/data/repositories/video_repository.dart

import '../models/workout_video.dart';
import '../models/muscle_group.dart';

/// Abstract interface for video data access
/// This allows us to swap implementations (local, API, Firebase)
/// without changing any code that uses it
abstract class VideoRepository {
  /// Get all videos for a specific muscle group
  Future<List<WorkoutVideo>> getVideosByMuscleGroup(MuscleGroup group);

  /// Get a single video by its ID
  Future<WorkoutVideo?> getVideoById(String id);

  /// Get all available videos
  Future<List<WorkoutVideo>> getAllVideos();

  /// Search videos by title
  Future<List<WorkoutVideo>> searchVideos(String query);
}