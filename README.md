# RizzAI — iPhone Starter

A SwiftUI starter for an AI texting assistant.

## What is included
- Polished dark home screen
- Message input
- Rizz style selector
- Generate Reply flow
- Local demo reply engine so the UI works immediately
- Copy-to-clipboard support
- Rizz score
- Conversation history stored locally with UserDefaults

## Open in Xcode
1. Open Xcode and create a new **iOS App** project named `RizzAI`.
2. Choose **SwiftUI** and **Swift**.
3. Delete the generated `ContentView.swift` and `RizzAIApp.swift`.
4. Drag the files from this folder into the Xcode project.
5. Build and run on an iPhone Simulator or device.

## AI backend
The current version intentionally uses a local demo engine. For production, connect `RizzAIService.swift` to your own secure backend/API rather than putting a secret API key directly in the iPhone app.
