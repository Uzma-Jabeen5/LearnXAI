import 'package:flutter_test/flutter_test.dart';
import 'package:learnxai/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LearnXAIApp());

    // Verify that LearnXAIApp builds.
    expect(find.byType(LearnXAIApp), findsOneWidget);
  });
}
