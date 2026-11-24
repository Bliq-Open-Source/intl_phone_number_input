import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intlphonenumberinputtest/main.dart';

void main() {
  testWidgets('shows the phone input demo', (tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Demo'), findsOneWidget);
    expect(find.byType(InternationalPhoneNumberInput), findsOneWidget);
  });
}
