import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skillswap/models/models.dart';

class ReviewService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a review
  static Future<bool> createReview({
    required String sessionId,
    required String reviewerId,
    required String revieweeId,
    required double rating,
    required String feedback,
  }) async {
    try {
      final reviewId = _firestore.collection('reviews').doc().id;
      final review = Review(
        reviewId: reviewId,
        sessionId: sessionId,
        reviewerId: reviewerId,
        revieweeId: revieweeId,
        rating: rating,
        feedback: feedback,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('reviews').doc(reviewId).set(review.toMap());

      // Update user rating
      await _updateUserRating(revieweeId);

      return true;
    } catch (e) {
      print('Error creating review: $e');
      return false;
    }
  }

  // Get reviews for a user
  static Future<List<Review>> getUserReviews(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('revieweeId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => Review.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  // Get average rating for a user
  static Future<double> getUserAverageRating(String userId) async {
    try {
      final reviews = await getUserReviews(userId);
      if (reviews.isEmpty) return 0.0;

      final sum = reviews.fold<double>(0.0, (sum, review) => sum + review.rating);
      return sum / reviews.length;
    } catch (e) {
      print('Error calculating average rating: $e');
      return 0.0;
    }
  }

  // Update user rating in their profile
  static Future<void> _updateUserRating(String userId) async {
    try {
      final averageRating = await getUserAverageRating(userId);
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'rating': averageRating});
    } catch (e) {
      print('Error updating user rating: $e');
    }
  }

  // Check if review already exists for session
  static Future<bool> reviewExistsForSession(String sessionId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('sessionId', isEqualTo: sessionId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking review existence: $e');
      return false;
    }
  }
}
