
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open the main chat overlay
        FlutterOverlayWindow.showOverlay(
          height: 400,
          width: 300,
          alignment: OverlayAlignment.center,
          enableDrag: true,
        );
      },
      onLongPress: () {
        // Logic to capture screenshot will be handled in the main app
        // and sent to the already open overlay.
        // For now, this just opens the overlay.
         FlutterOverlayWindow.showOverlay(
          height: 400,
          width: 300,
          alignment: OverlayAlignment.center,
          enableDrag: true,
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepPurple,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ]
        ),
        child: const Icon(
          Icons.assistant,
          color: Colors.white,
        ),
      ),
    );
  }
}
