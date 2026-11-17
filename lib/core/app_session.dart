enum UserRole { student, teacher, admin }

class AppSession {
  static UserRole role = UserRole.student;

  static bool get isTeacher => role == UserRole.teacher;
  static bool get isAdmin => role == UserRole.admin;

  /// Teacher and admin both use the dark sidebar.
  static bool get isDarkNav => isTeacher || isAdmin;

  static String get userName {
    if (isAdmin) return 'Platform Admin';
    if (isTeacher) return 'Dr. Ahmed Khan';
    return 'Farah Yameen';
  }

  static String get userSubtitle {
    if (isAdmin) return 'Root Authority';
    if (isTeacher) return 'Faculty Advisor • CS & AI';
    return 'CS Undergrad';
  }

  /// Where a user lands right after login.
  static String get home {
    if (isAdmin) return '/admin-dashboard';
    if (isTeacher) return '/teacher-dashboard';
    return '/dashboard';
  }

  /// Turns a shared route into the right one for the current role.
  static String resolve(String route) {
    if (isAdmin) {
      switch (route) {
        case '/dashboard':
          return '/admin-dashboard';
        case '/notifications':
          return '/admin-notifications';
        case '/profile':
          return '/admin-profile';
        case '/settings':
          return '/admin-config';
        default:
          return route;
      }
    }
    if (!isTeacher) return route;
    switch (route) {
      case '/dashboard':
        return '/teacher-dashboard';
      case '/recommendations':
        return '/teacher-recommendations';
      case '/notifications':
        return '/teacher-notifications';
      case '/profile':
        return '/teacher-profile';
      case '/settings':
        return '/teacher-settings';
      default:
        return route;
    }
  }
}