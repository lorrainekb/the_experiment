// lib/ui/widgets/muscle_group_selector.dart

import 'package:flutter/material.dart';
import '../../data/models/muscle_group.dart';

/// Widget for selecting a muscle group
/// Displays 5 buttons in a grid layout
class MuscleGroupSelector extends StatelessWidget {
  final MuscleGroup? selectedGroup;
  final Function(MuscleGroup) onGroupSelected;

  const MuscleGroupSelector({
    super.key,
    required this.selectedGroup,
    required this.onGroupSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What area do you want to work?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Grid layout: 2 columns for first 4, full width for last one
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _MuscleGroupButton(
                    group: MuscleGroup.armsBack,
                    isSelected: selectedGroup == MuscleGroup.armsBack,
                    onTap: () => onGroupSelected(MuscleGroup.armsBack),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MuscleGroupButton(
                    group: MuscleGroup.chest,
                    isSelected: selectedGroup == MuscleGroup.chest,
                    onTap: () => onGroupSelected(MuscleGroup.chest),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MuscleGroupButton(
                    group: MuscleGroup.core,
                    isSelected: selectedGroup == MuscleGroup.core,
                    onTap: () => onGroupSelected(MuscleGroup.core),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MuscleGroupButton(
                    group: MuscleGroup.legs,
                    isSelected: selectedGroup == MuscleGroup.legs,
                    onTap: () => onGroupSelected(MuscleGroup.legs),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MuscleGroupButton(
              group: MuscleGroup.fullBody,
              isSelected: selectedGroup == MuscleGroup.fullBody,
              onTap: () => onGroupSelected(MuscleGroup.fullBody),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual button for a muscle group
class _MuscleGroupButton extends StatelessWidget {
  final MuscleGroup group;
  final bool isSelected;
  final VoidCallback onTap;

  const _MuscleGroupButton({
    required this.group,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            group.displayName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}