
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:myapp/overlay_widget.dart';
import 'package:myapp/floating_button.dart';
import 'package:myapp/api_key_screen.dart';
// import 'firebase_options.dart';

@pragma("vm:entry-point")
void overlayMain() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OverlayWidget(),
    ),
  );
}

@pragma("vm:entry-point")
void floatingButtonMain() {
  runApp(
    MaterialApp(
       debugShowCheckedModeBanner: false,
      home: FloatingButton(),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  final apiKeyProvider = ApiKeyProvider();
  await apiKeyProvider.loadApiKey();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: apiKeyProvider),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;
    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.openSans(fontSize: 14),
    );

    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primarySeedColor, brightness: Brightness.light),
      textTheme: appTextTheme,
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primarySeedColor, brightness: Brightness.dark),
      textTheme: appTextTheme,
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'AI Assistant',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
       log("Overlay event: $event");
    });
  }

  Future<void> _showFloatingButton() async {
    final bool? hasPermission = await FlutterOverlayWindow.requestPermission();
    if(hasPermission ?? false) {
      await FlutterOverlayWindow.showOverlay(
        height: 80,
        width: 80,
        alignment: OverlayAlignment.bottomRight,
        enableDrag: true,
      );
    }
  }
  
  Future<void> _captureAndSendScreenshot() async {
    final Uint8List? imageBytes = await _screenshotController.capture();
    if (imageBytes != null) {
      await FlutterOverlayWindow.shareData({'screenshot': imageBytes});
      if (!await FlutterOverlayWindow.isActive()) {
        await FlutterOverlayWindow.showOverlay(
          height: 400,
          width: 300,
          alignment: OverlayAlignment.center,
          enableDrag: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Assistant Control'),
          actions: [
            IconButton(
              icon: Icon(Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode),
              onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Activate the AI Assistant Floating Button',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showFloatingButton,
                child: const Text("Show Floating Button"),
              ),
              const SizedBox(height: 20),
               ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ApiKeyScreen()),
                  );
                },
                child: const Text("Set API Key"),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Once activated, you can tap the floating button to open the chat or long-press it to take a screenshot and ask questions about it.',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
         floatingActionButton: FloatingActionButton(
          onPressed: _captureAndSendScreenshot,
          tooltip: 'Capture and ask AI',
          child: const Icon(Icons.screenshot),
        ),
      ),
    );
  }
}
