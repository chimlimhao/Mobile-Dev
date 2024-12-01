import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceConverter extends StatefulWidget {
  const DeviceConverter({super.key});

  @override
  State<DeviceConverter> createState() => _DeviceConverterState();
}

class _DeviceConverterState extends State<DeviceConverter> {
  final BoxDecoration textDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  );

  final TextEditingController _dollarController = TextEditingController();
  String _selectedDevice = 'EURO';
  String _convertedAmount = '';

  // Conversion rates
  final Map<String, double> _conversionRates = {
    'EURO': 0.85,
    'RIELS': 4080.0,
    'DONG': 23000.0,
  };

  void _convert() {
    final double? dollarAmount = double.tryParse(_dollarController.text);
    if (dollarAmount != null) {
      final double converted =
          dollarAmount * _conversionRates[_selectedDevice]!;
      setState(() {
        _convertedAmount = converted.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _convertedAmount = 'Invalid amount';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.money,
              size: 60,
              color: Colors.white,
            ),
            const Center(
              child: Text(
                "Converter",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            const SizedBox(height: 50),
            const Text("Amount in dollars:"),
            const SizedBox(height: 10),
            TextField(
              controller: _dollarController,
              decoration: InputDecoration(
                prefix: const Text('\$ '),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Enter an amount in dollar',
                hintStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => _convert(), // Convert on input change
            ),
            const SizedBox(height: 30),
            const Text("Device:"),
            DropdownButton<String>(
              value: _selectedDevice,
              items: _conversionRates.keys.map((String device) {
                return DropdownMenuItem<String>(
                  value: device,
                  child: Text(device),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDevice = newValue!;
                  _convert(); // Convert when device changes
                });
              },
              dropdownColor: Colors.white,
              isExpanded: true,
            ),
            const SizedBox(height: 30),
            const Text("Amount in selected device:"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: textDecoration,
              child: Text(_convertedAmount.isEmpty ? '0.00' : _convertedAmount),
            ),
          ],
        ),
      ),
    );
  }
}
