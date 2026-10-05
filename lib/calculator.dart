
import 'package:flutter/material.dart';

// void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Sederhana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepOrange,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  String _expression = '';
  double? _first;
  String? _op;
  bool _resetNext = false;

  // ---------- Logika ----------

  String _fmt(double v) {
    if (v.isNaN || v.isInfinite) return 'Error';
    if (v == v.roundToDouble() && v.abs() < 1e12) {
      return v.toInt().toString();
    }
    var s = v.toStringAsFixed(8);
    s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  double? _compute(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '−':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? null : a / b;
    }
    return null;
  }

  void _clearAll() {
    setState(() {
      _display = '0';
      _expression = '';
      _first = null;
      _op = null;
      _resetNext = false;
    });
  }

  void _onDigit(String d) {
    if (_display == 'Error') _clearAll();
    setState(() {
      if (_resetNext || _display == '0') {
        _display = d;
        _resetNext = false;
      } else if (_display.replaceAll(RegExp(r'[-.]'), '').length < 12) {
        _display += d;
      }
    });
  }

  void _onDot() {
    if (_display == 'Error') _clearAll();
    setState(() {
      if (_resetNext) {
        _display = '0.';
        _resetNext = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onOperator(String op) {
    if (_display == 'Error') return;
    setState(() {
      // Hitung berantai: 2 + 3 + ... -> hitung 2 + 3 dulu
      if (_first != null && _op != null && !_resetNext) {
        final result = _compute(_first!, double.parse(_display), _op!);
        if (result == null) {
          _display = 'Error';
          _expression = '';
          _first = null;
          _op = null;
          _resetNext = true;
          return;
        }
        _first = result;
        _display = _fmt(result);
      } else {
        _first = double.parse(_display);
      }
      _op = op;
      _expression = '${_fmt(_first!)} $op';
      _resetNext = true;
    });
  }

  void _onEquals() {
    if (_first == null || _op == null || _display == 'Error') return;
    setState(() {
      final second = double.parse(_display);
      final result = _compute(_first!, second, _op!);
      _expression = '${_fmt(_first!)} $_op ${_fmt(second)} =';
      _display = result == null ? 'Error' : _fmt(result);
      _first = null;
      _op = null;
      _resetNext = true;
    });
  }

  void _onBackspace() {
    if (_resetNext || _display == 'Error') return;
    setState(() {
      if (_display.length > 1 &&
          !(_display.length == 2 && _display.startsWith('-'))) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _onPercent() {
    final v = double.tryParse(_display);
    if (v == null) return;
    setState(() => _display = _fmt(v / 100));
  }

  void _onToggleSign() {
    if (_display == '0' || _display == 'Error') return;
    setState(() {
      _display =
          _display.startsWith('-') ? _display.substring(1) : '-$_display';
    });
  }

  // ---------- UI ----------

  Widget _btn(
    String label, {
    required VoidCallback onTap,
    Color? bg,
    Color? fg,
    int flex = 1,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 70,
          child: FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: bg ?? cs.surfaceContainerHighest,
              foregroundColor: fg ?? cs.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(List<Widget> children) => Row(children: children);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final opBg = cs.primary;
    final opFg = cs.onPrimary;
    final fnBg = cs.secondaryContainer;
    final fnFg = cs.onSecondaryContainer;

    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            // Layar tampilan
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 22,
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Tombol
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              child: Column(
                children: [
                  _row([
                    _btn('C', onTap: _clearAll, bg: fnBg, fg: fnFg),
                    _btn('⌫', onTap: _onBackspace, bg: fnBg, fg: fnFg),
                    _btn('%', onTap: _onPercent, bg: fnBg, fg: fnFg),
                    _btn('÷', onTap: () => _onOperator('÷'), bg: opBg, fg: opFg),
                  ]),
                  _row([
                    _btn('7', onTap: () => _onDigit('7')),
                    _btn('8', onTap: () => _onDigit('8')),
                    _btn('9', onTap: () => _onDigit('9')),
                    _btn('×', onTap: () => _onOperator('×'), bg: opBg, fg: opFg),
                  ]),
                  _row([
                    _btn('4', onTap: () => _onDigit('4')),
                    _btn('5', onTap: () => _onDigit('5')),
                    _btn('6', onTap: () => _onDigit('6')),
                    _btn('−', onTap: () => _onOperator('−'), bg: opBg, fg: opFg),
                  ]),
                  _row([
                    _btn('1', onTap: () => _onDigit('1')),
                    _btn('2', onTap: () => _onDigit('2')),
                    _btn('3', onTap: () => _onDigit('3')),
                    _btn('+', onTap: () => _onOperator('+'), bg: opBg, fg: opFg),
                  ]),
                  _row([
                    _btn('±', onTap: _onToggleSign),
                    _btn('0', onTap: () => _onDigit('0')),
                    _btn('.', onTap: _onDot),
                    _btn('=', onTap: _onEquals, bg: opBg, fg: opFg),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}