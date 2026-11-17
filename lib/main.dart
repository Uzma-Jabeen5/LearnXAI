import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/teacher/teacher_notifications_screen.dart';
import 'screens/admin/admin_logs_screen.dart';
import 'screens/admin/admin_users_screen.dart';
import 'screens/teacher/teacher_reports_screen.dart';
import 'screens/teacher/teacher_analytics_screen.dart';
import 'screens/teacher/teacher_tests_screen.dart';
import 'screens/teacher/teacher_notes_screen.dart';
import 'screens/course_details_screen.dart';
import 'screens/recommendations_screen.dart';
import 'screens/admin/admin_permissions_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/teacher/teacher_settings_screen.dart';
import 'screens/admin/admin_chatbot_screen.dart';
import 'screens/teacher/teacher_lectures_screen.dart';
import 'screens/teacher/teacher_dashboard_screen.dart';
import 'screens/teacher/teacher_create_course_screen.dart';
import 'screens/admin/admin_models_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/teacher/teacher_profile_screen.dart';
import 'screens/admin/admin_profile_screen.dart';
import 'screens/assessments_screen.dart';
import 'screens/teacher/teacher_recommendations_screen.dart';
import 'screens/admin/admin_announcements_screen.dart';
import 'screens/teacher/teacher_ai_insights_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/announcements_screen.dart';
import 'screens/admin/admin_config_screen.dart';
import 'screens/tests_screen.dart';
import 'screens/quiz_result_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_teachers_screen.dart';
import 'screens/assignments_screen.dart';
import 'screens/ai_tutor_screen.dart';
import 'screens/lesson_player_screen.dart';
import 'screens/teacher/teacher_quiz_builder_screen.dart';
import 'screens/admin/admin_notifications_screen.dart';
import 'screens/admin/admin_reports_screen.dart';
import 'screens/admin/admin_courses_screen.dart';
import 'screens/weak_topics_screen.dart';
import 'screens/syllabus_screen.dart';
import 'screens/my_courses_screen.dart';
import 'screens/explore_courses_screen.dart';
import 'screens/teacher/teacher_assignments_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/admin/admin_grand_test_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/new_password_screen.dart';
import 'screens/password_changed_screen.dart';
import 'screens/placeholder_screen.dart';

void main() {
  runApp(const LearnXAIApp());
}

class LearnXAIApp extends StatelessWidget {
  const LearnXAIApp({super.key});

  Widget _ph(String title, String route) =>
      PlaceholderScreen(title: title, route: route);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnXAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        // Auth flow (done)
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        '/otp': (context) => const OtpScreen(),
        '/new-password': (context) => const NewPasswordScreen(),
        '/password-changed': (context) => const PasswordChangedScreen(),

        // App screens (placeholders until built)
        '/dashboard': (context) => const DashboardScreen(),
        '/explore': (context) => const ExploreCoursesScreen(),
        '/courses': (context) => const MyCoursesScreen(),
        '/course-details': (context) => const CourseDetailsScreen(),
        '/syllabus': (context) => const SyllabusScreen(),
        '/lesson': (context) => const LessonPlayerScreen(),
        '/ai-tutor': (context) => const AiTutorScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/weak-topics': (context) => const WeakTopicsScreen(),
        '/assessments': (context) => const AssessmentsScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/quiz-result': (context) => const QuizResultScreen(),
        '/assignments': (context) => const AssignmentsScreen(),
        '/tests': (context) => const TestsScreen(),
        '/recommendations': (context) => const RecommendationsScreen(),
        '/announcements': (context) => const AnnouncementsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/teacher-recommendations': (context) => const TeacherRecommendationsScreen(),
        '/teacher-notifications': (context) => const TeacherNotificationsScreen(),
        '/teacher-profile': (context) => const TeacherProfileScreen(),
        '/teacher-settings': (context) => const TeacherSettingsScreen(),
        '/teacher-dashboard': (context) => const TeacherDashboardScreen(),
        '/teacher-create-course': (context) => const TeacherCreateCourseScreen(),
        '/teacher-notes': (context) => const TeacherNotesScreen(),
        '/teacher-lectures': (context) => const TeacherLecturesScreen(),
        '/teacher-quiz-builder': (context) => const TeacherQuizBuilderScreen(),
        '/teacher-assignments': (context) => const TeacherAssignmentsScreen(),
        '/teacher-tests': (context) => const TeacherTestsScreen(),
        '/teacher-analytics': (context) => const TeacherAnalyticsScreen(),
        '/teacher-reports': (context) => const TeacherReportsScreen(),
        '/teacher-ai-insights': (context) => const TeacherAiInsightsScreen(),

        // Admin screens (placeholders until built)
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
        '/admin-users': (context) => const AdminUsersScreen(),
        '/admin-teachers': (context) => const AdminTeachersScreen(),
        '/admin-courses': (context) => const AdminCoursesScreen(),
        '/admin-permissions': (context) => const AdminPermissionsScreen(),
        '/admin-models': (context) => const AdminModelsScreen(),
        '/admin-chatbot': (context) => const AdminChatbotScreen(),
        '/admin-logs': (context) => const AdminLogsScreen(),
        '/admin-reports': (context) => const AdminReportsScreen(),
        '/admin-grand-test': (context) => const AdminGrandTestScreen(),
        '/admin-announcements': (context) => const AdminAnnouncementsScreen(),
        '/admin-config': (context) => const AdminConfigScreen(),
        '/admin-notifications': (context) => const AdminNotificationsScreen(),
        '/admin-profile': (context) => const AdminProfileScreen(),
      },
    );
  }
}