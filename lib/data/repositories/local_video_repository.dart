// lib/data/repositories/local_video_repository.dart

import '../models/workout_video.dart';
import '../models/muscle_group.dart';
import 'video_repository.dart';

/// Local implementation of VideoRepository using hardcoded mock data
/// Later, you'll create InstagramVideoRepository and FirebaseVideoRepository
/// that implement the same interface
class LocalVideoRepository implements VideoRepository {

  // Mock data - simulates your Instagram workout videos
  // Replace these with your actual video URLs when you integrate the API
  static final List<WorkoutVideo> _mockVideos = [
    // Arms & Back
    WorkoutVideo(
      id: '1',
      title: 'Bicep Curls',
      videoUrl: 'assets/videos/bicep_curls.mp4', // placeholder path
      muscleGroup: MuscleGroup.armsBack,
      durationSeconds: 180, // 3 minutes
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    WorkoutVideo(
      id: '2',
      title: 'Tricep Dips',
      videoUrl: 'assets/videos/tricep_dips.mp4',
      muscleGroup: MuscleGroup.armsBack,
      durationSeconds: 240, // 4 minutes
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    WorkoutVideo(
      id: '3',
      title: 'Bent Over Rows',
      videoUrl: 'assets/videos/bent_rows.mp4',
      muscleGroup: MuscleGroup.armsBack,
      durationSeconds: 300, // 5 minutes
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),

    // Chest
    WorkoutVideo(
      id: '4',
      title: 'Push Ups',
      videoUrl: 'assets/videos/push_ups.mp4',
      muscleGroup: MuscleGroup.chest,
      durationSeconds: 180,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    WorkoutVideo(
      id: '5',
      title: 'Chest Press',
      videoUrl: 'assets/videos/chest_press.mp4',
      muscleGroup: MuscleGroup.chest,
      durationSeconds: 240,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    WorkoutVideo(
      id: '6',
      title: 'Chest Flys',
      videoUrl: 'assets/videos/chest_flys.mp4',
      muscleGroup: MuscleGroup.chest,
      durationSeconds: 210,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    // Core & Glutes
    WorkoutVideo(
      id: '7',
      title: 'Plank Hold',
      videoUrl: 'assets/videos/plank.mp4',
      muscleGroup: MuscleGroup.core,
      durationSeconds: 120,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    WorkoutVideo(
      id: '8',
      title: 'Russian Twists',
      videoUrl: 'assets/videos/russian_twists.mp4',
      muscleGroup: MuscleGroup.core,
      durationSeconds: 180,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    WorkoutVideo(
      id: '9',
      title: 'Glute Bridges',
      videoUrl: 'assets/videos/glute_bridges.mp4',
      muscleGroup: MuscleGroup.core,
      durationSeconds: 240,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // Legs
    WorkoutVideo(
      id: '10',
      title: 'Squats',
      videoUrl: 'assets/videos/squats.mp4',
      muscleGroup: MuscleGroup.legs,
      durationSeconds: 300,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    WorkoutVideo(
      id: '11',
      title: 'Lunges',
      videoUrl: 'assets/videos/lunges.mp4',
      muscleGroup: MuscleGroup.legs,
      durationSeconds: 240,
      createdAt: DateTime.now(),
    ),
    WorkoutVideo(
      id: '12',
      title: 'Calf Raises',
      videoUrl: 'assets/videos/calf_raises.mp4',
      muscleGroup: MuscleGroup.legs,
      durationSeconds: 180,
      createdAt: DateTime.now(),
    ),

    // Full Body
    WorkoutVideo(
      id: '13',
      title: 'Burpees',
      videoUrl: 'assets/videos/burpees.mp4',
      muscleGroup: MuscleGroup.fullBody,
      durationSeconds: 300,
      createdAt: DateTime.now(),
    ),
    WorkoutVideo(
      id: '14',
      title: 'Mountain Climbers',
      videoUrl: 'assets/videos/mountain_climbers.mp4',
      muscleGroup: MuscleGroup.fullBody,
      durationSeconds: 240,
      createdAt: DateTime.now(),
    ),
    WorkoutVideo(
      id: '15',
      title: 'Jumping Jacks',
      videoUrl: 'assets/videos/jumping_jacks.mp4',
      muscleGroup: MuscleGroup.fullBody,
      durationSeconds: 180,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<WorkoutVideo>> getVideosByMuscleGroup(MuscleGroup group) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockVideos
        .where((video) => video.muscleGroup == group)
        .toList();
  }

  @override
  Future<WorkoutVideo?> getVideoById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _mockVideos.firstWhere((video) => video.id == id);
    } catch (e) {
      return null; // Video not found
    }
  }

  @override
  Future<List<WorkoutVideo>> getAllVideos() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockVideos); // Return a copy
  }

  @override
  Future<List<WorkoutVideo>> searchVideos(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final lowerQuery = query.toLowerCase();
    return _mockVideos
        .where((video) =>
        video.title.toLowerCase().contains(lowerQuery))
        .toList();
  }
}