// import 'package:flutter/material.dart';
// import 'package:grad_proj/login_screens/resetpassword.dart';
// import 'package:grad_proj/login_screens/sinup_screen.dart';
// import '../widgets/customtextfield.dart';
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 90),
//               const Text(
//                 'Login to your Account',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1F2937),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),
//               Customtextfield(
//                 hintText: 'Email',
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 16),
//               Customtextfield(
//                 hintText: 'Password',
//                 isPassword: true,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff7AB2D3),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Sign in',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const Row(
//                 children: [
//                   Expanded(child: Divider()),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'Or sign in with',
//                       style: TextStyle(
//                         color: Color(0xFF6B7280),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                   Expanded(child: Divider()),
//                 ],
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Don't have an account? ",
//                     style: TextStyle(color: Color(0xFF6B7280)),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const SinupScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Sign up',
//                       style: TextStyle(
//                         color: Color(0xff7AB2D3),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "forgot password? ",
//                     style: TextStyle(color: Color(0xFF6B7280)),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const Resetpassword(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Reset',
//                       style: TextStyle(
//                         color: Color(0xff7AB2D3),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
