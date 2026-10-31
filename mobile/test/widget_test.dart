import 'package:cambaz_yay_secimi/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Makine seçim ekranı açılır', (WidgetTester tester) async {
    await tester.pumpWidget(const CambazYayApp());

    expect(find.text('MAKİNE SEÇİMİ'), findsOneWidget);
    expect(find.text('NIEHOFF D632'), findsOneWidget);
    expect(find.text('SAMP'), findsOneWidget);
  });
}
