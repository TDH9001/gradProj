// import 'package:flutter/material.dart';
//
// import '../widgets/customtextfield.dart';
//
// class Resetpassword extends StatelessWidget {
//   const Resetpassword({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 32),
//               const Text(
//                 'Create your Account',
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
//               const SizedBox(height: 16),
//               Customtextfield(
//                 hintText: 'Confirm Password',
//                 isPassword: true,
//                 onChanged: (value) {},
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1A237E),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Reset Password',
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
