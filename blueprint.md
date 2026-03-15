# Project Blueprint

## Overview

This project is a Flutter application that provides a floating AI assistant. The assistant can be activated via a floating button and can respond to user prompts and analyze screenshots. The application allows users to securely store their own API key for use with the AI service.

## Implemented Features

### Style and Design

*   **Theming**: The application supports both light and dark themes, with a toggle switch in the app bar. The theme is managed using the `provider` package.
*   **Typography**: Custom fonts are used via the `google_fonts` package to enhance the visual appeal of the application.

### Functionality

*   **API Key Management**:
    *   Users can enter their API key on a dedicated screen.
    *   The API key is securely stored on the device using `flutter_secure_storage`.
    *   The stored API key is loaded when the app starts and is accessible throughout the application via a provider.
*   **Floating AI Assistant**:
    *   A floating button can be activated from the main screen.
    *   The floating button can be dragged around the screen.
    *   Tapping the floating button opens an overlay chat window.
*   **Screenshot Analysis**:
    *   A long press on the floating button captures a screenshot of the current screen.
    *   The captured screenshot is displayed in the AI assistant's overlay window, ready for analysis.
*   **Overlay Chat**:
    *   The overlay window allows users to interact with the AI assistant.
    *   It includes a text input field for prompts and a display area for the AI's response.

## Next Steps

*   **Gemini API Integration**:
    *   Integrate the Gemini API to provide real AI responses.
    *   Use the user-provided API key for all API calls.
    *   Implement text-based conversations with the AI.
    *   Implement image analysis using the Gemini Vision model.
*   **Error Handling**:
    *   Implement robust error handling for API calls and other asynchronous operations.
    *   Provide clear feedback to the user in case of errors.
*   **UI/UX Enhancements**:
    *   Improve the design of the overlay chat window.
    *   Add loading indicators and other visual cues to enhance the user experience.
