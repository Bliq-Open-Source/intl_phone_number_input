import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets(
      'opens country search and edits a number in ${brightness.name}',
      (tester) async {
        final numbers = <PhoneNumber>[];
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: brightness),
            locale: const Locale('es'),
            supportedLocales: const [Locale('es')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: Scaffold(
              body: InternationalPhoneNumberInput(
                initialValue: PhoneNumber(isoCode: 'DE'),
                countries: const ['DE', 'ES'],
                locale: 'es',
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  setSelectorButtonAsPrefixIcon: true,
                  showFlags: false,
                ),
                inputDecoration: const InputDecoration(labelText: 'Número'),
                searchBoxDecoration: const InputDecoration(
                  labelText: 'Buscar país',
                ),
                formatInput: false,
                onInputChanged: numbers.add,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(Key(TestHelper.DropdownButtonKeyValue)));
        await tester.pumpAndSettle();
        final search = find.byKey(Key(TestHelper.CountrySearchInputKeyValue));
        expect(find.text('Buscar país'), findsOneWidget);
        expect(
          Localizations.localeOf(tester.element(search)).languageCode,
          'es',
        );
        expect(Theme.of(tester.element(search)).brightness, brightness);

        await tester.enterText(search, 'España');
        await tester.pumpAndSettle();
        final spain = find.byKey(Key(TestHelper.countryItemKeyValue('ES')));
        expect(spain, findsOneWidget);
        expect(
          find.byKey(Key(TestHelper.countryItemKeyValue('DE'))),
          findsNothing,
        );
        await tester.tap(spain);
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), '612345678');
        await tester.pumpAndSettle();
        expect(numbers.last.isoCode, 'ES');
        expect(numbers.last.phoneNumber, '+34612345678');
      },
    );
  }
}
