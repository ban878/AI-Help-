
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:myapp/api_key_screen.dart';


class OverlayWidget extends StatelessWidget {
  const OverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiKeyProvider()..loadApiKey(),
      child: const _OverlayContent(),
    );
  }
}

class _OverlayContent extends StatefulWidget {
  const _OverlayContent({super.key});

  @override
  State<_OverlayContent> createState() => _OverlayContentState();
}

class _OverlayContentState extends State<_OverlayContent> {
  final TextEditingController _textController = TextEditingController();
  String _aiResponse = "Ask me anything!";
  bool _isLoading = false;
  Uint8List? _screenshotBytes;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((data) {
      if (data is Map<String, dynamic> && data.containsKey('screenshot')) {
        setState(() {
          _screenshotBytes = data['screenshot'];
          _aiResponse = "Image received! What would you like to know?";
        });
      } else if (data is String) {
        _textController.text = data;
        _aiResponse = "Text received! Ready to process.";
        setState(() {});
      }
    });
  }

  Future<void> _handleSend() async {
    if (_textController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _aiResponse = "Thinking...";
    });

    final prompt = _textController.text;
    _textController.clear();

    final apiKey = Provider.of<ApiKeyProvider>(context, listen: false).apiKey;

    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        _aiResponse = "API Key not set. Please set it in the main app.";
        _isLoading = false;
      });
      return;
    }

    // TODO: Implement Gemini API call using the apiKey
    await Future.delayed(const Duration(seconds: 2));
    String response = "(Placeholder) You asked: '$prompt'. The AI response will appear here. API Key: $apiKey";

    setState(() {
      _aiResponse = response;
      _isLoading = false;
      _screenshotBytes = null; // Clear image after processing
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("AI Assistant", style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => FlutterOverlayWindow.closeOverlay(),
                )
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_screenshotBytes != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(_screenshotBytes!, fit: BoxFit.contain),
                        ),
                      ),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            _aiResponse,
                            style: GoogleFonts.openSans(fontSize: 14),
                          ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Enter your prompt...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _handleSend,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
