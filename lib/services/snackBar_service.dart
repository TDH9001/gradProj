import 'package:flutter/material.dart';

//HOW TO USE
//1. implement the file > import '../services/snackBar_service.dart';
//2. to summon type > SnackbarService.instance.showSucessSnackBar("string");
//OR >> SnackbarService.instance.showErrorSnackBar("string")

// class SnackbarService {
//   //this calss is for summoning Snackbars in non-screen objects
//   //it only ahs one instance to make it only be summoned once > and not stack
//   BuildContext? _buildcontext;
//   static SnackbarService isntance = SnackbarService();
//   SnackbarService() {}
//   set BuildContext(BuildContext _context) {
//     _buildcontext = _context;
//   }

//   void showErrorSnackBar(String _mesage) {
//     ScaffoldMessenger.of(_buildcontext).showSnackBar(
//       SnackBar(
//         duration: Duration(seconds: 2),
//         content: Text(_mesage,
//             style: const TextStyle(color: Colors.black, fontSize: 15)),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   void showSuccesSnackBar(String _mesage) {
//     ScaffoldMessenger.of(_buildcontext).showSnackBar(
//       SnackBar(
//         duration: Duration(seconds: 2),
//         content: Text(_mesage,
//             style: const TextStyle(color: Colors.black, fontSize: 15)),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
// }

//the whole idea about eh context > is just to tell you which screen u want to apply the action on
//most stuff take contexts > we build them to tell the code > THIS SCREEN DUDE
//this is why we need builders > we setup an envroment > take the context we will work on > apply the action
//to this context
