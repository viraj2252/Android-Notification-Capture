// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_config.dart';
import 'tabs_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'tabs_page.dart';

import 'package:flutter_notification_listener/flutter_notification_listener.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FlutterInjector.instance().flutterLoader().ensureInitializationComplete

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Analytics Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: NotificationsLog(
        title: 'Firebase Analytics Demo',
        analytics: analytics,
        observer: observer,
      ),
    );
  }
}

class NotificationsLog extends StatefulWidget {
  NotificationsLog({
    Key? key,
    required this.title,
    required this.analytics,
    required this.observer,
  }) : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _NotificationsLogState createState() => _NotificationsLogState();
}

class _NotificationsLogState extends State<NotificationsLog> {
  final List<NotificationEvent> _log = [];
  bool started = false;
  bool _loading = false;

  ReceivePort port = ReceivePort();

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // we must use static method, to handle in background
  static void _callback(NotificationEvent evt) {
    try {
      print("send evt to ui: $evt");
      final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
      if (send == null) print("can't find the sender");
      send?.send(evt);
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stackTrace, reason: 'Error in _callback');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      NotificationsListener.initialize(callbackHandle: _callback);

      // this can fix restart<debug> can't handle error
      IsolateNameServer.removePortNameMapping("_listener_");
      IsolateNameServer.registerPortWithName(port.sendPort, "_listener_");
      port.listen((message) => onData(message));

      //Start the listen
      await startListening();

      // don't use the default receivePort
      //NotificationsListener.receivePort?.listen((evt) => onData(evt));

      var isR = await NotificationsListener.isRunning;
      print("""Service is ${!isR! ? "not " : ""}aleary running""");

      setState(() {
        started = isR;
      });
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stackTrace, reason: 'Error in initPlatformState');
    }
  }

  void onData(NotificationEvent event) {
    String platformVersion;

    try {
      //Only capture Discord events
      var packageName = 'discord';
      if(event.packageName.toString().split('.').last != packageName) return;

      setState(() {
        _log.add(event);
      });
      if (event.packageName!.contains(packageName)) {
        // TODO: fix bug
        //NotificationsListener.promoteToForeground("");`
        Bringtoforeground.bringAppToForeground();
        
      }

      //Invoke Analyze and call order API
      NotificationProcessor.process(event);

      print(event.toString());
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stackTrace, reason: 'Error in onData');
    }
  }

  Future<void> startListening() async {
    try {
      print("start listening");
      setState(() {
        _loading = true;
      });
      var hasPermission = await NotificationsListener.hasPermission;
      if (!hasPermission!) {
        print("no permission, so open settings");
        NotificationsListener.openPermissionSettings();
        return;
      }

      var isR = await NotificationsListener.isRunning;

      if (!isR!) {
        await NotificationsListener.startService(
            title: "Listener Running",
            description: "Let's scrape the notifactions...");
      }

      setState(() {
        started = true;
        _loading = false;
      });
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stackTrace, reason: 'Error in startListening');
    }
  }

  void stopListening() async {
    print("stop listening");

    setState(() {
      _loading = true;
    });

    await NotificationsListener.stopService();

    setState(() {
      started = false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Listener Example'),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _log.length,
              reverse: true,
              itemBuilder: (BuildContext context, int idx) {
                final entry = _log[idx];
                return ListTile(
                    trailing:
                        Text(entry.packageName.toString().split('.').last),
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.title ?? "<<no title>>"),
                          Text(entry.text ?? "<<no text>>"),
                          Text(entry.createAt.toString().substring(0, 19)),
                        ],
                      ),
                    ));
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: started ? stopListening : startListening,
        tooltip: 'Start/Stop sensing',
        child: _loading
            ? Icon(Icons.close)
            : (started ? Icon(Icons.stop) : Icon(Icons.play_arrow)),
      ),
    );
  }
}

class NotificationProcessor {
  static void process(NotificationEvent event) {
    //Analyse the topic
    if (event.topic == "order") {
      //Analyze the order
      print("order");
    }

  }
}
