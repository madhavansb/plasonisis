// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'firebase_options.dart';
// import 'screens/auth_screen.dart';
// import 'screens/home_screen.dart';
// import 'services/auth_service.dart'; // We'll create this
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//
//   ); // Initialize Firebase
//   runApp(const PlasonisisApp());
// }
//
// class PlasonisisApp extends StatelessWidget {
//   const PlasonisisApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<AuthService>(
//           create: (_) => AuthService(),
//         ),
//         StreamProvider<User?>(
//           create: (context) => context.read<AuthService>().authStateChanges,
//           initialData: null,
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Plasonisis',
//         theme: ThemeData(
//           primarySwatch: Colors.green,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           fontFamily: GoogleFonts.poppins().fontFamily, // Example using Google Fonts
//           appBarTheme: AppBarTheme(
//             backgroundColor: Colors.green.shade700,
//             foregroundColor: Colors.white,
//             centerTitle: true,
//             titleTextStyle: GoogleFonts.poppins(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           cardTheme: CardTheme(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green.shade600,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               textStyle: GoogleFonts.poppins(fontSize: 18),
//             ),
//           ),
//           inputDecorationTheme: InputDecorationTheme(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(color: Colors.green.shade300),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(color: Colors.green.shade700, width: 2),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: const BorderSide(color: Colors.red, width: 2),
//             ),
//             filled: true,
//             fillColor: Colors.green.shade50.withOpacity(0.5),
//             labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
//             hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
//           ),
//         ),
//         home: const AuthWrapper(),
//       ),
//     );
//   }
// }
//
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final firebaseUser = context.watch<User?>();
//
//     if (firebaseUser != null) {
//       return const HomeScreen();
//     }
//     return const AuthScreen();
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart'; // Directly go to home

void main() {
  runApp(const PlasonisisApp());
}

class PlasonisisApp extends StatelessWidget {
  const PlasonisisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plasonisis',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomeScreen(), // Directly open home
    );
  }
}
