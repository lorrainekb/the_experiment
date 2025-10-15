// lib/test_models.dart (temporary)
import 'data/models/muscle_group.dart';
import 'data/models/workout_video.dart';

void main() {
  final video = WorkoutVideo(
    id: '1',
    title: 'Bicep Curls',
    videoUrl: 'local/path/bicep.mp4',
    muscleGroup: MuscleGroup.armsBack,
    durationSeconds: 180, // 3 minutes
    createdAt: DateTime.now(),
  );

  print(video); // Should print nicely formatted info
  print('Duration: ${video.durationMinutes} minutes');
}