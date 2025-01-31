# verdantoff

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
verdantoff
├─ .gitignore
├─ .metadata
├─ analysis_options.yaml
├─ android
│  ├─ .gitignore
│  ├─ .gradle
│  │  ├─ 8.3
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ dependencies-accessors
│  │  │  │  ├─ dependencies-accessors.lock
│  │  │  │  └─ gc.properties
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  ├─ kotlin
│  │  │  ├─ errors
│  │  │  └─ sessions
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ app
│  │  ├─ build.gradle
│  │  ├─ google-services.json
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  ├─ kotlin
│  │     │  │  └─ com
│  │     │  │     ├─ example
│  │     │  │     │  └─ verdantoff
│  │     │  │     └─ FrontierTechnologies
│  │     │  │        └─ Verdantoff
│  │     │  │           └─ MainActivity.kt
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  └─ ic_launcher.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
│  │     │        └─ styles.xml
│  │     └─ profile
│  │        └─ AndroidManifest.xml
│  ├─ build.gradle
│  ├─ gradle
│  │  └─ wrapper
│  │     ├─ gradle-wrapper.jar
│  │     └─ gradle-wrapper.properties
│  ├─ gradle.properties
│  ├─ gradlew
│  ├─ gradlew.bat
│  ├─ local.properties
│  └─ settings.gradle
├─ firebase.json
├─ ios
│  ├─ .gitignore
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated.xcconfig
│  │  └─ Release.xcconfig
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  ├─ AppIcon.appiconset
│  │  │  │  ├─ Contents.json
│  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
│  │  ├─ Info.plist
│  │  └─ Runner-Bridging-Header.h
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     ├─ IDEWorkspaceChecks.plist
│  │     └─ WorkspaceSettings.xcsettings
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ lib
│  ├─ assets
│  │  └─ images
│  │     └─ icons
│  │        └─ fonts
│  ├─ firebase_options.dart
│  ├─ main.dart
│  ├─ models
│  │  └─ user_model.dart
│  ├─ routes
│  │  └─ app_routes.dart
│  ├─ screens
│  │  ├─ auth
│  │  │  ├─ forgot_password.dart
│  │  │  ├─ login_screen.dart
│  │  │  └─ register_screen.dart
│  │  ├─ home
│  │  │  ├─ Calendar
│  │  │  │  └─ discover_screen.dart
│  │  │  ├─ Chat_list_screen
│  │  │  │  └─ chat_screen.dart
│  │  │  ├─ Contacts
│  │  │  │  ├─ chats_tab.dart
│  │  │  │  ├─ friends_tab.dart
│  │  │  │  ├─ friend_list_screen.dart
│  │  │  │  ├─ groups_tab.dart
│  │  │  │  └─ user_search_screen.dart
│  │  │  ├─ Me_screen
│  │  │  │  └─ me_screen.dart
│  │  │  ├─ Navigation_management
│  │  │  │  ├─ home_screen.dart
│  │  │  │  └─ top_bar.dart
│  │  │  ├─ Notification_screen
│  │  │  │  └─ notifications_screen.dart
│  │  │  └─ person_chats_screen
│  │  │     ├─ bottom_input.dart
│  │  │     ├─ chat_area.dart
│  │  │     ├─ chat_area_components
│  │  │     │  ├─ actions
│  │  │     │  │  ├─ chat_action_copy.dart
│  │  │     │  │  ├─ chat_action_edit.dart
│  │  │     │  │  ├─ chat_action_forward.dart
│  │  │     │  │  ├─ chat_action_quote.dart
│  │  │     │  │  └─ chat_action_recall.dart
│  │  │     │  ├─ chat_area_action_menu.dart
│  │  │     │  ├─ chat_area_message_bubble.dart
│  │  │     │  └─ chat_area_message_list.dart
│  │  │     ├─ person_chats_screen.dart
│  │  │     └─ top_bar.dart
│  │  ├─ settings
│  │  │  ├─ edit_field_screen.dart
│  │  │  ├─ edit_profile_screen.dart
│  │  │  └─ settings_screen.dart
│  │  ├─ user
│  │  │  ├─ send_friend_request_screen.dart
│  │  │  └─ user_detail_screen.dart
│  │  └─ video_call
│  │     ├─ screen_share_screen.dart
│  │     ├─ video_call_screen.dart
│  │     └─ voice_call_screen.dart
│  ├─ services
│  │  ├─ auth_service.dart
│  │  ├─ friend_requests
│  │  │  ├─ friend_manager.dart
│  │  │  ├─ friend_request_handler.dart
│  │  │  ├─ friend_request_sender.dart
│  │  │  ├─ friend_request_service.dart
│  │  │  └─ notification_helper.dart
│  │  ├─ models
│  │  │  └─ p2p_chat
│  │  │     ├─ p2p_chat_model.dart
│  │  │     ├─ p2p_message_model.dart
│  │  │     └─ p2p_notification_model.dart
│  │  ├─ p2p_chat
│  │  │  ├─ p2p_chat_service.dart
│  │  │  ├─ p2p_chat_service_funtions
│  │  │  │  ├─ create_chat.dart
│  │  │  │  ├─ create_or_fetch_chat.dart
│  │  │  │  ├─ get_chats.dart
│  │  │  │  ├─ update_chat.dart
│  │  │  │  └─ update_unread_counts.dart
│  │  │  ├─ p2p_message_funtions
│  │  │  │  ├─ add_message.dart
│  │  │  │  ├─ edit_message.dart
│  │  │  │  ├─ get_messages.dart
│  │  │  │  ├─ mark_message_as_read.dart
│  │  │  │  └─ recall_message.dart
│  │  │  ├─ p2p_message_service.dart
│  │  │  └─ p2p_notification_service.dart
│  │  ├─ p2p_services.dart
│  │  └─ user_service.dart
│  ├─ test
│  ├─ utils
│  │  ├─ constants.dart
│  │  ├─ helpers.dart
│  │  ├─ theme.dart
│  │  └─ validators.dart
│  └─ widgets
│     ├─ chat_message.dart
│     ├─ custom_button.dart
│     ├─ custom_text_field.dart
│     └─ notification_card.dart
├─ linux
│  ├─ .gitignore
│  ├─ CMakeLists.txt
│  ├─ flutter
│  │  ├─ CMakeLists.txt
│  │  ├─ ephemeral
│  │  │  └─ .plugin_symlinks
│  │  │     ├─ file_selector_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  ├─ get_directory_page.dart
│  │  │     │  │  │  ├─ get_multiple_directories_page.dart
│  │  │     │  │  │  ├─ home_page.dart
│  │  │     │  │  │  ├─ main.dart
│  │  │     │  │  │  ├─ open_image_page.dart
│  │  │     │  │  │  ├─ open_multiple_images_page.dart
│  │  │     │  │  │  ├─ open_text_page.dart
│  │  │     │  │  │  └─ save_text_page.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  └─ README.md
│  │  │     │  ├─ lib
│  │  │     │  │  ├─ file_selector_linux.dart
│  │  │     │  │  └─ src
│  │  │     │  │     └─ messages.g.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ linux
│  │  │     │  │  ├─ CMakeLists.txt
│  │  │     │  │  ├─ file_selector_plugin.cc
│  │  │     │  │  ├─ file_selector_plugin_private.h
│  │  │     │  │  ├─ include
│  │  │     │  │  │  └─ file_selector_linux
│  │  │     │  │  │     └─ file_selector_plugin.h
│  │  │     │  │  ├─ messages.g.cc
│  │  │     │  │  ├─ messages.g.h
│  │  │     │  │  └─ test
│  │  │     │  │     ├─ file_selector_plugin_test.cc
│  │  │     │  │     └─ test_main.cc
│  │  │     │  ├─ pigeons
│  │  │     │  │  ├─ copyright.txt
│  │  │     │  │  └─ messages.dart
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     └─ file_selector_linux_test.dart
│  │  │     ├─ image_picker_linux
│  │  │     │  ├─ AUTHORS
│  │  │     │  ├─ CHANGELOG.md
│  │  │     │  ├─ example
│  │  │     │  │  ├─ lib
│  │  │     │  │  │  └─ main.dart
│  │  │     │  │  ├─ linux
│  │  │     │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  ├─ flutter
│  │  │     │  │  │  │  ├─ CMakeLists.txt
│  │  │     │  │  │  │  └─ generated_plugins.cmake
│  │  │     │  │  │  ├─ main.cc
│  │  │     │  │  │  ├─ my_application.cc
│  │  │     │  │  │  └─ my_application.h
│  │  │     │  │  ├─ pubspec.yaml
│  │  │     │  │  └─ README.md
│  │  │     │  ├─ lib
│  │  │     │  │  └─ image_picker_linux.dart
│  │  │     │  ├─ LICENSE
│  │  │     │  ├─ pubspec.yaml
│  │  │     │  ├─ README.md
│  │  │     │  └─ test
│  │  │     │     ├─ image_picker_linux_test.dart
│  │  │     │     └─ image_picker_linux_test.mocks.dart
│  │  │     └─ path_provider_linux
│  │  │        ├─ AUTHORS
│  │  │        ├─ CHANGELOG.md
│  │  │        ├─ example
│  │  │        │  ├─ integration_test
│  │  │        │  │  └─ path_provider_test.dart
│  │  │        │  ├─ lib
│  │  │        │  │  └─ main.dart
│  │  │        │  ├─ linux
│  │  │        │  │  ├─ CMakeLists.txt
│  │  │        │  │  ├─ flutter
│  │  │        │  │  │  ├─ CMakeLists.txt
│  │  │        │  │  │  └─ generated_plugins.cmake
│  │  │        │  │  ├─ main.cc
│  │  │        │  │  ├─ my_application.cc
│  │  │        │  │  └─ my_application.h
│  │  │        │  ├─ pubspec.yaml
│  │  │        │  ├─ README.md
│  │  │        │  └─ test_driver
│  │  │        │     └─ integration_test.dart
│  │  │        ├─ lib
│  │  │        │  ├─ path_provider_linux.dart
│  │  │        │  └─ src
│  │  │        │     ├─ get_application_id.dart
│  │  │        │     ├─ get_application_id_real.dart
│  │  │        │     ├─ get_application_id_stub.dart
│  │  │        │     └─ path_provider_linux.dart
│  │  │        ├─ LICENSE
│  │  │        ├─ pubspec.yaml
│  │  │        ├─ README.md
│  │  │        └─ test
│  │  │           ├─ get_application_id_test.dart
│  │  │           └─ path_provider_linux_test.dart
│  │  ├─ generated_plugins.cmake
│  │  ├─ generated_plugin_registrant.cc
│  │  └─ generated_plugin_registrant.h
│  ├─ main.cc
│  ├─ my_application.cc
│  └─ my_application.h
├─ macos
│  ├─ .gitignore
│  ├─ Flutter
│  │  ├─ ephemeral
│  │  │  ├─ Flutter-Generated.xcconfig
│  │  │  └─ flutter_export_environment.sh
│  │  ├─ Flutter-Debug.xcconfig
│  │  ├─ Flutter-Release.xcconfig
│  │  └─ GeneratedPluginRegistrant.swift
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  └─ AppIcon.appiconset
│  │  │     ├─ app_icon_1024.png
│  │  │     ├─ app_icon_128.png
│  │  │     ├─ app_icon_16.png
│  │  │     ├─ app_icon_256.png
│  │  │     ├─ app_icon_32.png
│  │  │     ├─ app_icon_512.png
│  │  │     ├─ app_icon_64.png
│  │  │     └─ Contents.json
│  │  ├─ Base.lproj
│  │  │  └─ MainMenu.xib
│  │  ├─ Configs
│  │  │  ├─ AppInfo.xcconfig
│  │  │  ├─ Debug.xcconfig
│  │  │  ├─ Release.xcconfig
│  │  │  └─ Warnings.xcconfig
│  │  ├─ DebugProfile.entitlements
│  │  ├─ Info.plist
│  │  ├─ MainFlutterWindow.swift
│  │  └─ Release.entitlements
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  └─ xcshareddata
│  │  │     └─ IDEWorkspaceChecks.plist
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     └─ IDEWorkspaceChecks.plist
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ pubspec.lock
├─ pubspec.yaml
├─ README.md
├─ test
│  └─ widget_test.dart
├─ web
│  ├─ favicon.png
│  ├─ icons
│  │  ├─ Icon-192.png
│  │  ├─ Icon-512.png
│  │  ├─ Icon-maskable-192.png
│  │  └─ Icon-maskable-512.png
│  ├─ index.html
│  └─ manifest.json
└─ windows
   ├─ .gitignore
   ├─ CMakeLists.txt
   ├─ flutter
   │  ├─ CMakeLists.txt
   │  ├─ ephemeral
   │  │  └─ .plugin_symlinks
   │  │     ├─ cloud_firestore
   │  │     │  ├─ android
   │  │     │  │  ├─ build.gradle
   │  │     │  │  ├─ settings.gradle
   │  │     │  │  ├─ src
   │  │     │  │  │  └─ main
   │  │     │  │  │     ├─ AndroidManifest.xml
   │  │     │  │  │     └─ java
   │  │     │  │  │        └─ io
   │  │     │  │  │           └─ flutter
   │  │     │  │  │              └─ plugins
   │  │     │  │  │                 └─ firebase
   │  │     │  │  │                    └─ firestore
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreException.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreExtension.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreMessageCodec.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestorePlugin.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreRegistrar.java
   │  │     │  │  │                       ├─ FlutterFirebaseFirestoreTransactionResult.java
   │  │     │  │  │                       ├─ GeneratedAndroidFirebaseFirestore.java
   │  │     │  │  │                       ├─ streamhandler
   │  │     │  │  │                       │  ├─ DocumentSnapshotsStreamHandler.java
   │  │     │  │  │                       │  ├─ LoadBundleStreamHandler.java
   │  │     │  │  │                       │  ├─ OnTransactionResultListener.java
   │  │     │  │  │                       │  ├─ QuerySnapshotsStreamHandler.java
   │  │     │  │  │                       │  ├─ SnapshotsInSyncStreamHandler.java
   │  │     │  │  │                       │  └─ TransactionStreamHandler.java
   │  │     │  │  │                       └─ utils
   │  │     │  │  │                          ├─ ExceptionConverter.java
   │  │     │  │  │                          ├─ PigeonParser.java
   │  │     │  │  │                          └─ ServerTimestampBehaviorConverter.java
   │  │     │  │  └─ user-agent.gradle
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ dartpad
   │  │     │  │  ├─ dartpad_metadata.yaml
   │  │     │  │  └─ lib
   │  │     │  │     └─ main.dart
   │  │     │  ├─ example
   │  │     │  │  ├─ analysis_options.yaml
   │  │     │  │  ├─ android
   │  │     │  │  │  ├─ app
   │  │     │  │  │  │  ├─ build.gradle
   │  │     │  │  │  │  ├─ google-services.json
   │  │     │  │  │  │  └─ src
   │  │     │  │  │  │     ├─ debug
   │  │     │  │  │  │     │  └─ AndroidManifest.xml
   │  │     │  │  │  │     ├─ main
   │  │     │  │  │  │     │  ├─ AndroidManifest.xml
   │  │     │  │  │  │     │  ├─ java
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  ├─ kotlin
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  │           └─ firebase
   │  │     │  │  │  │     │  │              └─ firestore
   │  │     │  │  │  │     │  │                 └─ example
   │  │     │  │  │  │     │  │                    └─ MainActivity.kt
   │  │     │  │  │  │     │  └─ res
   │  │     │  │  │  │     │     ├─ drawable
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ drawable-v21
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ mipmap-hdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-mdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ values
   │  │     │  │  │  │     │     │  └─ styles.xml
   │  │     │  │  │  │     │     └─ values-night
   │  │     │  │  │  │     │        └─ styles.xml
   │  │     │  │  │  │     └─ profile
   │  │     │  │  │  │        └─ AndroidManifest.xml
   │  │     │  │  │  ├─ build.gradle
   │  │     │  │  │  ├─ gradle
   │  │     │  │  │  │  └─ wrapper
   │  │     │  │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  │  ├─ gradle.properties
   │  │     │  │  │  └─ settings.gradle
   │  │     │  │  ├─ firebase.json
   │  │     │  │  ├─ integration_test
   │  │     │  │  │  ├─ collection_reference_e2e.dart
   │  │     │  │  │  ├─ document_change_e2e.dart
   │  │     │  │  │  ├─ document_reference_e2e.dart
   │  │     │  │  │  ├─ e2e_test.dart
   │  │     │  │  │  ├─ field_value_e2e.dart
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  ├─ firebase_options_secondary.dart
   │  │     │  │  │  ├─ geo_point_e2e.dart
   │  │     │  │  │  ├─ instance_e2e.dart
   │  │     │  │  │  ├─ load_bundle_e2e.dart
   │  │     │  │  │  ├─ query_e2e.dart
   │  │     │  │  │  ├─ second_database.dart
   │  │     │  │  │  ├─ settings_e2e.dart
   │  │     │  │  │  ├─ snapshot_metadata_e2e.dart
   │  │     │  │  │  ├─ timestamp_e2e.dart
   │  │     │  │  │  ├─ transaction_e2e.dart
   │  │     │  │  │  ├─ vector_value_e2e.dart
   │  │     │  │  │  ├─ web_snapshot_listeners.dart
   │  │     │  │  │  └─ write_batch_e2e.dart
   │  │     │  │  ├─ ios
   │  │     │  │  │  ├─ firebase_app_id_file.json
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │     │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  └─ Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  ├─ AppIcon.appiconset
   │  │     │  │  │  │  │  │  ├─ Contents.json
   │  │     │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │     │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │     │  │  │  │  │  └─ LaunchImage.imageset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ LaunchImage.png
   │  │     │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │     │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │     │  │  │  │  │     └─ README.md
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │     │  │  │  │  │  └─ Main.storyboard
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  └─ Runner-Bridging-Header.h
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  │     ├─ swiftpm
   │  │     │  │  │  │  │     │  └─ configuration
   │  │     │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │        ├─ swiftpm
   │  │     │  │  │        │  └─ configuration
   │  │     │  │  │        └─ WorkspaceSettings.xcsettings
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  └─ main.dart
   │  │     │  │  ├─ macos
   │  │     │  │  │  ├─ firebase_app_id_file.json
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │     │  │  │  │  └─ Flutter-Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ app_icon_1024.png
   │  │     │  │  │  │  │     ├─ app_icon_128.png
   │  │     │  │  │  │  │     ├─ app_icon_16.png
   │  │     │  │  │  │  │     ├─ app_icon_256.png
   │  │     │  │  │  │  │     ├─ app_icon_32.png
   │  │     │  │  │  │  │     ├─ app_icon_512.png
   │  │     │  │  │  │  │     ├─ app_icon_64.png
   │  │     │  │  │  │  │     └─ Contents.json
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  └─ MainMenu.xib
   │  │     │  │  │  │  ├─ Configs
   │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │     │  │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  │  ├─ Release.xcconfig
   │  │     │  │  │  │  │  └─ Warnings.xcconfig
   │  │     │  │  │  │  ├─ DebugProfile.entitlements
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ MainFlutterWindow.swift
   │  │     │  │  │  │  └─ Release.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  │     └─ swiftpm
   │  │     │  │  │  │  │        └─ configuration
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  ├─ Runner.xcworkspace
   │  │     │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │     └─ swiftpm
   │  │     │  │  │  │        └─ configuration
   │  │     │  │  │  └─ RunnerTests
   │  │     │  │  │     └─ RunnerTests.swift
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ test_driver
   │  │     │  │  │  └─ integration_test.dart
   │  │     │  │  ├─ web
   │  │     │  │  │  ├─ favicon.png
   │  │     │  │  │  ├─ icons
   │  │     │  │  │  │  ├─ Icon-192.png
   │  │     │  │  │  │  ├─ Icon-512.png
   │  │     │  │  │  │  ├─ Icon-maskable-192.png
   │  │     │  │  │  │  └─ Icon-maskable-512.png
   │  │     │  │  │  ├─ index.html
   │  │     │  │  │  ├─ manifest.json
   │  │     │  │  │  └─ wasm_index.html
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  └─ CMakeLists.txt
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ ios
   │  │     │  │  ├─ cloud_firestore
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ cloud_firestore
   │  │     │  │  │        ├─ FirestoreMessages.g.m
   │  │     │  │  │        ├─ FirestorePigeonParser.m
   │  │     │  │  │        ├─ FLTDocumentSnapshotStreamHandler.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreExtension.m
   │  │     │  │  │        ├─ FLTFirebaseFirestorePlugin.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreReader.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreUtils.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreWriter.m
   │  │     │  │  │        ├─ FLTLoadBundleStreamHandler.m
   │  │     │  │  │        ├─ FLTQuerySnapshotStreamHandler.m
   │  │     │  │  │        ├─ FLTSnapshotsInSyncStreamHandler.m
   │  │     │  │  │        ├─ FLTTransactionStreamHandler.m
   │  │     │  │  │        ├─ include
   │  │     │  │  │        │  └─ cloud_firestore
   │  │     │  │  │        │     ├─ Private
   │  │     │  │  │        │     │  ├─ FirestorePigeonParser.h
   │  │     │  │  │        │     │  ├─ FLTDocumentSnapshotStreamHandler.h
   │  │     │  │  │        │     │  ├─ FLTFirebaseFirestoreExtension.h
   │  │     │  │  │        │     │  ├─ FLTFirebaseFirestoreReader.h
   │  │     │  │  │        │     │  ├─ FLTFirebaseFirestoreUtils.h
   │  │     │  │  │        │     │  ├─ FLTFirebaseFirestoreWriter.h
   │  │     │  │  │        │     │  ├─ FLTLoadBundleStreamHandler.h
   │  │     │  │  │        │     │  ├─ FLTQuerySnapshotStreamHandler.h
   │  │     │  │  │        │     │  ├─ FLTSnapshotsInSyncStreamHandler.h
   │  │     │  │  │        │     │  └─ FLTTransactionStreamHandler.h
   │  │     │  │  │        │     └─ Public
   │  │     │  │  │        │        ├─ CustomPigeonHeaderFirestore.h
   │  │     │  │  │        │        ├─ FirestoreMessages.g.h
   │  │     │  │  │        │        └─ FLTFirebaseFirestorePlugin.h
   │  │     │  │  │        └─ Resources
   │  │     │  │  ├─ cloud_firestore.podspec
   │  │     │  │  └─ generated_firebase_sdk_version.txt
   │  │     │  ├─ lib
   │  │     │  │  ├─ cloud_firestore.dart
   │  │     │  │  └─ src
   │  │     │  │     ├─ aggregate_query.dart
   │  │     │  │     ├─ aggregate_query_snapshot.dart
   │  │     │  │     ├─ collection_reference.dart
   │  │     │  │     ├─ document_change.dart
   │  │     │  │     ├─ document_reference.dart
   │  │     │  │     ├─ document_snapshot.dart
   │  │     │  │     ├─ field_value.dart
   │  │     │  │     ├─ filters.dart
   │  │     │  │     ├─ firestore.dart
   │  │     │  │     ├─ load_bundle_task.dart
   │  │     │  │     ├─ load_bundle_task_snapshot.dart
   │  │     │  │     ├─ persistent_cache_index_manager.dart
   │  │     │  │     ├─ query.dart
   │  │     │  │     ├─ query_document_snapshot.dart
   │  │     │  │     ├─ query_snapshot.dart
   │  │     │  │     ├─ snapshot_metadata.dart
   │  │     │  │     ├─ transaction.dart
   │  │     │  │     ├─ utils
   │  │     │  │     │  └─ codec_utility.dart
   │  │     │  │     └─ write_batch.dart
   │  │     │  ├─ LICENSE
   │  │     │  ├─ macos
   │  │     │  │  ├─ cloud_firestore
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ cloud_firestore
   │  │     │  │  │        ├─ FirestoreMessages.g.m
   │  │     │  │  │        ├─ FirestorePigeonParser.m
   │  │     │  │  │        ├─ FLTDocumentSnapshotStreamHandler.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreExtension.m
   │  │     │  │  │        ├─ FLTFirebaseFirestorePlugin.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreReader.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreUtils.m
   │  │     │  │  │        ├─ FLTFirebaseFirestoreWriter.m
   │  │     │  │  │        ├─ FLTLoadBundleStreamHandler.m
   │  │     │  │  │        ├─ FLTQuerySnapshotStreamHandler.m
   │  │     │  │  │        ├─ FLTSnapshotsInSyncStreamHandler.m
   │  │     │  │  │        ├─ FLTTransactionStreamHandler.m
   │  │     │  │  │        ├─ include
   │  │     │  │  │        │  └─ cloud_firestore
   │  │     │  │  │        │     ├─ Private
   │  │     │  │  │        │     │  ├─ FirestorePigeonParser.h
   │  │     │  │  │        │     │  ├─ FLTDocumentSnapshotStreamHandler.h
   │  │     │  │  │        │     │  ├─ FLTFirebaseFirestoreExtension.h
   │  │     │  │  │        │     │  ├─ FLTFirebaseFirestoreReader.h
   │  │     │  │  │        │     │  ├─ FLTFirebaseFirestoreUtils.h
   │  │     │  │  │        │     │  ├─ FLTFirebaseFirestoreWriter.h
   │  │     │  │  │        │     │  ├─ FLTLoadBundleStreamHandler.h
   │  │     │  │  │        │     │  ├─ FLTQuerySnapshotStreamHandler.h
   │  │     │  │  │        │     │  ├─ FLTSnapshotsInSyncStreamHandler.h
   │  │     │  │  │        │     │  └─ FLTTransactionStreamHandler.h
   │  │     │  │  │        │     └─ Public
   │  │     │  │  │        │        ├─ CustomPigeonHeaderFirestore.h
   │  │     │  │  │        │        ├─ FirestoreMessages.g.h
   │  │     │  │  │        │        └─ FLTFirebaseFirestorePlugin.h
   │  │     │  │  │        └─ Resources
   │  │     │  │  └─ cloud_firestore.podspec
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ README.md
   │  │     │  ├─ test
   │  │     │  │  ├─ cloud_firestore_test.dart
   │  │     │  │  ├─ collection_reference_test.dart
   │  │     │  │  ├─ field_value_test.dart
   │  │     │  │  ├─ mock.dart
   │  │     │  │  ├─ query_test.dart
   │  │     │  │  └─ test_firestore_message_codec.dart
   │  │     │  └─ windows
   │  │     │     ├─ cloud_firestore_plugin.cpp
   │  │     │     ├─ cloud_firestore_plugin.h
   │  │     │     ├─ cloud_firestore_plugin_c_api.cpp
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ firestore_codec.cpp
   │  │     │     ├─ firestore_codec.h
   │  │     │     ├─ include
   │  │     │     │  └─ cloud_firestore
   │  │     │     │     └─ cloud_firestore_plugin_c_api.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     ├─ plugin_version.h.in
   │  │     │     └─ test
   │  │     │        └─ cloud_firestore_plugin_test.cpp
   │  │     ├─ file_selector_windows
   │  │     │  ├─ AUTHORS
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ example
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ get_directory_page.dart
   │  │     │  │  │  ├─ get_multiple_directories_page.dart
   │  │     │  │  │  ├─ home_page.dart
   │  │     │  │  │  ├─ main.dart
   │  │     │  │  │  ├─ open_image_page.dart
   │  │     │  │  │  ├─ open_multiple_images_page.dart
   │  │     │  │  │  ├─ open_text_page.dart
   │  │     │  │  │  └─ save_text_page.dart
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ README.md
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  ├─ CMakeLists.txt
   │  │     │  │     │  └─ generated_plugins.cmake
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ lib
   │  │     │  │  ├─ file_selector_windows.dart
   │  │     │  │  └─ src
   │  │     │  │     └─ messages.g.dart
   │  │     │  ├─ LICENSE
   │  │     │  ├─ pigeons
   │  │     │  │  ├─ copyright.txt
   │  │     │  │  └─ messages.dart
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ README.md
   │  │     │  ├─ test
   │  │     │  │  ├─ file_selector_windows_test.dart
   │  │     │  │  ├─ file_selector_windows_test.mocks.dart
   │  │     │  │  └─ test_api.g.dart
   │  │     │  └─ windows
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ file_dialog_controller.cpp
   │  │     │     ├─ file_dialog_controller.h
   │  │     │     ├─ file_selector_plugin.cpp
   │  │     │     ├─ file_selector_plugin.h
   │  │     │     ├─ file_selector_windows.cpp
   │  │     │     ├─ include
   │  │     │     │  └─ file_selector_windows
   │  │     │     │     └─ file_selector_windows.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     ├─ string_utils.cpp
   │  │     │     ├─ string_utils.h
   │  │     │     └─ test
   │  │     │        ├─ file_selector_plugin_test.cpp
   │  │     │        ├─ test_file_dialog_controller.cpp
   │  │     │        ├─ test_file_dialog_controller.h
   │  │     │        ├─ test_main.cpp
   │  │     │        ├─ test_utils.cpp
   │  │     │        └─ test_utils.h
   │  │     ├─ firebase_auth
   │  │     │  ├─ android
   │  │     │  │  ├─ build.gradle
   │  │     │  │  ├─ gradle
   │  │     │  │  │  └─ wrapper
   │  │     │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  ├─ gradle.properties
   │  │     │  │  ├─ settings.gradle
   │  │     │  │  ├─ src
   │  │     │  │  │  └─ main
   │  │     │  │  │     ├─ AndroidManifest.xml
   │  │     │  │  │     └─ java
   │  │     │  │  │        └─ io
   │  │     │  │  │           └─ flutter
   │  │     │  │  │              └─ plugins
   │  │     │  │  │                 └─ firebase
   │  │     │  │  │                    └─ auth
   │  │     │  │  │                       ├─ AuthStateChannelStreamHandler.java
   │  │     │  │  │                       ├─ Constants.java
   │  │     │  │  │                       ├─ FlutterFirebaseAuthPlugin.java
   │  │     │  │  │                       ├─ FlutterFirebaseAuthPluginException.java
   │  │     │  │  │                       ├─ FlutterFirebaseAuthRegistrar.java
   │  │     │  │  │                       ├─ FlutterFirebaseAuthUser.java
   │  │     │  │  │                       ├─ FlutterFirebaseMultiFactor.java
   │  │     │  │  │                       ├─ FlutterFirebaseTotpMultiFactor.java
   │  │     │  │  │                       ├─ FlutterFirebaseTotpSecret.java
   │  │     │  │  │                       ├─ GeneratedAndroidFirebaseAuth.java
   │  │     │  │  │                       ├─ IdTokenChannelStreamHandler.java
   │  │     │  │  │                       ├─ PhoneNumberVerificationStreamHandler.java
   │  │     │  │  │                       └─ PigeonParser.java
   │  │     │  │  └─ user-agent.gradle
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ example
   │  │     │  │  ├─ analysis_options.yaml
   │  │     │  │  ├─ android
   │  │     │  │  │  ├─ app
   │  │     │  │  │  │  ├─ build.gradle
   │  │     │  │  │  │  ├─ google-services.json
   │  │     │  │  │  │  └─ src
   │  │     │  │  │  │     ├─ debug
   │  │     │  │  │  │     │  └─ AndroidManifest.xml
   │  │     │  │  │  │     ├─ main
   │  │     │  │  │  │     │  ├─ AndroidManifest.xml
   │  │     │  │  │  │     │  ├─ java
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  ├─ kotlin
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  │           └─ firebase
   │  │     │  │  │  │     │  │              └─ auth
   │  │     │  │  │  │     │  │                 └─ example
   │  │     │  │  │  │     │  │                    └─ MainActivity.kt
   │  │     │  │  │  │     │  └─ res
   │  │     │  │  │  │     │     ├─ drawable
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ drawable-v21
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ mipmap-hdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-mdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ values
   │  │     │  │  │  │     │     │  └─ styles.xml
   │  │     │  │  │  │     │     └─ values-night
   │  │     │  │  │  │     │        └─ styles.xml
   │  │     │  │  │  │     └─ profile
   │  │     │  │  │  │        └─ AndroidManifest.xml
   │  │     │  │  │  ├─ build.gradle
   │  │     │  │  │  ├─ gradle
   │  │     │  │  │  │  └─ wrapper
   │  │     │  │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  │  ├─ gradle.properties
   │  │     │  │  │  └─ settings.gradle
   │  │     │  │  ├─ ios
   │  │     │  │  │  ├─ firebase_app_id_file.json
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │     │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  └─ Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.h
   │  │     │  │  │  │  ├─ AppDelegate.m
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  ├─ AppIcon.appiconset
   │  │     │  │  │  │  │  │  ├─ Contents.json
   │  │     │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │     │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │     │  │  │  │  │  └─ LaunchImage.imageset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ LaunchImage.png
   │  │     │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │     │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │     │  │  │  │  │     └─ README.md
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │     │  │  │  │  │  └─ Main.storyboard
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ main.m
   │  │     │  │  │  │  ├─ Runner-Bridging-Header.h
   │  │     │  │  │  │  └─ Runner.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │        └─ WorkspaceSettings.xcsettings
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ auth.dart
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  ├─ main.dart
   │  │     │  │  │  └─ profile.dart
   │  │     │  │  ├─ macos
   │  │     │  │  │  ├─ firebase_app_id_file.json
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │     │  │  │  │  └─ Flutter-Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ app_icon_1024.png
   │  │     │  │  │  │  │     ├─ app_icon_128.png
   │  │     │  │  │  │  │     ├─ app_icon_16.png
   │  │     │  │  │  │  │     ├─ app_icon_256.png
   │  │     │  │  │  │  │     ├─ app_icon_32.png
   │  │     │  │  │  │  │     ├─ app_icon_512.png
   │  │     │  │  │  │  │     ├─ app_icon_64.png
   │  │     │  │  │  │  │     └─ Contents.json
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  └─ MainMenu.xib
   │  │     │  │  │  │  ├─ Configs
   │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │     │  │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  │  ├─ Release.xcconfig
   │  │     │  │  │  │  │  └─ Warnings.xcconfig
   │  │     │  │  │  │  ├─ DebugProfile.entitlements
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ MainFlutterWindow.swift
   │  │     │  │  │  │  └─ Release.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │        └─ WorkspaceSettings.xcsettings
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ web
   │  │     │  │  │  ├─ favicon.png
   │  │     │  │  │  ├─ icons
   │  │     │  │  │  │  ├─ Icon-192.png
   │  │     │  │  │  │  ├─ Icon-512.png
   │  │     │  │  │  │  ├─ Icon-maskable-192.png
   │  │     │  │  │  │  └─ Icon-maskable-512.png
   │  │     │  │  │  ├─ index.html
   │  │     │  │  │  └─ manifest.json
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  └─ CMakeLists.txt
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ ios
   │  │     │  │  ├─ Assets
   │  │     │  │  ├─ Classes
   │  │     │  │  │  ├─ firebase_auth_messages.g.m
   │  │     │  │  │  ├─ FLTAuthStateChannelStreamHandler.m
   │  │     │  │  │  ├─ FLTFirebaseAuthPlugin.m
   │  │     │  │  │  ├─ FLTIdTokenChannelStreamHandler.m
   │  │     │  │  │  ├─ FLTPhoneNumberVerificationStreamHandler.m
   │  │     │  │  │  ├─ PigeonParser.m
   │  │     │  │  │  ├─ Private
   │  │     │  │  │  │  ├─ FLTAuthStateChannelStreamHandler.h
   │  │     │  │  │  │  ├─ FLTIdTokenChannelStreamHandler.h
   │  │     │  │  │  │  ├─ FLTPhoneNumberVerificationStreamHandler.h
   │  │     │  │  │  │  └─ PigeonParser.h
   │  │     │  │  │  └─ Public
   │  │     │  │  │     ├─ CustomPigeonHeader.h
   │  │     │  │  │     ├─ firebase_auth_messages.g.h
   │  │     │  │  │     └─ FLTFirebaseAuthPlugin.h
   │  │     │  │  └─ firebase_auth.podspec
   │  │     │  ├─ lib
   │  │     │  │  ├─ firebase_auth.dart
   │  │     │  │  └─ src
   │  │     │  │     ├─ confirmation_result.dart
   │  │     │  │     ├─ firebase_auth.dart
   │  │     │  │     ├─ multi_factor.dart
   │  │     │  │     ├─ recaptcha_verifier.dart
   │  │     │  │     ├─ user.dart
   │  │     │  │     └─ user_credential.dart
   │  │     │  ├─ LICENSE
   │  │     │  ├─ macos
   │  │     │  │  ├─ Assets
   │  │     │  │  ├─ Classes
   │  │     │  │  │  ├─ firebase_auth_messages.g.m
   │  │     │  │  │  ├─ FLTAuthStateChannelStreamHandler.m
   │  │     │  │  │  ├─ FLTFirebaseAuthPlugin.m
   │  │     │  │  │  ├─ FLTIdTokenChannelStreamHandler.m
   │  │     │  │  │  ├─ FLTPhoneNumberVerificationStreamHandler.m
   │  │     │  │  │  ├─ PigeonParser.m
   │  │     │  │  │  ├─ Private
   │  │     │  │  │  │  ├─ FLTAuthStateChannelStreamHandler.h
   │  │     │  │  │  │  ├─ FLTIdTokenChannelStreamHandler.h
   │  │     │  │  │  │  ├─ FLTPhoneNumberVerificationStreamHandler.h
   │  │     │  │  │  │  └─ PigeonParser.h
   │  │     │  │  │  └─ Public
   │  │     │  │  │     ├─ CustomPigeonHeader.h
   │  │     │  │  │     ├─ firebase_auth_messages.g.h
   │  │     │  │  │     └─ FLTFirebaseAuthPlugin.h
   │  │     │  │  └─ firebase_auth.podspec
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ README.md
   │  │     │  ├─ test
   │  │     │  │  ├─ firebase_auth_test.dart
   │  │     │  │  ├─ mock.dart
   │  │     │  │  └─ user_test.dart
   │  │     │  └─ windows
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ firebase_auth_plugin.cpp
   │  │     │     ├─ firebase_auth_plugin.h
   │  │     │     ├─ firebase_auth_plugin_c_api.cpp
   │  │     │     ├─ include
   │  │     │     │  └─ firebase_auth
   │  │     │     │     └─ firebase_auth_plugin_c_api.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     ├─ plugin_version.h.in
   │  │     │     └─ test
   │  │     │        └─ firebase_auth_plugin_test.cpp
   │  │     ├─ firebase_core
   │  │     │  ├─ android
   │  │     │  │  ├─ build.gradle
   │  │     │  │  ├─ gradle
   │  │     │  │  │  └─ wrapper
   │  │     │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  ├─ gradle.properties
   │  │     │  │  ├─ settings.gradle
   │  │     │  │  ├─ src
   │  │     │  │  │  └─ main
   │  │     │  │  │     ├─ AndroidManifest.xml
   │  │     │  │  │     └─ java
   │  │     │  │  │        └─ io
   │  │     │  │  │           └─ flutter
   │  │     │  │  │              └─ plugins
   │  │     │  │  │                 └─ firebase
   │  │     │  │  │                    └─ core
   │  │     │  │  │                       ├─ FlutterFirebaseCorePlugin.java
   │  │     │  │  │                       ├─ FlutterFirebaseCoreRegistrar.java
   │  │     │  │  │                       ├─ FlutterFirebasePlugin.java
   │  │     │  │  │                       ├─ FlutterFirebasePluginRegistry.java
   │  │     │  │  │                       └─ GeneratedAndroidFirebaseCore.java
   │  │     │  │  └─ user-agent.gradle
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ example
   │  │     │  │  ├─ analysis_options.yaml
   │  │     │  │  ├─ android
   │  │     │  │  │  ├─ app
   │  │     │  │  │  │  ├─ build.gradle
   │  │     │  │  │  │  ├─ google-services.json
   │  │     │  │  │  │  └─ src
   │  │     │  │  │  │     ├─ debug
   │  │     │  │  │  │     │  └─ AndroidManifest.xml
   │  │     │  │  │  │     ├─ main
   │  │     │  │  │  │     │  ├─ AndroidManifest.xml
   │  │     │  │  │  │     │  ├─ java
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  ├─ kotlin
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  │           └─ firebasecoreexample
   │  │     │  │  │  │     │  │              └─ MainActivity.kt
   │  │     │  │  │  │     │  └─ res
   │  │     │  │  │  │     │     ├─ drawable
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ drawable-v21
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ mipmap-hdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-mdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ values
   │  │     │  │  │  │     │     │  └─ styles.xml
   │  │     │  │  │  │     │     └─ values-night
   │  │     │  │  │  │     │        └─ styles.xml
   │  │     │  │  │  │     └─ profile
   │  │     │  │  │  │        └─ AndroidManifest.xml
   │  │     │  │  │  ├─ build.gradle
   │  │     │  │  │  ├─ gradle
   │  │     │  │  │  │  └─ wrapper
   │  │     │  │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  │  ├─ gradle.properties
   │  │     │  │  │  └─ settings.gradle
   │  │     │  │  ├─ ios
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │     │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  └─ Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.h
   │  │     │  │  │  │  ├─ AppDelegate.m
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  ├─ AppIcon.appiconset
   │  │     │  │  │  │  │  │  ├─ Contents.json
   │  │     │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │     │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │     │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │     │  │  │  │  │  └─ LaunchImage.imageset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ LaunchImage.png
   │  │     │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │     │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │     │  │  │  │  │     └─ README.md
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │     │  │  │  │  │  └─ Main.storyboard
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  └─ main.m
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        └─ IDEWorkspaceChecks.plist
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  └─ main.dart
   │  │     │  │  ├─ macos
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │     │  │  │  │  └─ Flutter-Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ app_icon_1024.png
   │  │     │  │  │  │  │     ├─ app_icon_128.png
   │  │     │  │  │  │  │     ├─ app_icon_16.png
   │  │     │  │  │  │  │     ├─ app_icon_256.png
   │  │     │  │  │  │  │     ├─ app_icon_32.png
   │  │     │  │  │  │  │     ├─ app_icon_512.png
   │  │     │  │  │  │  │     ├─ app_icon_64.png
   │  │     │  │  │  │  │     └─ Contents.json
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  └─ MainMenu.xib
   │  │     │  │  │  │  ├─ Configs
   │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │     │  │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  │  ├─ Release.xcconfig
   │  │     │  │  │  │  │  └─ Warnings.xcconfig
   │  │     │  │  │  │  ├─ DebugProfile.entitlements
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ MainFlutterWindow.swift
   │  │     │  │  │  │  └─ Release.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        ├─ IDEWorkspaceChecks.plist
   │  │     │  │  │        └─ WorkspaceSettings.xcsettings
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ web
   │  │     │  │  │  ├─ favicon.png
   │  │     │  │  │  ├─ icons
   │  │     │  │  │  │  ├─ Icon-192.png
   │  │     │  │  │  │  ├─ Icon-512.png
   │  │     │  │  │  │  ├─ Icon-maskable-192.png
   │  │     │  │  │  │  └─ Icon-maskable-512.png
   │  │     │  │  │  ├─ index.html
   │  │     │  │  │  └─ manifest.json
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  └─ CMakeLists.txt
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ ios
   │  │     │  │  ├─ firebase_core
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ firebase_core
   │  │     │  │  │        ├─ dummy.m
   │  │     │  │  │        ├─ FLTFirebaseCorePlugin.m
   │  │     │  │  │        ├─ FLTFirebasePlugin.m
   │  │     │  │  │        ├─ FLTFirebasePluginRegistry.m
   │  │     │  │  │        ├─ include
   │  │     │  │  │        │  └─ firebase_core
   │  │     │  │  │        │     ├─ dummy.h
   │  │     │  │  │        │     ├─ FLTFirebaseCorePlugin.h
   │  │     │  │  │        │     ├─ FLTFirebasePlugin.h
   │  │     │  │  │        │     ├─ FLTFirebasePluginRegistry.h
   │  │     │  │  │        │     └─ messages.g.h
   │  │     │  │  │        ├─ messages.g.m
   │  │     │  │  │        └─ Resources
   │  │     │  │  ├─ firebase_core.podspec
   │  │     │  │  └─ firebase_sdk_version.rb
   │  │     │  ├─ lib
   │  │     │  │  ├─ firebase_core.dart
   │  │     │  │  └─ src
   │  │     │  │     ├─ firebase.dart
   │  │     │  │     ├─ firebase_app.dart
   │  │     │  │     └─ port_mapping.dart
   │  │     │  ├─ LICENSE
   │  │     │  ├─ macos
   │  │     │  │  ├─ firebase_core
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ firebase_core
   │  │     │  │  │        ├─ dummy.m
   │  │     │  │  │        ├─ FLTFirebaseCorePlugin.m
   │  │     │  │  │        ├─ FLTFirebasePlugin.m
   │  │     │  │  │        ├─ FLTFirebasePluginRegistry.m
   │  │     │  │  │        ├─ include
   │  │     │  │  │        │  ├─ dummy.h
   │  │     │  │  │        │  └─ firebase_core
   │  │     │  │  │        │     ├─ FLTFirebaseCorePlugin.h
   │  │     │  │  │        │     ├─ FLTFirebasePlugin.h
   │  │     │  │  │        │     ├─ FLTFirebasePluginRegistry.h
   │  │     │  │  │        │     └─ messages.g.h
   │  │     │  │  │        ├─ messages.g.m
   │  │     │  │  │        └─ Resources
   │  │     │  │  └─ firebase_core.podspec
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ README.md
   │  │     │  ├─ test
   │  │     │  │  └─ firebase_core_test.dart
   │  │     │  └─ windows
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ firebase_core_plugin.cpp
   │  │     │     ├─ firebase_core_plugin.h
   │  │     │     ├─ firebase_core_plugin_c_api.cpp
   │  │     │     ├─ include
   │  │     │     │  └─ firebase_core
   │  │     │     │     └─ firebase_core_plugin_c_api.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     └─ plugin_version.h.in
   │  │     ├─ firebase_storage
   │  │     │  ├─ android
   │  │     │  │  ├─ build.gradle
   │  │     │  │  ├─ gradle.properties
   │  │     │  │  ├─ settings.gradle
   │  │     │  │  ├─ src
   │  │     │  │  │  └─ main
   │  │     │  │  │     ├─ AndroidManifest.xml
   │  │     │  │  │     └─ java
   │  │     │  │  │        └─ io
   │  │     │  │  │           └─ flutter
   │  │     │  │  │              └─ plugins
   │  │     │  │  │                 └─ firebase
   │  │     │  │  │                    └─ storage
   │  │     │  │  │                       ├─ FlutterFirebaseAppRegistrar.java
   │  │     │  │  │                       ├─ FlutterFirebaseStorageException.java
   │  │     │  │  │                       ├─ FlutterFirebaseStoragePlugin.java
   │  │     │  │  │                       ├─ FlutterFirebaseStorageTask.java
   │  │     │  │  │                       ├─ GeneratedAndroidFirebaseStorage.java
   │  │     │  │  │                       └─ TaskStateChannelStreamHandler.java
   │  │     │  │  └─ user-agent.gradle
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ example
   │  │     │  │  ├─ analysis_options.yaml
   │  │     │  │  ├─ android
   │  │     │  │  │  ├─ app
   │  │     │  │  │  │  ├─ build.gradle
   │  │     │  │  │  │  ├─ google-services.json
   │  │     │  │  │  │  └─ src
   │  │     │  │  │  │     ├─ debug
   │  │     │  │  │  │     │  └─ AndroidManifest.xml
   │  │     │  │  │  │     ├─ main
   │  │     │  │  │  │     │  ├─ AndroidManifest.xml
   │  │     │  │  │  │     │  ├─ java
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  ├─ kotlin
   │  │     │  │  │  │     │  │  └─ io
   │  │     │  │  │  │     │  │     └─ flutter
   │  │     │  │  │  │     │  │        └─ plugins
   │  │     │  │  │  │     │  │           └─ firebasestorageexample
   │  │     │  │  │  │     │  │              └─ MainActivity.kt
   │  │     │  │  │  │     │  └─ res
   │  │     │  │  │  │     │     ├─ drawable
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ drawable-v21
   │  │     │  │  │  │     │     │  └─ launch_background.xml
   │  │     │  │  │  │     │     ├─ mipmap-hdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-mdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ mipmap-xxxhdpi
   │  │     │  │  │  │     │     │  └─ ic_launcher.png
   │  │     │  │  │  │     │     ├─ values
   │  │     │  │  │  │     │     │  └─ styles.xml
   │  │     │  │  │  │     │     └─ values-night
   │  │     │  │  │  │     │        └─ styles.xml
   │  │     │  │  │  │     └─ profile
   │  │     │  │  │  │        └─ AndroidManifest.xml
   │  │     │  │  │  ├─ build.gradle
   │  │     │  │  │  ├─ gradle
   │  │     │  │  │  │  └─ wrapper
   │  │     │  │  │  │     └─ gradle-wrapper.properties
   │  │     │  │  │  ├─ gradle.properties
   │  │     │  │  │  └─ settings.gradle
   │  │     │  │  ├─ assets
   │  │     │  │  │  └─ hello.txt
   │  │     │  │  ├─ cors.json
   │  │     │  │  ├─ ios
   │  │     │  │  │  ├─ firebase_app_id_file.json
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │     │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  └─ Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.h
   │  │     │  │  │  │  ├─ AppDelegate.m
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ Contents.json
   │  │     │  │  │  │  │     ├─ Icon-App-20x20@1x.png
   │  │     │  │  │  │  │     ├─ Icon-App-20x20@2x.png
   │  │     │  │  │  │  │     ├─ Icon-App-20x20@3x.png
   │  │     │  │  │  │  │     ├─ Icon-App-29x29@1x.png
   │  │     │  │  │  │  │     ├─ Icon-App-29x29@2x.png
   │  │     │  │  │  │  │     ├─ Icon-App-29x29@3x.png
   │  │     │  │  │  │  │     ├─ Icon-App-40x40@1x.png
   │  │     │  │  │  │  │     ├─ Icon-App-40x40@2x.png
   │  │     │  │  │  │  │     ├─ Icon-App-40x40@3x.png
   │  │     │  │  │  │  │     ├─ Icon-App-60x60@2x.png
   │  │     │  │  │  │  │     ├─ Icon-App-60x60@3x.png
   │  │     │  │  │  │  │     ├─ Icon-App-76x76@1x.png
   │  │     │  │  │  │  │     ├─ Icon-App-76x76@2x.png
   │  │     │  │  │  │  │     └─ Icon-App-83.5x83.5@2x.png
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │     │  │  │  │  │  └─ Main.storyboard
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  └─ main.m
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  └─ contents.xcworkspacedata
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        └─ IDEWorkspaceChecks.plist
   │  │     │  │  ├─ lib
   │  │     │  │  │  ├─ firebase_options.dart
   │  │     │  │  │  ├─ main.dart
   │  │     │  │  │  └─ save_as
   │  │     │  │  │     ├─ save_as.dart
   │  │     │  │  │     ├─ save_as_html.dart
   │  │     │  │  │     └─ save_as_interface.dart
   │  │     │  │  ├─ macos
   │  │     │  │  │  ├─ firebase_app_id_file.json
   │  │     │  │  │  ├─ Flutter
   │  │     │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │     │  │  │  │  └─ Flutter-Release.xcconfig
   │  │     │  │  │  ├─ Podfile
   │  │     │  │  │  ├─ Runner
   │  │     │  │  │  │  ├─ AppDelegate.swift
   │  │     │  │  │  │  ├─ Assets.xcassets
   │  │     │  │  │  │  │  └─ AppIcon.appiconset
   │  │     │  │  │  │  │     ├─ app_icon_1024.png
   │  │     │  │  │  │  │     ├─ app_icon_128.png
   │  │     │  │  │  │  │     ├─ app_icon_16.png
   │  │     │  │  │  │  │     ├─ app_icon_256.png
   │  │     │  │  │  │  │     ├─ app_icon_32.png
   │  │     │  │  │  │  │     ├─ app_icon_512.png
   │  │     │  │  │  │  │     ├─ app_icon_64.png
   │  │     │  │  │  │  │     └─ Contents.json
   │  │     │  │  │  │  ├─ Base.lproj
   │  │     │  │  │  │  │  └─ MainMenu.xib
   │  │     │  │  │  │  ├─ Configs
   │  │     │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │     │  │  │  │  │  ├─ Debug.xcconfig
   │  │     │  │  │  │  │  ├─ Release.xcconfig
   │  │     │  │  │  │  │  └─ Warnings.xcconfig
   │  │     │  │  │  │  ├─ DebugProfile.entitlements
   │  │     │  │  │  │  ├─ GoogleService-Info.plist
   │  │     │  │  │  │  ├─ Info.plist
   │  │     │  │  │  │  ├─ MainFlutterWindow.swift
   │  │     │  │  │  │  └─ Release.entitlements
   │  │     │  │  │  ├─ Runner.xcodeproj
   │  │     │  │  │  │  ├─ project.pbxproj
   │  │     │  │  │  │  ├─ project.xcworkspace
   │  │     │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │     │  │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │     │  │  │  │  └─ xcshareddata
   │  │     │  │  │  │     └─ xcschemes
   │  │     │  │  │  │        └─ Runner.xcscheme
   │  │     │  │  │  └─ Runner.xcworkspace
   │  │     │  │  │     ├─ contents.xcworkspacedata
   │  │     │  │  │     └─ xcshareddata
   │  │     │  │  │        └─ IDEWorkspaceChecks.plist
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ README.md
   │  │     │  │  ├─ web
   │  │     │  │  │  ├─ favicon.png
   │  │     │  │  │  ├─ icons
   │  │     │  │  │  │  ├─ Icon-192.png
   │  │     │  │  │  │  ├─ Icon-512.png
   │  │     │  │  │  │  ├─ Icon-maskable-192.png
   │  │     │  │  │  │  └─ Icon-maskable-512.png
   │  │     │  │  │  ├─ index.html
   │  │     │  │  │  └─ manifest.json
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  └─ CMakeLists.txt
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ ios
   │  │     │  │  ├─ firebase_storage
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ firebase_storage
   │  │     │  │  │        ├─ firebase_storage_messages.g.m
   │  │     │  │  │        ├─ FLTFirebaseStoragePlugin.m
   │  │     │  │  │        ├─ FLTTaskStateChannelStreamHandler.m
   │  │     │  │  │        ├─ include
   │  │     │  │  │        │  ├─ firebase_storage_messages.g.h
   │  │     │  │  │        │  ├─ FLTFirebaseStoragePlugin.h
   │  │     │  │  │        │  └─ FLTTaskStateChannelStreamHandler.h
   │  │     │  │  │        └─ Resources
   │  │     │  │  ├─ firebase_storage.podspec
   │  │     │  │  └─ generated_firebase_sdk_version.txt
   │  │     │  ├─ lib
   │  │     │  │  ├─ firebase_storage.dart
   │  │     │  │  └─ src
   │  │     │  │     ├─ firebase_storage.dart
   │  │     │  │     ├─ list_result.dart
   │  │     │  │     ├─ reference.dart
   │  │     │  │     ├─ task.dart
   │  │     │  │     ├─ task_snapshot.dart
   │  │     │  │     └─ utils.dart
   │  │     │  ├─ LICENSE
   │  │     │  ├─ macos
   │  │     │  │  ├─ firebase_storage
   │  │     │  │  │  ├─ Package.swift
   │  │     │  │  │  └─ Sources
   │  │     │  │  │     └─ firebase_storage
   │  │     │  │  │        ├─ firebase_storage_messages.g.m
   │  │     │  │  │        ├─ FLTFirebaseStoragePlugin.m
   │  │     │  │  │        ├─ FLTTaskStateChannelStreamHandler.m
   │  │     │  │  │        ├─ include
   │  │     │  │  │        │  ├─ firebase_storage_messages.g.h
   │  │     │  │  │        │  ├─ FLTFirebaseStoragePlugin.h
   │  │     │  │  │        │  └─ FLTTaskStateChannelStreamHandler.h
   │  │     │  │  │        └─ Resources
   │  │     │  │  └─ firebase_storage.podspec
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ README.md
   │  │     │  ├─ test
   │  │     │  │  ├─ firebase_storage_test.dart
   │  │     │  │  ├─ list_result_test.dart
   │  │     │  │  ├─ mock.dart
   │  │     │  │  ├─ reference_test.dart
   │  │     │  │  ├─ task_snapshot_test.dart
   │  │     │  │  ├─ task_test.dart
   │  │     │  │  └─ utils_test.dart
   │  │     │  └─ windows
   │  │     │     ├─ CMakeLists.txt
   │  │     │     ├─ firebase_storage_plugin.cpp
   │  │     │     ├─ firebase_storage_plugin.h
   │  │     │     ├─ firebase_storage_plugin_c_api.cpp
   │  │     │     ├─ include
   │  │     │     │  └─ firebase_storage
   │  │     │     │     └─ firebase_storage_plugin_c_api.h
   │  │     │     ├─ messages.g.cpp
   │  │     │     ├─ messages.g.h
   │  │     │     └─ plugin_version.h.in
   │  │     ├─ image_picker_windows
   │  │     │  ├─ AUTHORS
   │  │     │  ├─ CHANGELOG.md
   │  │     │  ├─ example
   │  │     │  │  ├─ lib
   │  │     │  │  │  └─ main.dart
   │  │     │  │  ├─ pubspec.yaml
   │  │     │  │  ├─ README.md
   │  │     │  │  └─ windows
   │  │     │  │     ├─ CMakeLists.txt
   │  │     │  │     ├─ flutter
   │  │     │  │     │  ├─ CMakeLists.txt
   │  │     │  │     │  └─ generated_plugins.cmake
   │  │     │  │     └─ runner
   │  │     │  │        ├─ CMakeLists.txt
   │  │     │  │        ├─ flutter_window.cpp
   │  │     │  │        ├─ flutter_window.h
   │  │     │  │        ├─ main.cpp
   │  │     │  │        ├─ resource.h
   │  │     │  │        ├─ resources
   │  │     │  │        │  └─ app_icon.ico
   │  │     │  │        ├─ runner.exe.manifest
   │  │     │  │        ├─ Runner.rc
   │  │     │  │        ├─ utils.cpp
   │  │     │  │        ├─ utils.h
   │  │     │  │        ├─ win32_window.cpp
   │  │     │  │        └─ win32_window.h
   │  │     │  ├─ lib
   │  │     │  │  └─ image_picker_windows.dart
   │  │     │  ├─ LICENSE
   │  │     │  ├─ pubspec.yaml
   │  │     │  ├─ README.md
   │  │     │  └─ test
   │  │     │     ├─ image_picker_windows_test.dart
   │  │     │     └─ image_picker_windows_test.mocks.dart
   │  │     └─ path_provider_windows
   │  │        ├─ AUTHORS
   │  │        ├─ CHANGELOG.md
   │  │        ├─ example
   │  │        │  ├─ integration_test
   │  │        │  │  └─ path_provider_test.dart
   │  │        │  ├─ lib
   │  │        │  │  └─ main.dart
   │  │        │  ├─ pubspec.yaml
   │  │        │  ├─ README.md
   │  │        │  ├─ test_driver
   │  │        │  │  └─ integration_test.dart
   │  │        │  └─ windows
   │  │        │     ├─ CMakeLists.txt
   │  │        │     ├─ flutter
   │  │        │     │  ├─ CMakeLists.txt
   │  │        │     │  └─ generated_plugins.cmake
   │  │        │     └─ runner
   │  │        │        ├─ CMakeLists.txt
   │  │        │        ├─ flutter_window.cpp
   │  │        │        ├─ flutter_window.h
   │  │        │        ├─ main.cpp
   │  │        │        ├─ resource.h
   │  │        │        ├─ resources
   │  │        │        │  └─ app_icon.ico
   │  │        │        ├─ runner.exe.manifest
   │  │        │        ├─ Runner.rc
   │  │        │        ├─ run_loop.cpp
   │  │        │        ├─ run_loop.h
   │  │        │        ├─ utils.cpp
   │  │        │        ├─ utils.h
   │  │        │        ├─ win32_window.cpp
   │  │        │        └─ win32_window.h
   │  │        ├─ lib
   │  │        │  ├─ path_provider_windows.dart
   │  │        │  └─ src
   │  │        │     ├─ folders.dart
   │  │        │     ├─ folders_stub.dart
   │  │        │     ├─ guid.dart
   │  │        │     ├─ path_provider_windows_real.dart
   │  │        │     ├─ path_provider_windows_stub.dart
   │  │        │     └─ win32_wrappers.dart
   │  │        ├─ LICENSE
   │  │        ├─ pubspec.yaml
   │  │        ├─ README.md
   │  │        └─ test
   │  │           ├─ guid_test.dart
   │  │           └─ path_provider_windows_test.dart
   │  ├─ generated_plugins.cmake
   │  ├─ generated_plugin_registrant.cc
   │  └─ generated_plugin_registrant.h
   └─ runner
      ├─ CMakeLists.txt
      ├─ flutter_window.cpp
      ├─ flutter_window.h
      ├─ main.cpp
      ├─ resource.h
      ├─ resources
      │  └─ app_icon.ico
      ├─ runner.exe.manifest
      ├─ Runner.rc
      ├─ utils.cpp
      ├─ utils.h
      ├─ win32_window.cpp
      └─ win32_window.h

```