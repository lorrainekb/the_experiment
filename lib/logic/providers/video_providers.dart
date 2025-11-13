// lib/logic/providers/video_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/workout_video.dart';
import '../../data/models/muscle_group.dart';
import '../../data/repositories/firebase_video_repository.dart';
import '../../data/repositories/video_repository.dart';
import '../../data/repositories/local_video_repository.dart';
import 'auth_providers.dart';

/// Provider for the VideoRepository
/// This is the ONLY place where we specify which implementation to use
/// Change this one line to switch from local → Instagram API → Firebase
final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  final userId = ref.watch(currentUserIdProvider);

  if (userId == null) {
    // User not logged in - return empty repository
    return LocalVideoRepository(); // Fallback to local (or could throw error)
  }

  return FirebaseVideoRepository(userId: userId); // Use real user ID!
});

/// Provider to get all videos
/// Use this in your UI: ref.watch(allVideosProvider)
final allVideosProvider = FutureProvider<List<WorkoutVideo>>((ref) async {
  final repository = ref.watch(videoRepositoryProvider);
  return repository.getAllVideos();
});

/// Provider to get videos by muscle group
/// Usage: ref.watch(videosByMuscleGroupProvider(MuscleGroup.armsBack))
final videosByMuscleGroupProvider =
FutureProvider.family<List<WorkoutVideo>, MuscleGroup>((ref, muscleGroup) async {
  final repository = ref.watch(videoRepositoryProvider);
  return repository.getVideosByMuscleGroup(muscleGroup);
});

/// Provider to get a single video by ID
/// Usage: ref.watch(videoByIdProvider('1'))
final videoByIdProvider =
FutureProvider.family<WorkoutVideo?, String>((ref, id) async {
  final repository = ref.watch(videoRepositoryProvider);
  return repository.getVideoById(id);
});

/// Provider for video search
/// Usage: ref.watch(searchVideosProvider('bicep'))
final searchVideosProvider =
FutureProvider.family<List<WorkoutVideo>, String>((ref, query) async {
  final repository = ref.watch(videoRepositoryProvider);
  return repository.searchVideos(query);
});