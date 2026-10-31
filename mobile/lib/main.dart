import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const CambazYayApp());

class CambazYayApp extends StatelessWidget {
  const CambazYayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cambaz Yay Seçimi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005B96),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),
      home: const SpringSelectorPage(),
    );
  }
}

class SpringSelectorPage extends StatefulWidget {
  const SpringSelectorPage({super.key});

  @override
  State<SpringSelectorPage> createState() => _SpringSelectorPageState();
}

enum MachineType { niehoffD632, samp }

class _SpringSelectorPageState extends State<SpringSelectorPage> {
  final _wireCountController = TextEditingController();
  final _diameterController = TextEditingController();
  SpringResult? _result;
  String? _wireCountError;
  String? _diameterError;
  MachineType? _selectedMachine;

  @override
  void dispose() {
    _wireCountController.dispose();
    _diameterController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_validateInputs(showEmptyErrors: true)) {
      setState(() => _result = null);
      return;
    }

    FocusScope.of(context).unfocus();
    final wireCount = int.parse(_wireCountController.text.trim());
    final diameter = double.parse(
      _diameterController.text.trim().replaceAll(',', '.'),
    );
    setState(() {
      _result = calculateSpring(
        wireCount,
        diameter,
        selectSpring: _selectedMachine == MachineType.niehoffD632,
      );
    });
  }

  void _clear() {
    FocusScope.of(context).unfocus();
    _wireCountController.clear();
    _diameterController.clear();
    setState(() {
      _result = null;
      _wireCountError = null;
      _diameterError = null;
    });
  }

  void _insertDecimalSeparator() {
    final value = _diameterController.value;
    if (value.text.contains(',') || value.text.contains('.')) return;

    final cursor = value.selection.baseOffset < 0
        ? value.text.length
        : value.selection.baseOffset;
    final newText =
        '${value.text.substring(0, cursor)},'
        '${value.text.substring(cursor)}';
    _diameterController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursor + 1),
    );
    _validateInputs(showEmptyErrors: false);
  }

  bool _validateInputs({required bool showEmptyErrors}) {
    final wireCountText = _wireCountController.text.trim();
    final diameterText = _diameterController.text.trim();
    final wireCount = int.tryParse(wireCountText);
    final diameter = double.tryParse(diameterText.replaceAll(',', '.'));

    setState(() {
      _wireCountError = wireCountText.isEmpty
          ? (showEmptyErrors ? 'Tel sayısını giriniz.' : null)
          : wireCount == null || wireCount <= 0
          ? 'Tel sayısı sıfırdan büyük bir tam sayı olmalıdır.'
          : null;
      _diameterError = diameterText.isEmpty
          ? (showEmptyErrors ? 'Tek tel çapını giriniz.' : null)
          : diameter == null || diameter <= 0
          ? 'Çap sıfırdan büyük olmalıdır. Örnek: 0,30'
          : null;
    });
    return _wireCountError == null && _diameterError == null;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedMachine == null) {
      return Scaffold(
        body: SafeArea(
          child: _MachineSelectionPage(
            onMachineSelected: (machine) =>
                setState(() => _selectedMachine = machine),
          ),
        ),
      );
    }

    final result = _result;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if ((details.primaryVelocity ?? 0) > 500) {
              setState(() {
                _selectedMachine = null;
                _result = null;
              });
            }
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() {
                    _selectedMachine = null;
                    _result = null;
                  }),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Makine seçimine dön'),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/mega_metal_logo_transparent.png',
                  width: 190,
                  height: 60,
                  fit: BoxFit.contain,
                  semanticLabel: 'Mega Metal',
                ),
              ),
              const Text(
                'CAMBAZ YAY SEÇİMİ',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                _selectedMachine == MachineType.samp
                    ? 'SAMP MAKİNESİ İÇİN'
                    : 'NIEHOFF D632 BÜKÜM MAKİNESİ İÇİN',
                style: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 28),
              _NumberField(
                controller: _wireCountController,
                label: 'Tel sayısı',
                hint: 'Örnek: 22',
                integer: true,
                errorText: _wireCountError,
                onChanged: (_) => _validateInputs(showEmptyErrors: false),
              ),
              const SizedBox(height: 16),
              _NumberField(
                controller: _diameterController,
                label: 'Tek tel çapı (mm)',
                hint: 'Örnek: 0,30 veya 0.30',
                errorText: _diameterError,
                onChanged: (_) => _validateInputs(showEmptyErrors: false),
                onDecimalPressed: _insertDecimalSeparator,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate_outlined),
                label: Text(
                  _selectedMachine == MachineType.samp
                      ? 'HESAPLA VE GERİLİMİ GÖSTER'
                      : 'HESAPLA VE YAYI GÖSTER',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('TEMİZLE / YENİ HESAPLAMA'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              if (result == null)
                _InformationCard(isSamp: _selectedMachine == MachineType.samp)
              else
                _ResultCard(result: result),
            ],
          ),
        ),
      ),
    );
  }
}

class _MachineSelectionPage extends StatelessWidget {
  const _MachineSelectionPage({required this.onMachineSelected});

  final ValueChanged<MachineType> onMachineSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 32),
      children: [
        Center(
          child: Image.asset(
            'assets/mega_metal_logo_transparent.png',
            width: 280,
            height: 115,
            fit: BoxFit.contain,
            semanticLabel: 'Mega Metal',
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'MAKİNE SEÇİMİ',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Cambaz yay hesabı yapacağınız makineyi seçin.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 16),
        ),
        const SizedBox(height: 30),
        _MachineCard(
          name: 'NIEHOFF D632',
          description: 'Büküm makinesi',
          onTap: () => onMachineSelected(MachineType.niehoffD632),
        ),
        const SizedBox(height: 14),
        _MachineCard(
          name: 'SAMP',
          description: 'Sarım gerilimi hesabı',
          onTap: () => onMachineSelected(MachineType.samp),
        ),
        const SizedBox(height: 24),
        const _QuickGuide(),
      ],
    );
  }
}

class _MachineCard extends StatelessWidget {
  const _MachineCard({
    required this.name,
    required this.description,
    this.onTap,
  });

  final String name;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final available = onTap != null;
    return Semantics(
      button: available,
      enabled: available,
      label: available
          ? '$name makinesini seç'
          : '$name henüz kullanıma hazır değil',
      child: Opacity(
        opacity: available ? 1 : 0.58,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD5DEE6)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF005B96),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.precision_manufacturing,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(description),
                    ],
                  ),
                ),
                Icon(
                  available
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.lock_outline,
                  color: const Color(0xFF005B96),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickGuide extends StatelessWidget {
  const _QuickGuide();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF0F6FA),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book_outlined, color: Color(0xFF005B96)),
                SizedBox(width: 8),
                Text(
                  'KISA KULLANIM REHBERİ',
                  style: TextStyle(
                    color: Color(0xFF063B65),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            _GuideStep(number: '1', text: 'Makine kartına dokunun.'),
            SizedBox(height: 8),
            _GuideStep(
              number: '2',
              text: 'Tel sayısını ve tek tel çapını girin.',
            ),
            SizedBox(height: 8),
            _GuideStep(
              number: '3',
              text:
                  'Hesapla düğmesine basın ve önerilen yay numarasını kullanın.',
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  const _GuideStep({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: const Color(0xFF005B96),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(height: 1.3))),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.hint,
    this.integer = false,
    this.errorText,
    this.onChanged,
    this.onDecimalPressed,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool integer;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDecimalPressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !integer),
      inputFormatters: integer
          ? [FilteringTextInputFormatter.digitsOnly]
          : [_DecimalTextInputFormatter()],
      onChanged: onChanged,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: integer
            ? 'Yalnızca tam sayı giriniz.'
            : 'Virgül veya nokta kullanabilirsiniz.',
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        suffixIcon: integer
            ? null
            : IconButton(
                onPressed: onDecimalPressed,
                tooltip: 'Virgül ekle',
                icon: const Text(
                  ',',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
              ),
      ),
    );
  }
}

/// Sayısal klavyeden sadece tek bir virgül veya nokta ile en fazla 3 ondalık hane girilir.
class _DecimalTextInputFormatter extends TextInputFormatter {
  static final _validNumber = RegExp(r'^\d*(,\d{0,3})?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Operatör nokta yazsa bile uygulama fabrika kullanımındaki virgül biçimine
    // dönüştürür. Birden fazla ayraç, harf ve 3 haneden fazla ondalık engellenir.
    final correctedText = newValue.text.replaceAll('.', ',');
    final correctedValue = newValue.copyWith(text: correctedText);
    return _validNumber.hasMatch(correctedText) ? correctedValue : oldValue;
  }
}

class _InformationCard extends StatelessWidget {
  const _InformationCard({required this.isSamp});

  final bool isSamp;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE8F2F8),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.info_outline, size: 32, color: Color(0xFF005B96)),
            const SizedBox(height: 8),
            const Text('Tel sayısını ve tek tel çapını girin.'),
            const SizedBox(height: 4),
            Text(
              isSamp
                  ? 'Uygulama sarım gerilimini hesaplayacak.'
                  : 'Uygulama sarım gerilimini ve doğru yayı gösterecek.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final SpringResult result;

  @override
  Widget build(BuildContext context) {
    final isSamp = result.noSpringRequired;
    final isWarning = result.spring == null && !isSamp;
    final color = isWarning
        ? const Color(0xFFB42318)
        : isSamp
        ? const Color(0xFF006B6B)
        : switch (result.spring!.number) {
            1 => const Color(0xFFB54708),
            2 => const Color(0xFF087443),
            _ => const Color(0xFF005B96),
          };
    return Card(
      color: color,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(
              isWarning
                  ? Icons.warning_amber_rounded
                  : isSamp
                  ? Icons.check_circle_outline
                  : Icons.check_circle_outline,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 10),
            if (isWarning)
              const Text(
                'YAY ÖNERİSİ YOK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 23,
                ),
              )
            else if (isSamp) ...[
              const Text(
                'SARIM GERİLİMİ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),
            ] else ...[
              const Text(
                'KULLANILACAK YAY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                'YAY NO ${result.spring!.number}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 42,
                  height: 1.15,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              isWarning
                  ? result.warning!
                  : isSamp
                  ? 'Hesaplama tamamlandı.'
                  : 'Yay ölçüsü: ${result.spring!.dimensions}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Divider(height: 30, color: Colors.white54),
            Text(
              'Ürün kesiti: ${result.crossSection.toStringAsFixed(2)} mm²\n'
              'Sarım gerilimi: ${result.tension.toStringAsFixed(2)} N\n'
              'Katsayı: ${result.coefficient.toStringAsFixed(0)} N/mm²',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Spring {
  const Spring(this.number, this.dimensions);
  final int number;
  final String dimensions;
}

class SpringResult {
  const SpringResult({
    required this.crossSection,
    required this.coefficient,
    required this.tension,
    this.spring,
    this.warning,
    this.noSpringRequired = false,
  });
  final double crossSection;
  final double coefficient;
  final double tension;
  final Spring? spring;
  final String? warning;
  final bool noSpringRequired;
}

SpringResult calculateSpring(
  int wireCount,
  double diameterMm, {
  bool selectSpring = true,
}) {
  // Eğitim kartındaki yöntem: 3,14 kullanılır ve kesit iki ondalık haneye indirilir.
  final rawSection = wireCount * diameterMm * diameterMm * 3.14 / 4;
  final section = (rawSection * 100).floorToDouble() / 100;
  const coefficients = <(double, double)>[
    (0.09, 50),
    (0.14, 40),
    (0.35, 40),
    (0.80, 30),
    (1.50, 25),
    (2.50, 20),
    (4.00, 20),
    (6.00, 16),
  ];
  var coefficient = coefficients.first.$2;
  for (final row in coefficients) {
    if (section >= row.$1) coefficient = row.$2;
  }
  final tension = section * coefficient;

  if (!selectSpring) {
    return SpringResult(
      crossSection: section,
      coefficient: coefficient,
      tension: tension,
      noSpringRequired: true,
    );
  }

  if (tension < 4 || tension > 100) {
    return SpringResult(
      crossSection: section,
      coefficient: coefficient,
      tension: tension,
      warning:
          'Sarım gerilimi 4–100 N aralığında değil. Lütfen sorumluya danışın.',
    );
  }
  final spring = tension < 10
      ? const Spring(1, 'Ø0,8 × Ø8,80 × 55,5 mm')
      : tension < 80
      ? const Spring(2, 'Ø1,25 × Ø13,70 × 65,2 mm')
      : const Spring(3, 'Ø1,60 × Ø12,7 × 68,0 mm');
  return SpringResult(
    crossSection: section,
    coefficient: coefficient,
    tension: tension,
    spring: spring,
  );
}
