import 'package:cambaz_yay_secimi/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Makine kartındaki örnek Yay No 2 sonucunu verir', () {
    final result = calculateSpring(22, 0.30);

    expect(result.crossSection, 1.55);
    expect(result.coefficient, 25);
    expect(result.tension, 38.75);
    expect(result.spring?.number, 2);
  });

  test('SAMP için yalnızca sarım gerilimini hesaplar', () {
    final result = calculateSpring(22, 0.30, selectSpring: false);

    expect(result.crossSection, 1.55);
    expect(result.tension, 38.75);
    expect(result.spring, isNull);
    expect(result.noSpringRequired, isTrue);
  });
}
