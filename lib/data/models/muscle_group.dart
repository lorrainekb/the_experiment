// lib/data/models/muscle_group.dart

/// Represents the different muscle groups available for workouts
enum MuscleGroup {
  armsBack('Arms & Back'),
  chest('Chest'),
  core('Core & Glutes'),
  legs('Legs'),
  fullBody('Full Body');

  final String displayName;

  const MuscleGroup(this.displayName);

  /// Convert from string (useful for JSON deserialization)
  static MuscleGroup fromString(String value) {
    return MuscleGroup.values.firstWhere(
          (group) => group.name == value,
      orElse: () => MuscleGroup.core,
    );
  }
}