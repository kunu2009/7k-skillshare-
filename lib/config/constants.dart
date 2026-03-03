// App Constants
class AppConstants {
  // App Info
  static const String appName = 'SkillSwap';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Learn Anything. Teach Everything.';

  // Agora Configuration
  static const String agoraAppId = 'YOUR_AGORA_APP_ID';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration readTimeout = Duration(seconds: 30);

  // Pagination
  static const int pageSize = 20;
  static const int suggestionsLimit = 10;

  // Session Duration Options
  static const List<int> sessionDurations = [15, 30, 45, 60];

  // Skills (can be expanded)
  static const List<String> popularSkills = [
    'Programming',
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Music',
    'Guitar',
    'Piano',
    'Vocals',
    'Languages',
    'English',
    'Spanish',
    'French',
    'German',
    'Mandarin',
    'Design',
    'UI/UX Design',
    'Graphic Design',
    'Photography',
    'Fitness',
    'Yoga',
    'Meditation',
    'Cooking',
    'Baking',
    'Nutrition',
    'Writing',
    'Content Writing',
    'Business',
    'Marketing',
    'Sales',
    'Public Speaking',
    'Business Strategy',
  ];

  // Rating Categories
  static const List<String> ratingCategories = [
    'Knowledge',
    'Communication',
    'Punctuality',
    'Friendliness',
  ];

  // Error Messages
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError =
      'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';

  // Success Messages
  static const String connectionRequestSent = 'Connection request sent!';
  static const String connectionAccepted = 'Connection accepted!';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String sessionScheduled = 'Session scheduled successfully!';
  static const String reviewSubmitted = 'Review submitted successfully!';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String connectionsCollection = 'connections';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String sessionsCollection = 'sessions';
  static const String reviewsCollection = 'reviews';
  static const String notificationsCollection = 'notifications';

  // Connection Status
  static const String statusOnline = 'online';
  static const String statusOffline = 'offline';
  static const String statusAway = 'away';

  // Connection Request Status
  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusRejected = 'rejected';
  static const String statusBlocked = 'blocked';

  // Session Status
  static const String sessionPending = 'pending';
  static const String sessionAccepted = 'accepted';
  static const String sessionInProgress = 'in_progress';
  static const String sessionCompleted = 'completed';
  static const String sessionCancelled = 'cancelled';

  // Message Types
  static const String messageTypeText = 'text';
  static const String messageTypeFile = 'file';
  static const String messageTypeImage = 'image';

  // Permissions
  static const List<String> permissionTypes = ['chat', 'audio', 'video'];
}

// Validation rules
class ValidationRules {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minBioLength = 0;
  static const int maxBioLength = 500;
  static const int minSkillsRequired = 1;
  static const int maxSkillsAllowed = 10;

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= minPasswordLength &&
        password.length <= maxPasswordLength;
  }

  static bool isValidName(String name) {
    return name.length >= minNameLength && name.length <= maxNameLength;
  }

  static bool isValidBio(String bio) {
    return bio.length >= minBioLength && bio.length <= maxBioLength;
  }
}

// Date and time utilities
class DateTimeUtils {
  static String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static String formatSessionTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year;
  }

  static bool isYesterday(DateTime dateTime) {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return dateTime.day == yesterday.day &&
        dateTime.month == yesterday.month &&
        dateTime.year == yesterday.year;
  }
}

// String extensions
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
