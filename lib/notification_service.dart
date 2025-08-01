// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// // Notification configuration
// const int callNotificationId = 1001;
// const String callChannelId = 'call_channel';
// const String callChannelName = 'Incoming Calls';
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _initializeNotifications();
//   runApp(MyApp());
// }
//
// Future<void> _initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   // Create notification channel (Android 8.0+)
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     callChannelId,
//     callChannelName,
//     importance: Importance.max,
//     playSound: true,
//   );
//
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//       AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Call App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: CallScreen(),
//     );
//   }
// }
//
// class CallScreen extends StatefulWidget {
//   @override
//   _CallScreenState createState() => _CallScreenState();
// }
//
// class _CallScreenState extends State<CallScreen> with WidgetsBindingObserver {
//   bool _inCall = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     _removeNotification(); // Clean up when widget is disposed
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     print("___________________________${state.name}");
//     if (state == AppLifecycleState.detached) {
//       // App is being closed/killed
//       _removeNotification();
//     } else if (state == AppLifecycleState.paused && _inCall) {
//       // App going to background - keep notification
//       _showOngoingNotification();
//     }
//   }
//
//   Future<void> _showOngoingNotification() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       callChannelId,
//       callChannelName,
//       importance: Importance.max,
//       priority: Priority.high,
//       ongoing: true,
//       playSound: false,
//       enableVibration: false,
//       showWhen: false,
//       autoCancel: false,
//     );
//
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       callNotificationId,
//       'Ongoing Call',
//       'You are in a call',
//       notificationDetails,
//     );
//   }
//
//   Future<void> _removeNotification() async {
//     await flutterLocalNotificationsPlugin.cancel(callNotificationId);
//   }
//
//   void _toggleCall() {
//     setState(() {
//       _inCall = !_inCall;
//       if (_inCall) {
//         _showOngoingNotification();
//       } else {
//         _removeNotification();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Call App')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _toggleCall,
//           child: Text(_inCall ? 'End Call' : 'Start Call'),
//         ),
//       ),
//     );
//   }
// }