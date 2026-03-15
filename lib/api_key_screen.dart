
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ApiKeyProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _key = 'api_key';
  String? _apiKey;

  String? get apiKey => _apiKey;

  Future<void> loadApiKey() async {
    _apiKey = await _storage.read(key: _key);
    notifyListeners();
  }

  Future<void> saveApiKey(String newApiKey) async {
    await _storage.write(key: _key, value: newApiKey);
    _apiKey = newApiKey;
    notifyListeners();
  }
}

class ApiKeyScreen extends StatelessWidget {
  const ApiKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKeyProvider = Provider.of<ApiKeyProvider>(context);
    final textController = TextEditingController(text: apiKeyProvider.apiKey);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Key'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Enter your API Key',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                apiKeyProvider.saveApiKey(textController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
