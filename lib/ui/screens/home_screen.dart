// lib/ui/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/muscle_group.dart';
import '../../logic/providers/video_providers.dart';
import '../../logic/services/workout_generator_service.dart';
import '../widgets/muscle_group_selector.dart';
import '../widgets/duration_slider.dart';
import 'async_demo_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  MuscleGroup? _selectedGroup;
  int _durationMinutes = 20; // Default to 20 minutes
  final _workoutGenerator = WorkoutGeneratorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Experiment'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.school),
            tooltip: 'Async Learning',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AsyncDemoScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              const Text(
                'What if I don\'t give up?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s find out together',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Duration Slider
              DurationSlider(
                durationMinutes: _durationMinutes,
                onDurationChanged: (value) {
                  setState(() {
                    _durationMinutes = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Muscle Group Selector
              MuscleGroupSelector(
                selectedGroup: _selectedGroup,
                onGroupSelected: (group) {
                  setState(() {
                    _selectedGroup = group;
                  });
                },
              ),

              const Spacer(),

              // Generate Workout Button
              FilledButton(
                onPressed: _selectedGroup == null ? null : _generateWorkout,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Generate Workout'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _generateWorkout() async {
    if (_selectedGroup == null) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Fetch videos for selected muscle group
      final videos = await ref.read(
        videosByMuscleGroupProvider(_selectedGroup!).future,
      );

      // Generate workout plan
      final plan = _workoutGenerator.generatePlan(
        targetMinutes: _durationMinutes,
        muscleGroup: _selectedGroup!,
        availableVideos: videos,
      );

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show the workout plan
      _showWorkoutPlan(plan);
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating workout: $e')),
        );
      }
    }
  }

  void _showWorkoutPlan(plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${plan.focusArea.displayName} Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Target: ${plan.targetMinutes} minutes'),
            Text('Sets: ${plan.setsPerExercise} per exercise'),
            Text('Cardio: ${plan.includeCardio ? 'Yes' : 'No'}'),
            const SizedBox(height: 16),
            const Text(
              'Exercises:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...plan.exercises.map((video) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('• ${video.title} (${video.durationMinutes} min)'),
            )),
            const SizedBox(height: 16),
            Text(
              'Estimated total: ${plan.estimatedDurationMinutes} minutes',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to workout screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout screen coming soon!'),
                ),
              );
            },
            child: const Text('Start Workout'),
          ),
        ],
      ),
    );
  }
}