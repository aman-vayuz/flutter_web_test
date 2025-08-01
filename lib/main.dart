// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String _sharedPrefValue = 'No data saved';
//   String _secureStorageValue = 'No data saved';
//
//   @override
//   void initState() {
//     super.initState();
//     _saveAndReadData();
//   }
//
//   Future<void> _saveAndReadData() async {
//     // Shared Preferences
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('normalStorage', 'Shared Preferences!'); // Setting a string value with the key 'my_shared_preference_key'
//
//     // Flutter Secure Storage
//     const FlutterSecureStorage secureStorage = FlutterSecureStorage();
//     await secureStorage.write(key: 'secureStoreage', value: 'Tsecure token!');
//
//     // Read and update UI
//     _sharedPrefValue = prefs.getString('my_shared_preference_key') ?? 'No data found in Shared Preferences';
//     _secureStorageValue = await secureStorage.read(key: 'secureStoreage') ?? 'No data found in Secure Storage';
//
//     setState(() {}); // Updates the UI with the retrieved values
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Storage Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Storage Demo'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const Text(
//                 'Data in SharedPreferences:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(_sharedPrefValue),
//               const SizedBox(height: 20),
//               const Text(
//                 'Data in Flutter Secure Storage:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(_secureStorageValue),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init(); // Load login state from shared prefs
  runApp(MyApp());
}

/// AuthService handles login state + SharedPreferences
class AuthService {
  static late SharedPreferences _prefs;
  static RxBool isLoggedIn = false.obs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = _prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> login() async {
    isLoggedIn.value = true;
    await _prefs.setBool('isLoggedIn', true);
  }

  static Future<void> logout() async {
    isLoggedIn.value = false;
    await _prefs.setBool('isLoggedIn', false);
  }
}

/// Root widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Web Get.to() + SharedPrefs',
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        // If user is logged in, start at dashboard, else login
        return AuthService.isLoggedIn.value ? DashboardScreen() : LoginScreen();
      }),
    );
  }
}

/// Login Screen
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("LoginScreen built");

    // Redirect to dashboard if already logged in
    if (AuthService.isLoggedIn.value) {
      Future.microtask(() => Get.offAll(() => DashboardScreen()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          child: Text('Login'),
          onPressed: () async {
            await AuthService.login();
            Get.offAll(() => DashboardScreen());
          },
        ),
      ),
    );
  }
}

/// Dashboard Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    print("DashboardScreen built");

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Dashboard!'),
            SizedBox(height: 20),
            RichText(
                text: TextSpan(
                    text: "Username is", children: [TextSpan(text: userName)])),

            ElevatedButton(
              onPressed: () => Get.to(() => ProfileScreen()),
              onLongPress: (){getUserName();},
              child: Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void getUserName() async {
    final _prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = _prefs.getString('userName') ?? '';
    });
  }
}

/// Profile Screen
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("ProfileScreen built");
    return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(
          child: Column(children: [
            TextField(
              onSubmitted: (val) async {
                if (val.trim().isEmpty) return;
                final _prefs = await SharedPreferences.getInstance();
                _prefs.setString('userName', val);
              },
            ),
            Text('This is your profile page.')
          ]),
        ));
  }
}
