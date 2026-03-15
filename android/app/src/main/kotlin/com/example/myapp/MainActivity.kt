
package com.example.myapp

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle
import com.example.myapp.MyApplication // Import custom Application class

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check if the activity was launched from the text selection menu
        if (intent?.action == Intent.ACTION_PROCESS_TEXT) {
            val selectedText = intent.getCharSequenceExtra(Intent.EXTRA_PROCESS_TEXT)
            // Store the text in a globally accessible place (e.g., a singleton)
            (application as MyApplication).selectedText = selectedText?.toString()
        }
    }
}
