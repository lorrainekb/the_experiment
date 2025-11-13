// lib/seed_data.dart
// TEMPORARY FILE - Run once to populate Firestore with test data

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/models/workout_video.dart';
import 'data/models/muscle_group.dart';
import 'data/repositories/firebase_video_repository.dart';

/// This script populates your Firestore with the mock data
/// Run it ONCE, then delete this file (or keep for reference)
Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🌱 Starting data seed...\n');

  // For now, use a test user ID
  // Later (Week 3 authentication), this will be the logged-in user
  const testUserId = 'test-user-123';

  final repository = FirebaseVideoRepository(userId: testUserId);

  // Your mock videos from LocalVideoRepository
  final mockVideos = [
    // Arms & Back
    WorkoutVideo(
      id: '1',
      title: 'Bicep Curls',
      videoUrl: 'assets/videos/bicep_curls.mp4',
      muscleGroup: MuscleGroup.armsBack,
      durationSeconds: 180,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    WorkoutVideo(
      id: '2',
      title: 'Tricep Dips',
      videoUrl: 'assets/videos/tricep_dips.mp4',
      muscleGroup: MuscleGroup.armsBack,
      durationSeconds: 240,
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    WorkoutVideo(
      id: '3',
      title: 'Bent Over Rows',
      videoUrl: 'assets/videos/bent_rows.mp4',
      muscleGroup: MuscleGroup.armsBack,
      durationSeconds: 300,
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

  // Add each video to Firestore
  for (final video in mockVideos) {
    print('Adding: ${video.title}...');
    await repository.addVideo(video);
  }

  print('\n✅ Seed complete! Added ${mockVideos.length} videos to Firestore.');
  print('Check Firebase Console: https://console.firebase.google.com/project/the-experiment-workout/firestore');
  print('\n🗑️  You can delete this file now (or keep for reference).');
}