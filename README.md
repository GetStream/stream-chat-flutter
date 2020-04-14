# Flutter Chat Components

<a href="https://getstream.io/chat/"><img src="https://i.imgur.com/L4Mj8S2.png" alt="Flutter Chat" /></a>

> The official Flutter components for Stream Chat, a service for
> building chat applications.

[![Pub](https://img.shields.io/pub/v/stream_chat_flutter.svg)](https://pub.dartlang.org/packages/stream_chat_flutter)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
![CI](https://github.com/GetStream/stream-chat-flutter/workflows/CI/badge.svg?branch=master)
[![codecov](https://codecov.io/gh/GetStream/stream-chat-flutter/branch/master/graph/badge.svg)](https://codecov.io/gh/GetStream/stream-chat-flutter)
[![Gitter](https://badges.gitter.im/GetStream/stream-chat-flutter.svg)](https://gitter.im/GetStream/stream-chat-flutter?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

**Quick Links**

- [Register](https://getstream.io/chat/trial/) to get an API key for Stream Chat
- [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/) 
- [Chat UI Kit](https://getstream.io/chat/ui-kit/)

## Flutter Chat Tutorial

The best place to start is the [Flutter Chat Tutorial](https://getstream.io/chat/flutter/tutorial/).
It teaches you how to use this SDK and also shows how to make common changes.

## Example App

This repo includes a fully functional example app with setup instructions.
The example is available under the [example](https://github.com/GetStream/stream-chat-flutter/tree/master/example) folder.

## Add dependency

```yaml
dependencies:
 stream_chat_flutter: ^0.1.19
```

You should then run `flutter packages get`

### Alpha version

Use version `^0.2.0-alpha+2` to use the latest available version.

Note that this is still an alpha version. There may be some bugs and the api can change in breaking ways.

Thanks to whoever tries these versions and reports bugs or suggestions.

### Android

All set ✅

### iOS

The library uses [flutter file picker plugin](https://github.com/miguelpruivo/flutter_file_picker) to pick
files from the os.
Follow [this wiki](https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#ios) to fulfill iOS requirements.

We also use [video_player](https://pub.dev/packages/video_player) to reproduce videos. Follow [this guide](https://pub.dev/packages/video_player#installation) to fulfill the requirements.

To pick images from the camera we use the [image_picker](https://pub.dev/packages/image_picker) plugin.
Follow [these instructions](https://pub.dev/packages/image_picker#ios) to check the requirements.

## Docs

### Business logic components

We provide 3 Widgets dedicated to business logic and state management:

- [StreamChat](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/StreamChat-class.html)
- [StreamChannel](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/StreamChannel-class.html)
- [ChannelsBloc](https://pub.dev/documentation/stream_chat_flutter/0.2.0-alpha+2/stream_chat_flutter/ChannelsBloc-class.html)

### UI Components

These are the available Widgets that you can use to build your application UI.
Every widget uses the `StreamChat` or `StreamChannel` widgets to manage the state and communicate with Stream services.

- [ChannelHeader](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelHeader-class.html)
- [ChannelImage](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelImage-class.html)
- [ChannelListView](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelListView-class.html)
- [ChannelName](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelName-class.html)
- [ChannelPreview](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ChannelPreview-class.html)
- [MessageInput](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/MessageInput-class.html)
- [MessageListView](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/MessageListView-class.html)
- [MessageWidget](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/MessageWidget-class.html)
- [StreamChatTheme](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/StreamChatTheme-class.html)
- [ThreadHeader](https://pub.dev/documentation/stream_chat_flutter/latest/stream_chat_flutter/ThreadHeader-class.html)

### Customizing styles

The Flutter SDK comes with a fully designed set of widgets which you can customize to fit with your application style and typography.
Changing the theme of Chat widgets works in a very similar way that `MaterialApp` and `Theme` do.

Out of the box all chat widgets use their own default styling, there are two ways to change the styling:

  1. Initialize the `StreamChatTheme` from your existing `MaterialApp` style
  ```dart
  class MyApp extends StatelessWidget {
    final Client client;

    MyApp(this.client);

    @override
    Widget build(BuildContext context) {
      final theme = ThemeData(
        primarySwatch: Colors.green,
      );

      return MaterialApp(
        theme: theme,
        home: Container(
          child: StreamChat(
           streamChatThemeData: StreamChatThemeData.fromTheme(theme),
            client: client,
            child: ChannelListPage(),
          ),
        ),
      );
    }
  }
  ```

  2. Construct a custom theme and provide all the customizations needed
  ```dart
  class MyApp extends StatelessWidget {
    final Client client;

    MyApp(this.client);

    @override
    Widget build(BuildContext context) {
      final theme = ThemeData(
        primarySwatch: Colors.green,
      );

      return MaterialApp(
        theme: theme,
        home: Container(
          child: StreamChat(
            streamChatThemeData: StreamChatThemeData.fromTheme(theme).copyWith(
              ownMessageTheme: MessageTheme(
                messageBackgroundColor: Colors.black,
                messageText: TextStyle(
                  color: Colors.white,
                ),
                avatarTheme: AvatarTheme(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            client: client,
            child: ChannelListPage(),
          ),
        ),
      );
    }
  }
  ```
  
### Offline storage 

By default the library saves information about channels and messages in a SQLite DB.

Set the property `persistenceEnabled` to false if you don't want to use the offline storage.

### Push notifications

To enable push notifications set the property `pushNotificationsEnabled` to `true`.

#### Android

Follow the guide at [this link](https://pub.dev/packages/firebase_messaging#android-integration) to setup Firebase for Android.

Set the notification template on your GetStream dashboard to be like this:
```json
template = {}

data template = {
    "message_id": "{{ message.id }}"
}
```

Create a Application.kt file to be like this:
```kotlin
class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        PathProviderPlugin.registerWith(registry?.registrarFor(
                "io.flutter.plugins.pathprovider.PathProviderPlugin"))
        SharedPreferencesPlugin.registerWith(registry?.registrarFor(
                "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"))
        FlutterLocalNotificationsPlugin.registerWith(registry?.registrarFor(
                "com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
        FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
    }
}
```

Update the `AndroidManifest.xml` file to set the application class:
```xml
...
    <uses-permission android:name="android.permission.INTERNET"/>
    <application
        android:name=".Application"
        android:label="example"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
...
```

##### Customizing notifications

To customize notifications pass a function as the named parameter `androidNotificationHandler` to the `Client` constructor.

It has to be a top-level function or a static method.

The class `NotificationService` provides some helper methods to use to handle the notification.

You can start from this template to write the `androidNotificationHandler` function:

```dart
Future<void> _handleAndroidNotification(
  Map<String, dynamic> notification,
) async {
  // get message information from the backend and store it in the offline storage
  final notificationData = await NotificationService.getAndStoreMessage(notification);

  // define the android channel specifics
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'Message notifications',
    'Message notifications',
    'Channel dedicated to message notifications',
    importance: Importance.Max,
    priority: Priority.High,
  );

  // define the appearance of the notification
  final androidNotificationOptions = AndroidNotificationOptions(
    androidNotificationDetails: androidPlatformChannelSpecifics,
    id: notificationData.message.id.hashCode,
    title:
        'CUSTOM ${notificationData.message.user.name} @ ${notificationData.channel.cid}',
    body: notificationData.message.text,
  );

  // actually show the notification
  await NotificationService.showNotification(androidNotificationOptions);
}
```

#### iOS

Make sure you have correctly configured your app to support push notifications, and that you have generated certificate/token for sending pushes.

##### Offline support and customizing notifications

On iOS we need to create a notification service extension.

Follow these points to configure it

- open the XCode project
- create a new target of type `Notification service extension`
- add `App Groups` capability to the `Runner` target and the just created one and create one common group
- add the line `pod 'StreamChatClient'` to the Podfile
- run `pod install`
- substitute the code in the `Notification service` with [this one](https://gist.github.com/imtoori/d37611faefef036e1a6c017b1a09e91f) and substitute APPGROUP with the just created one
- do the same with `AppDelegate.swift` using [this template](https://gist.github.com/imtoori/f95b30f25b745c5f777bfff1085176ef)
- set the notification template on your GetStream dashboard to be like this:
```handlebars
template = {
    "aps" : {
        "alert" : {
            "title" : "{{ sender.name }} @ {{ channel.name }}",
            "body" : "{{ message.text }}"
        },
        "badge": {{ unread_count }},
        "apns-priority": 10,
        "mutable-content" : 1
    },
    "message_id": "{{ message.id }}"
}
```
Of course you can change the `alert` object as you want. Just make sure it has the last three lines.

To customize notifications on iOS you need to do it in the Notification service. 

There is no way of doing it using Dart code at the moment because of framework restrictions.

## Contributing

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are very happy to merge your code in the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.
