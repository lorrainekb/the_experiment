// lib/data/repositories/firebase_video_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_video.dart';
import '../models/muscle_group.dart';
import 'video_repository.dart';

/// Firebase implementation of VideoRepository
/// Stores workout videos in Firestore cloud database
class FirebaseVideoRepository implements VideoRepository {
  final FirebaseFirestore _firestore;
  final String _userId;

  // Collection path: users/{userId}/videos
  late final CollectionReference _videosCollection;

  FirebaseVideoRepository({
    FirebaseFirestore? firestore,
    required String userId,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _userId = userId {
    _videosCollection = _firestore
        .collection('users')
        .doc(_userId)
        .collection('videos');
  }

  @override
  Future<List<WorkoutVideo>> getVideosByMuscleGroup(MuscleGroup group) async {
    try {
      // Query Firestore for videos matching this muscle group
      final querySnapshot = await _videosCollection
          .where('muscleGroup', isEqualTo: group.name)
          .get();

      // Convert Firestore documents to WorkoutVideo objects
      return querySnapshot.docs
          .map((doc) => _videoFromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching videos by muscle group: $e');
      rethrow; // Re-throw so UI can handle error
    }
  }

  @override
  Future<WorkoutVideo?> getVideoById(String id) async {
    try {
      final docSnapshot = await _videosCollection.doc(id).get();

      if (!docSnapshot.exists) {
        return null; // Video not found
      }

      return _videoFromFirestore(docSnapshot);
    } catch (e) {
      print('Error fetching video by ID: $e');
      rethrow;
    }
  }

  @override
  Future<List<WorkoutVideo>> getAllVideos() async {
    try {
      final querySnapshot = await _videosCollection.get();

      return querySnapshot.docs
          .map((doc) => _videoFromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching all videos: $e');
      rethrow;
    }
  }

  @override
  Future<List<WorkoutVideo>> searchVideos(String query) async {
    try {
      // Firestore doesn't support full-text search natively
      // So we fetch all videos and filter in memory
      // For production, you'd use Algolia or similar
      final allVideos = await getAllVideos();

      final lowerQuery = query.toLowerCase();
      return allVideos
          .where((video) => video.title.toLowerCase().contains(lowerQuery))
          .toList();
    } catch (e) {
      print('Error searching videos: $e');
      rethrow;
    }
  }

  /// BONUS: Add a video to Firestore
  /// This isn't in the interface, but you'll need it to populate data
  Future<void> addVideo(WorkoutVideo video) async {
    try {
      await _videosCollection.doc(video.id).set(_videoToFirestore(video));
    } catch (e) {
      print('Error adding video: $e');
      rethrow;
    }
  }

  /// BONUS: Delete a video
  Future<void> deleteVideo(String videoId) async {
    try {
      await _videosCollection.doc(videoId).delete();
    } catch (e) {
      print('Error deleting video: $e');
      rethrow;
    }
  }

  // PRIVATE HELPER METHODS

  /// Convert Firestore document to WorkoutVideo object
  WorkoutVideo _videoFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return WorkoutVideo(
      id: doc.id,
      title: data['title'] as String,
      videoUrl: data['videoUrl'] as String,
      muscleGroup: MuscleGroup.fromString(data['muscleGroup'] as String),
      durationSeconds: data['durationSeconds'] as int,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert WorkoutVideo to Firestore-compatible map
  Map<String, dynamic> _videoToFirestore(WorkoutVideo video) {
    return {
      'title': video.title,
      'videoUrl': video.videoUrl,
      'muscleGroup': video.muscleGroup.name,
      'durationSeconds': video.durationSeconds,
      'thumbnailUrl': video.thumbnailUrl,
      'createdAt': Timestamp.fromDate(video.createdAt),
    };
  }
}