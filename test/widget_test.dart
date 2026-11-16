import 'package:flutter_test/flutter_test.dart';

import 'package:ministore/main.dart';

void main() {
  testWidgets('MiniStoreApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MiniStoreApp());

    // Verify that MiniStore title is present.
    expect(find.text('MiniStore'), findsOneWidget);
  });
}
